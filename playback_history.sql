CREATE TABLE playback_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    duration INTEGER,
    playback_date TEXT NOT NULL,
    playback_time TEXT NOT NULL,
    completed BOOLEAN DEFAULT 0
);