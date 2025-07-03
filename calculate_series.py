import sqlite3
import pandas as pd

def query_db(query: str, params: tuple = ()):
    conn = sqlite3.connect('pesca.db')
    df = pd.read_sql_query(query, conn, params=params)
    conn.close()
    return df

# Connessione al database
conn = sqlite3.connect('pesca.db')
cursor = conn.cursor()

# Creazione delle tabelle per le serie calcolate
cursor.execute('''
CREATE TABLE IF NOT EXISTS produttivita_totale_aree (
    anno INTEGER,
    area_geografica TEXT,
    produttivita_totale FLOAT,
    PRIMARY KEY (anno, area_geografica)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS produttivita_totale_nazionale (
    anno INTEGER,
    produttivita_totale FLOAT,
    PRIMARY KEY (anno)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS media_percentuale_valore_aggiunto_aree (
    anno INTEGER,
    area_geografica TEXT,
    media_percentuale_valore_aggiunto FLOAT,
    PRIMARY KEY (anno, area_geografica)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS media_variazione_percentuale_occupazione_nazionale (
    anno INTEGER,
    media_variazione_percentuale_occupazione FLOAT,
    PRIMARY KEY (anno)
)
''')
cursor.execute('''
CREATE TABLE IF NOT EXISTS media_variazione_percentuale_occupazione_aree (
    anno INTEGER,
    area_geografica TEXT,
    media_variazione_percentuale_occupazione FLOAT,
    PRIMARY KEY (anno, area_geografica)
)
''')

# Query per ottenere i dati necessari
query_produttivita = "SELECT * FROM produttivita_pesca"
query_importanza = "SELECT * FROM economia_pesca"
query_occupazione = "SELECT * FROM occupazione_pesca"
query_regioni = "SELECT * FROM regioni"

df_produttivita = query_db(query_produttivita)
df_importanza = query_db(query_importanza)
df_occupazione = query_db(query_occupazione)
df_regioni = query_db(query_regioni)

# Unione dei dati con le regioni per ottenere le aree geografiche
df_produttivita = pd.merge(df_produttivita, df_regioni, left_on='regione_id', right_on='id')
df_importanza = pd.merge(df_importanza, df_regioni, left_on='regione_id', right_on='id')
df_occupazione = pd.merge(df_occupazione, df_regioni, left_on='regione_id', right_on='id')

# Calcolo della produttività totale per area geografica
produttivita_totale_aree = df_produttivita.groupby(['anno', 'area_geografica'])['produttivita'].sum().reset_index()
produttivita_totale_nazionale = df_produttivita.groupby(['anno'])['produttivita'].sum().reset_index()

# Calcolo della media percentuale valore aggiunto per area geografica
media_percentuale_valore_aggiunto_aree = df_importanza.groupby(['anno', 'area_geografica'])['importanza_economica'].mean().reset_index()

# Calcolo della media variazione percentuale occupazione nazionale e per area geografica
media_variazione_percentuale_occupazione_nazionale = df_occupazione.groupby(['anno'])['occupazione'].mean().reset_index()
media_variazione_percentuale_occupazione_aree = df_occupazione.groupby(['anno', 'area_geografica'])['occupazione'].mean().reset_index()

# Inserimento dei dati calcolati nel database
produttivita_totale_aree.to_sql('produttivita_totale_aree', conn, if_exists='replace', index=False)
produttivita_totale_nazionale.to_sql('produttivita_totale_nazionale', conn, if_exists='replace', index=False)
media_percentuale_valore_aggiunto_aree.to_sql('media_percentuale_valore_aggiunto_aree', conn, if_exists='replace', index=False)
media_variazione_percentuale_occupazione_nazionale.to_sql('media_variazione_percentuale_occupazione_nazionale', conn, if_exists='replace', index=False)
media_variazione_percentuale_occupazione_aree.to_sql('media_variazione_percentuale_occupazione_aree', conn, if_exists='replace', index=False)

conn.close()
