# MPV Multi-Audio Track Mixer - Enhanced Audio Experience for MPV Player

## Оптимизированное описание для лучшего SEO

### 🌟 Лучший способ слушать несколько аудиодорожек одновременно в MPV!

Этот скрипт Lua для MPV позволяет воспроизводить **несколько аудиодорожек одновременно** с индивидуальной регулировкой громкости каждой дорожки. Идеальное решение для:

- Прослушивания комментариев режиссера вместе с основной дорожкой
- Сравнения дубляжей на разных языках
- Анализа звукового оформления фильмов
- Изучения языков с параллельным воспроизведением

### 🔑 Ключевые особенности

- **Индивидуальная громкость** для каждой аудиодорожки
- **Интуитивное управление** с клавиатуры
- **Автоматическая активация** всех дорожек при загрузке
- **Визуальный OSD-интерфейс** с прогресс-барами
- **Портативная установка** без дополнительных зависимостей

### ⚙️ Технические детали

- Совместимость: **MPV Player** (тестировано на [mpv-winbuild](https://github.com/zhongfly/mpv-winbuild/releases))
- Язык: Lua
- Лицензия: MIT
- Статус: **Стабильная версия** (не планируются дальнейшие улучшения)

---

## English Version

### 🌟 Ultimate Multi-Audio Experience for MPV Player!

This Lua script for MPV enables **simultaneous playback of multiple audio tracks** with individual volume control for each track. Perfect for:

- Listening to director's commentary with main audio
- Comparing language dubs side-by-side
- Analyzing film sound design
- Language learning with parallel audio tracks

### 🔑 Key Features

- **Per-track volume control**
- **Keyboard-centric workflow**
- **Automatic activation** of all audio tracks
- **Visual OSD interface** with progress bars
- **Portable installation** with no dependencies

### ⚙️ Technical Specifications

- Compatibility: **MPV Player** (tested with [mpv-winbuild](https://github.com/zhongfly/mpv-winbuild/releases))
- Language: Lua
- License: MIT
- Status: **Stable release** (no further improvements planned)

---

## 📥 Установка | Installation

### Для Portable-версии MPV:
1. Скачайте скрипт: [multi-audio.lua](multi-audio.lua)
2. Поместите файл в директорию:
   ```
   <MPV.exe directory>\portable_config\scripts\
   ```

### Для стандартной установки MPV:
```
%APPDATA%\mpv\scripts\multi-audio.lua
```

### 📋 Требования | Requirements
- Современная версия MPV Player (рекомендуется mpv-winbuild)
- Поддержка Lua в MPV
- Windows (тестировалось на Windows 10/11)

---

## ⌨️ Управление | Controls

| Комбинация              | Действие                          | Combination             | Action                            |
|-------------------------|-----------------------------------|-------------------------|-----------------------------------|
| `Ctrl + ↑`              | Предыдущая дорожка                | `Ctrl + ↑`              | Previous track                    |
| `Ctrl + ↓`              | Следующая дорожка                 | `Ctrl + ↓`              | Next track                        |
| `Ctrl + →`              | +10% громкости                    | `Ctrl + →`              | +10% volume                       |
| `Ctrl + ←`              | -10% громкости                    | `Ctrl + ←`              | -10% volume                       |
| `Ctrl + Shift + →`      | +25% громкости                    | `Ctrl + Shift + →`      | +25% volume                       |
| `Ctrl + Shift + ←`      | -25% громкости                    | `Ctrl + Shift + ←`      | -25% volume                       |

---

## ℹ️ Важная информация | Important Notes

Этот скрипт был создан с помощью **DeepSeek** и предоставляется "как есть". Автор не планирует дальнейшую поддержку или развитие проекта. Тем не менее, скрипт полностью функционален и готов к использованию.

This script was created using **DeepSeek** and is provided "as is". The author does not plan to maintain or improve it further. However, the script is fully functional and ready to use.

---

## 📂 Пример структуры папок | Example Directory Structure
```
MPV_portable/
├── mpv.exe
├── mpv.conf
└── portable_config/
    └── scripts/
        └── multi-audio.lua  <-- Основной скрипт
```

---

## 🔎 Почему этот репозиторий уникален? | Why This Repository Stands Out

- **Единственное решение** для параллельного прослушивания аудиодорожек в MPV
- **Оптимизировано для реального использования** без лишних функций
- **Простая установка** - всего один файл Lua
- **Не требует настройки** - работает сразу после установки
- **Полностью бесплатно** с открытым исходным кодом (MIT License)

Если вы искали "mpv multiple audio tracks", "mpv audio mixer" или "how to play two audio tracks in mpv" - вы нашли идеальное решение!