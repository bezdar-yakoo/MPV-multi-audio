local mp = require "mp"
local msg = require "mp.msg"
local utils = require "mp.utils"

-- Параметры
local SAVE_FILE = mp.command_native({"expand-path", "~~/track_volumes.json"})
local STEP = 0.1
local LARGE_STEP = 0.25
local OSD_TIME = 3

-- Состояния
local track_volumes = {}
local active_tracks = {}
local current_edit_track = nil
local osd_timer = nil
local global_volumes = {}

-- ========== JSON УТИЛИТЫ ==========
local function load_saved()
    local f = io.open(SAVE_FILE, "r")
    if not f then return {} end
    local content = f:read("*a")
    f:close()
    local ok, tbl = pcall(utils.parse_json, content)
    if ok and type(tbl) == "table" then return tbl end
    return {}
end

local function save_all(tbl)
    local ok, content = pcall(utils.format_json, tbl)
    if not ok then return end
    local f, err = io.open(SAVE_FILE, "w")
    if not f then msg.warn("cannot write save file: "..(err or "nil")); return end
    f:write(content)
    f:close()
end

-- ========== СИГНАТУРА ДОРОЖКИ ==========
local function track_signature(track)
    local lang = track.lang or "UNK"
    local codec = track.codec or "NA"
    local chans = track["demux-channel-count"] or "?"
    return lang .. "|" .. codec .. "|" .. chans
end

-- ========== LAVFI ==========
local function rebuild_audio_graph()
    local parts, amix_inputs, ids = {}, {}, {}
    for id,_ in pairs(active_tracks) do table.insert(ids, id) end
    if #ids == 0 then
        mp.set_property("lavfi-complex", "")
        return
    end
    table.sort(ids)
    for _, id in ipairs(ids) do
        local volume = track_volumes[id] or 1.0
        if #ids == 1 then
            local p = string.format("[aid%d]volume=%.3f:eval=frame[ao]", id, volume)
            table.insert(parts, p)
        else
            table.insert(parts, string.format("[aid%d]volume=%.3f:eval=frame[a%d]", id, volume, id))
            table.insert(amix_inputs, string.format("[a%d]", id))
        end
    end
    local graph
    if #ids == 1 then
        graph = table.concat(parts, "; ")
    else
        graph = table.concat(parts, "; ") .. "; " ..
                table.concat(amix_inputs, "") .. string.format("amix=inputs=%d[ao]", #ids)
    end
    mp.set_property("lavfi-complex", graph)
end

-- ========== OSD ==========
local function show_osd(text, dur)
    mp.osd_message(text, dur or OSD_TIME)
    if osd_timer then osd_timer:kill() end
    osd_timer = mp.add_timeout(dur or OSD_TIME, function() mp.osd_message("", 0); osd_timer = nil end)
end

local function show_volume_ui()
    local osd_text = "Громкость дорожек:\n"
    local tracks = mp.get_property_native("track-list", {})
    local has_audio = false
    for _, track in ipairs(tracks) do
        if track.type == "audio" and active_tracks[track.id] then
            has_audio = true
            local vol = track_volumes[track.id] or 1.0
            local marker = (track.id == current_edit_track) and "▶ " or "  "
            local lang = track.lang and track.lang:upper() or "UNK"
            local bar_length = 20
            local filled = math.floor(vol * bar_length + 0.5)
            if filled < 0 then filled = 0 end
            if filled > bar_length then filled = bar_length end
            local progress_bar = string.rep("█", filled) .. string.rep("░", bar_length - filled)
            osd_text = osd_text .. string.format("%s%s (%.0f%%): %s\n",
                marker, lang .. " (" .. (track.codec or "?") .. ")", vol*100, progress_bar)
        end
    end
    if not has_audio then
        osd_text = osd_text .. "Нет активных аудио дорожек"
    else
        osd_text = osd_text .. "\nКлавиши: Ctrl+↑↓ выбор, Ctrl+←→ громкость, Ctrl+M mute"
    end
    show_osd(osd_text, OSD_TIME)
end

-- ========== ВЫБОР ДОРОЖКИ ==========
local function select_next_track(direction)
    local tracks = {}
    for id, _ in pairs(active_tracks) do table.insert(tracks, id) end
    if #tracks == 0 then return end
    table.sort(tracks)
    local current_index = 1
    if current_edit_track then
        for i, id in ipairs(tracks) do if id == current_edit_track then current_index = i; break end end
    end
    local new_index = current_index + direction
    if new_index < 1 then new_index = #tracks
    elseif new_index > #tracks then new_index = 1 end
    current_edit_track = tracks[new_index]
    show_volume_ui()
end

-- ========== ГРОМКОСТЬ ==========
local mute_store = {}
local function adjust_volume(delta)
    if not current_edit_track then select_next_track(1); return end
    local new_vol = (track_volumes[current_edit_track] or 1.0) + delta
    new_vol = math.max(0.0, math.min(10.0, new_vol))
    track_volumes[current_edit_track] = new_vol

    local tracks = mp.get_property_native("track-list", {})
    for _, t in ipairs(tracks) do
        if t.id == current_edit_track then
            local sig = track_signature(t)
            global_volumes[sig] = new_vol
            save_all(global_volumes)
            break
        end
    end

    rebuild_audio_graph()
    show_volume_ui()
end

local function toggle_mute()
    if not current_edit_track then select_next_track(1); return end
    local id = current_edit_track
    if (track_volumes[id] or 1.0) > 0 and (mute_store[id] == nil) then
        mute_store[id] = track_volumes[id]
        track_volumes[id] = 0.0
    else
        track_volumes[id] = mute_store[id] or 1.0
        mute_store[id] = nil
    end
    rebuild_audio_graph()
    show_volume_ui()
end

-- ========== ИНИЦИАЛИЗАЦИЯ ==========
local function init_tracks()
    active_tracks = {}
    current_edit_track = nil
    track_volumes = {}
    local tracks = mp.get_property_native("track-list", {})
    for _, track in ipairs(tracks) do
        if track.type == "audio" then
            active_tracks[track.id] = true
            local sig = track_signature(track)
            if global_volumes[sig] then
                track_volumes[track.id] = global_volumes[sig]
            else
                track_volumes[track.id] = 1.0
            end
        end
    end
    rebuild_audio_graph()
end

-- ========== ГОРЯЧИЕ КЛАВИШИ ==========
mp.add_key_binding("ctrl+UP", "select-prev-track", function() select_next_track(-1) end)
mp.add_key_binding("ctrl+DOWN", "select-next-track", function() select_next_track(1) end)

mp.add_key_binding("ctrl+LEFT", "decrease-track-volume", function() adjust_volume(-STEP) end)
mp.add_key_binding("ctrl+RIGHT", "increase-track-volume", function() adjust_volume(STEP) end)

mp.add_key_binding("ctrl+m", "toggle-mute-track", toggle_mute)

mp.add_key_binding("ctrl+-", "large-decrease", function() adjust_volume(-LARGE_STEP) end)
mp.add_key_binding("ctrl+=", "large-increase", function() adjust_volume(LARGE_STEP) end)

-- ========== СТАРТ ==========
global_volumes = load_saved()
mp.register_event("file-loaded", init_tracks)
mp.observe_property("track-list", "native", function() init_tracks() end)
if mp.get_property("path") ~= nil then init_tracks() end
