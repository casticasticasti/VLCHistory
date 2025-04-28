-- VLC Lua Extension: Playback History Logger

-- Required Libraries
local sqlite3 = require("lsqlite3") -- Add SQLite3 Lua binding to your environment

-- Database Initialization
local db_path = vlc.config.userdatadir() .. "/vlc_playback_history.db"
local db = sqlite3.open(db_path)

-- Create table if it doesn't exist
db:exec([[
CREATE TABLE IF NOT EXISTS playback_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    playback_date TEXT NOT NULL,
    playback_time TEXT NOT NULL
);
]])

-- Configurar ruta del CSV
local csv_path = vlc.config.userdatadir() .. "/playback_history.csv"

-- Función para exportar a CSV
local function export_to_csv()
    if not db then return end

    local file = io.open(csv_path, "w")
    if not file then
        vlc.msg.err("No se pudo abrir el archivo CSV")
        return
    end

    -- Escribir encabezados
    file:write("Fecha,Hora,Archivo,Duración,Completado\n")

    -- Exportar datos
    for row in db:rows("SELECT * FROM playback_history ORDER BY playback_date DESC, playback_time DESC") do
        local line = string.format("%s,%s,%s,%s,%s\n",
            row.playback_date,
            row.playback_time,
            row.file_path:gsub(",", ";"), -- Escapar comas
            row.duration or "N/A",
            row.completed and "Sí" or "No"
        )
        file:write(line)
    end

    file:close()
end

-- Modificar la función log_playback para exportar después de cada inserción
local function log_playback(file_path)
    if not db then return end

    local success, err = pcall(function()
        local date = os.date("%Y-%m-%d")
        local time = os.date("%H:%M:%S")
        local stmt = db:prepare("INSERT INTO playback_history (file_path, playback_date, playback_time) VALUES (?, ?, ?)")
        stmt:bind_values(file_path, date, time)
        stmt:step()
        stmt:finalize()
    end)

    if not success then
        vlc.msg.err("Error logging playback: " .. tostring(err))
    end

    if success then
        export_to_csv() -- Exportar después de cada inserción exitosa
    end
end

-- VLC Hook: Triggered on Playback Start
function input_changed()
    local item = vlc.input.item()
    if item then
        local file_path = item:uri()
        if file_path then
            file_path = vlc.strings.decode_uri(file_path)
            log_playback(file_path)
        end
    end
end

-- Activate the Extension
function activate()
    vlc.msg.info("Playback History Logger Activated")
end

-- Deactivate the Extension
function deactivate()
    vlc.msg.info("Playback History Logger Deactivated")
    db:close()
end

-- Trigger Playback Hook
function meta_changed()
    -- Call input_changed when metadata changes
    input_changed()
end