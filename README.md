# VLC Playback History Plugin Installation

## Prerequisites

1. **VLC Media Player**: Ensure VLC version 3.0.21 Vetinari is installed.
2. **Lua Support**: Confirm Lua scripting is enabled in VLC.
3. **SQLite3**: Install SQLite3 and its Lua bindings (`lsqlite3`) for database support.
4. **VS Code**: Set up Visual Studio Code as your IDE for editing the Lua script.

---

## Steps to Install the Plugin

### 1. Save the Lua Script

- Save the `vlc_playback_history.lua` file to the following directory:
  - macOS: `~/Library/Application Support/org.videolan.vlc/lua/extensions/`
  - Windows: `%APPDATA%\vlc\lua\extensions\`
  - Linux: `~/.local/share/vlc/lua/extensions/`

### 2. Initialize the Database

- Open VLC once to allow the script to create the SQLite database at:
  - macOS: `~/Library/Application Support/org.videolan.vlc/vlc_playback_history.db`
  - Other platforms: Equivalent user VLC data directory.

### 3. Verify Plugin Activation

- Launch VLC.
- Navigate to `View` -> `Playback History Logger` to ensure the plugin is loaded.
- Play a video, and the playback history will be logged automatically.

---

## Viewing Playback History

El historial se guarda automáticamente en dos formatos:

1. Base de datos SQLite: `~/Library/Application Support/org.videolan.vlc/vlc_playback_history.db`
2. Archivo CSV: `~/Library/Application Support/org.videolan.vlc/playback_history.csv`

Para acceder al historial CSV:

```bash
open ~/Library/Application\ Support/org.videolan.vlc/playback_history.csv
```

El archivo CSV se actualiza automáticamente cada vez que reproduces un video y puede abrirse con:

- Numbers
- Microsoft Excel
- Vista previa
- Cualquier editor de texto

---

## Troubleshooting

- If the plugin does not appear:
  1. Ensure the Lua script is in the correct directory.
  2. Check VLC logs for errors (`Tools` -> `Messages`).
  3. Verify Lua scripting is enabled in VLC preferences.

- If the database is not created:
  1. Confirm `lsqlite3` is installed.
  2. Check file permissions for the VLC user data directory.

### Validación de Instalación

Para verificar que todo está instalado correctamente:

1. Ejecutar en terminal:

```bash
brew list | grep sqlite
lua -e "require 'lsqlite3'"
```

1. Confirmar permisos:

```bash
ls -l ~/Library/Application\ Support/org.videolan.vlc/
```
