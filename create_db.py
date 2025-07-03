import sqlite3

# Connessione al database
conn = sqlite3.connect('pesca.db')
cursor = conn.cursor()

# Creazione delle tabelle
cursor.execute('''
CREATE TABLE IF NOT EXISTS regioni (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    area_geografica TEXT
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS economia_pesca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    regione_id INTEGER,
    anno INTEGER,
    importanza_economica FLOAT,
    FOREIGN KEY (regione_id) REFERENCES regioni(id)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS occupazione_pesca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    regione_id INTEGER,
    anno INTEGER,
    occupazione FLOAT,
    FOREIGN KEY (regione_id) REFERENCES regioni(id)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS produttivita_pesca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    regione_id INTEGER,
    anno INTEGER,
    produttivita FLOAT,
    FOREIGN KEY (regione_id) REFERENCES regioni(id)
)
''')

# Inserimento delle regioni e aree geografiche
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

cursor.executemany('INSERT INTO regioni (nome, area_geografica) VALUES (?, ?)', regioni)

conn.commit()
conn.close()
