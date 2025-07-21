local input = require "mp.input"
local msg = require "mp.msg"

-- Глобальные состояния
local track_volumes = {}       -- Хранит громкости дорожек (id -> volume)
local active_tracks = {}        -- Активные дорожки (id -> true)
local current_edit_track = nil  -- Текущая редактируемая дорожка
local osd_timer = nil           -- Таймер скрытия OSD

-- Показывает OSD сообщение
local function show_osd(message, duration)
    mp.osd_message(message, duration or 2)
end

-- Форматирование информации о дорожке
local function format_track(track)
    local bitrate = track["demux-bitrate"] or track["hls-bitrate"]
    local flags = ""
    
    for _, flag in ipairs({
        "default", "forced", "dependent", "visual-impaired", "hearing-impaired",
        "image", "external"
    }) do
        if track[flag] then
            flags = flags .. flag .. " "
        end
    end
    
    flags = flags ~= "" and " [" .. flags:sub(1, -2) .. "]" or ""
    
    return (track.selected and "●" or "○") ..
        (track.title and " " .. track.title or "") ..
        " (" .. (
            (track.lang and track.lang .. " " or "") ..
            (track.codec and track.codec .. " " or "") ..
            (track["demux-w"] and track["demux-w"] .. "x" .. track["demux-h"] .. " " or "") ..
            (track["demux-fps"] and not track.image and 
             string.format("%.4f", track["demux-fps"]):gsub("%.?0*$", "") .. " fps " or "") ..
            (track["demux-channel-count"] and track["demux-channel-count"] .. "ch " or "") ..
            (track["codec-profile"] and track.type == "audio" and track["codec-profile"] .. " " or "") ..
            (track["demux-samplerate"] and (track["demux-samplerate"] / 1000) .. " kHz " or "") ..
            (bitrate and string.format("%.0f", bitrate / 1000) .. " kbps " or "")
        ):sub(1, -2) .. ")" .. flags
end

-- Построение аудио-графа с учетом громкостей
local function rebuild_audio_graph()
    local graph = ""
    local amix_inputs = ""
    local count = 0
    
    for id, _ in pairs(active_tracks) do
        count = count + 1
        local volume = track_volumes[id] or 1.0
        graph = graph .. string.format("[aid%d] volume=volume=%.2f:eval=frame [a%d]; ", id, volume, id)
        amix_inputs = amix_inputs .. string.format("[a%d]", id)
    end
    
    if count == 0 then
        mp.set_property("lavfi-complex", "")
        return
    end
    
    graph = graph .. amix_inputs .. string.format(" amix=inputs=%d [ao]", count)
    mp.set_property("lavfi-complex", graph)
end

-- Инициализация дорожек при загрузке файла
local function init_tracks()
    track_volumes = {}
    active_tracks = {}
    current_edit_track = nil
    
    for _, track in ipairs(mp.get_property_native("track-list", {})) do
        if track.type == "audio" then
            active_tracks[track.id] = true
            track_volumes[track.id] = 1.0  -- По умолчанию 100% громкость
        end
    end
    
    rebuild_audio_graph()
end

-- Показ UI управления громкостями
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
            local title = track.title or ("Дорожка " .. track.id)
            
            -- Прогресс-бар
            local bar_length = 20
            local filled = math.floor(vol * bar_length + 0.5)
            local progress_bar = string.rep("█", filled) .. string.rep("░", bar_length - filled)
            
            osd_text = osd_text .. string.format(
                "%s%s (%.0f%%): %s\n",
                marker, lang, vol * 100, progress_bar
            )
        end
    end
    
    if not has_audio then
        osd_text = osd_text .. "Нет активных аудио дорожек"
    else
        osd_text = osd_text .. "\nКлавиши: Ctrl+↑↓ выбор, Ctrl+←→ громкость"
    end
    
    mp.osd_message(osd_text, 3)
    
    -- Сброс таймера скрытия OSD
    if osd_timer then
        osd_timer:kill()
    end
    osd_timer = mp.add_timeout(3, function()
        mp.osd_message("", 0)
        osd_timer = nil
    end)
end

-- Выбор дорожки для редактирования
local function select_next_track(direction)
    local tracks = {}
    for id, _ in pairs(active_tracks) do
        table.insert(tracks, id)
    end
    
    if #tracks == 0 then return end
    
    table.sort(tracks)
    local current_index = 1
    
    if current_edit_track then
        for i, id in ipairs(tracks) do
            if id == current_edit_track then
                current_index = i
                break
            end
        end
    end
    
    local new_index = current_index + direction
    if new_index < 1 then new_index = #tracks
    elseif new_index > #tracks then new_index = 1 end
    
    current_edit_track = tracks[new_index]
    show_volume_ui()
end

-- Изменение громкости текущей дорожки
local function adjust_volume(delta)
    if not current_edit_track then
        select_next_track(1)
        return
    end
    
    local new_vol = (track_volumes[current_edit_track] or 1.0) + delta
    new_vol = math.max(0.0, math.min(1.0, new_vol))
    track_volumes[current_edit_track] = new_vol
    
    rebuild_audio_graph()
    show_volume_ui()
end

-- Привязка клавиш для управления
mp.add_key_binding("Ctrl+UP", "select-prev-track", function() select_next_track(-1) end)
mp.add_key_binding("Ctrl+DOWN", "select-next-track", function() select_next_track(1) end)
mp.add_key_binding("Ctrl+LEFT", "decrease-track-volume", function() adjust_volume(-0.1) end)
mp.add_key_binding("Ctrl+RIGHT", "increase-track-volume", function() adjust_volume(0.1) end)
mp.add_key_binding("Ctrl+Shift+LEFT", "large-decrease", function() adjust_volume(-0.25) end)
mp.add_key_binding("Ctrl+Shift+RIGHT", "large-increase", function() adjust_volume(0.25) end)

-- Инициализация при загрузке файла
mp.register_event("file-loaded", init_tracks)
if mp.get_property("path") ~= nil then
    init_tracks()
end