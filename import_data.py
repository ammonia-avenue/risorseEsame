import pandas as pd
import requests
from io import StringIO
import sqlite3

# URL dei dataset
occupazione_url = 'https://raw.githubusercontent.com/AlbertoPuggioniITS/dataset/main/Andamento-occupazione-del-settore-della-pesca-per-regione.csv'
importanza_url = 'https://raw.githubusercontent.com/AlbertoPuggioniITS/dataset/main/Importanza-economica-del-settore-della-pesca-per-regione.csv'
produttivita_url = 'https://raw.githubusercontent.com/AlbertoPuggioniITS/dataset/main/Produttivita-del-settore-della-pesca-per-regione.csv'

# Funzione per importare e processare i dati
def import_data(url):
    response = requests.get(url)
    if response.status_code == 200:
        csv_content = StringIO(response.text)
        df = pd.read_csv(csv_content, sep=';')
        df.columns = [col.replace('�', 'à') for col in df.columns]
        return df
    else:
        print(f"Errore nell'importazione dei dati da {url}")
        return None

df_occupazione = import_data(occupazione_url)
df_importanza = import_data(importanza_url)
df_produttivita = import_data(produttivita_url)

# Modifica i nomi delle colonne in base ai dati reali
df_occupazione = df_occupazione.rename(columns={
    'Variazione percentuale unita di lavoro della pesca': 'occupazione'
})
df_importanza = df_importanza.rename(columns={
    'Percentuale valore aggiunto pesca-piscicoltura-servizi': 'importanza_economica'
})
df_produttivita = df_produttivita.rename(columns={
    'Produttivita in migliaia di euro': 'produttivita'
})

# Funzione per normalizzare i dati mancanti tramite interpolazione
def interpolate_missing_data(df, columns):
    for col in columns:
        df[col] = df[col].interpolate(method='linear')
    return df

df_occupazione = interpolate_missing_data(df_occupazione, ['occupazione'])
df_importanza = interpolate_missing_data(df_importanza, ['importanza_economica'])
df_produttivita = interpolate_missing_data(df_produttivita, ['produttivita'])

# Connessione al database
conn = sqlite3.connect('pesca.db')
cursor = conn.cursor()

# Inserimento dei dati nelle tabelle
for _, row in df_occupazione.iterrows():
    regione_id = cursor.execute("SELECT id FROM regioni WHERE nome = ?", (row['Regione'],)).fetchone()[0]
    cursor.execute('INSERT INTO occupazione_pesca (regione_id, anno, occupazione) VALUES (?, ?, ?)',
                   (regione_id, row['Anno'], row['occupazione']))

for _, row in df_importanza.iterrows():
    regione_id = cursor.execute("SELECT id FROM regioni WHERE nome = ?", (row['Regione'],)).fetchone()[0]
    cursor.execute('INSERT INTO economia_pesca (regione_id, anno, importanza_economica) VALUES (?, ?, ?)',
                   (regione_id, row['Anno'], row['importanza_economica']))

for _, row in df_produttivita.iterrows():
    regione_id = cursor.execute("SELECT id FROM regioni WHERE nome = ?", (row['Regione'],)).fetchone()[0]
    cursor.execute('INSERT INTO produttivita_pesca (regione_id, anno, produttivita) VALUES (?, ?, ?)',
                   (regione_id, row['Anno'], row['produttivita']))

conn.commit()
conn.close()
