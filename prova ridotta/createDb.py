import sqlite3 as sql

conn = sql.connect("database.db")
cursor = conn.cursor()

cursor.execute(
    '''
    CREATE TABLE IF NOT EXISTS regioni(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        area TEXT
    )
'''
)

cursor.execute(
    '''
    CREATE TABLE IF NOT EXISTS occupazione(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anno INTEGER,
        id_regione INTEGER,
        percentuale REAL,
        FOREIGN KEY(id_regione) REFERENCES regioni(id) 
    )
'''
)

regioni = [
    ('Valle d\'Aosta', 'Nord-ovest'),
    ('Piemonte', 'Nord-ovest'),
    ('Liguria', 'Nord-ovest'),
    ('Lombardia', 'Nord-ovest'),
    ('Trentino-Alto Adige', 'Nord-est'),
    ('Veneto', 'Nord-est'),
    ('Friuli-Venezia Giulia', 'Nord-est'),
    ('Emilia-Romagna', 'Nord-est'),
    ('Toscana', 'Centro'),
    ('Umbria', 'Centro'),
    ('Marche', 'Centro'),
    ('Lazio', 'Centro'),
    ('Abruzzo', 'Centro'),
    ('Molise', 'Sud'),
    ('Campania', 'Sud'),
    ('Puglia', 'Sud'),
    ('Basilicata', 'Sud'),
    ('Calabria', 'Sud'),
    ('Sicilia', 'Isole'),
    ('Sardegna', 'Isole')
]

cursor.executemany('INSERT INTO regioni (nome, area) VALUES (?, ?)', regioni)

conn.commit()
conn.close()