# MPV Multi-Audio Track Mixer - Enhanced Audio Experience for MPV Player  
# MPV Multi-Audio Track Mixer - Улучшенный опыт работы с несколькими аудиодорожками  

---

## 🌟 Overview | Обзор  

**EN:**  
This Lua script for MPV allows **simultaneous playback of multiple audio tracks** with individual volume control and mute options. It supports both numeric keypad and standard keyboard hotkeys, features an OSD volume interface, and automatically remembers per-track volume across sessions.  

**RU:**  
Этот Lua-скрипт для MPV позволяет **одновременно воспроизводить несколько аудиодорожек** с индивидуальной регулировкой громкости и возможностью выключения звука. Поддерживаются горячие клавиши как для цифровой клавиатуры, так и для обычной, предусмотрен OSD-интерфейс для громкости и автоматическое сохранение настроек громкости между сессиями.  

---

## 🔑 Key Features | Ключевые особенности  

**EN:**  
- Per-track volume control with persistent saving  
- OSD interface with volume bars and active track indicator  
- Mute toggle per track  
- Supports both numpad and non-numpad keyboards  
- Automatic activation of all audio tracks on file load  

**RU:**  
- Индивидуальная регулировка громкости с сохранением настроек  
- OSD-интерфейс с индикаторами громкости и текущей дорожки  
- Возможность отключения звука для выбранной дорожки  
- Поддержка клавиатур с NumPad и без него  
- Автоматическая активация всех аудиодорожек при загрузке файла  

---

## ⚙️ Technical Details | Технические детали  

**EN:**  
- Compatibility: MPV Player (tested on [mpv-winbuild](https://github.com/zhongfly/mpv-winbuild/releases))  
- Language: Lua  
- License: MIT  
- Status: Active stable script  

**RU:**  
- Совместимость: MPV Player (тестировалось на [mpv-winbuild](https://github.com/zhongfly/mpv-winbuild/releases))  
- Язык: Lua  
- Лицензия: MIT  
- Статус: Стабильный рабочий скрипт  

---

## 📥 Installation | Установка  

**EN (Portable version):**  
1. Download the script: [multi-audio.lua](multi-audio.lua)  
2. Place it into:  <MPV.exe directory>\portable_config\scripts\\>


**RU (Portable-версия):**  
1. Скачайте скрипт: [multi-audio.lua](multi-audio.lua)  
2. Поместите его в директорию:  <MPV.exe directory>\portable_config\scripts\\>

**Scripts directory | Директория для скрипта**

%APPDATA%\mpv\scripts\multi-audio.lua



---

## ⌨️ Controls | Управление  

| Numpad Key | Non-Numpad Key | EN Description          | RU Описание                  |  
|------------|----------------|-------------------------|------------------------------|  
| `NumPad 8` | `Ctrl + ↑`     | Select previous track   | Предыдущая дорожка           |  
| `NumPad 2` | `Ctrl + ↓`     | Select next track       | Следующая дорожка            |  
| `NumPad 4` | `Ctrl + ←`     | Decrease volume (step)  | Уменьшить громкость (шаг)    |  
| `NumPad 6` | `Ctrl + →`     | Increase volume (step)  | Увеличить громкость (шаг)    |  
| `NumPad 5` | `Ctrl + M`     | Toggle mute             | Вкл/выкл звук                |  
| `NumPad -` | `Ctrl + -`     | Large decrease volume   | Уменьшить громкость (много)  |  
| `NumPad +` | `Ctrl + =`     | Large increase volume   | Увеличить громкость (много)  |  

---

## 📂 Example Directory Structure | Пример структуры папок  

```
MPV_portable/
├── mpv.exe
├── mpv.conf
└── portable_config/
└── scripts/
└── multi-audio.lua
```

---

## ℹ️ Notes | Важные замечания  

**EN:**  
- Saves per-track volumes globally and restores them automatically.  
- Works out-of-the-box with no dependencies.  
- Provided under MIT license.  

**RU:**  
- Громкость дорожек сохраняется глобально и восстанавливается автоматически.  
- Работает "из коробки", без зависимостей.  
- Распространяется под лицензией MIT.  

