import pandas as pd
import sqlite3 as sql

df = pd.read_csv(
    "data/Partecipazione-della-popolazione-al-mercato-del-lavoro-per-regione.csv",
    encoding="latin1",
    sep=";"
)

df = df.rename(
    columns={
        "Percentuale forze di lavoro in eta 15-64 anni": "percentuale_occupazione"
    }
)

def interpolazione(df, colonne):
    for c in colonne:
        df[c] = df[c].interpolate(method="linear", limit_direction="both")
    return df

df_pulito = interpolazione(df, ['percentuale_occupazione'])

conn = sql.connect("database.db")

cursor = conn.cursor()

for _, row in df_pulito.iterrows():
    #, perché è una tupla con un solo elemento, execute si aspetta una tupla
    regione_id = cursor.execute("SELECT id FROM regioni WHERE nome = ?", (row["Regione"],)).fetchone()[0]
    #prende il primo elemento (id)
    cursor.execute("INSERT INTO occupazione(anno, id_regione, percentuale) VALUES (?, ?, ?)", (row["Anno"], regione_id, row["percentuale_occupazione"]))

conn.commit()
conn.close()
