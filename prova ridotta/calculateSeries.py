import sqlite3
import pandas as pd

def query_db(query: str, params: tuple = ()):
    conn = sqlite3.connect('database.db')
    df = pd.read_sql_query(query, conn, params=params)
    conn.close()
    return df

conn = sqlite3.connect("database.db")
cursor = conn.cursor()

#partecipazione per anno e area
cursor.execute(
    '''
    CREATE TABLE IF NOT EXISTS partecipazione_area(
        anno INTEGER,
        area TEXT,
        tot_partecipazione REAL,
        PRIMARY KEY(anno, area)
    )
'''
)

#partecipazione totale per anno
cursor.execute(
    '''
    CREATE TABLE IF NOT EXISTS partecipazione_tot(
        anno INTEGER,
        tot_partecipazione REAL,
        PRIMARY KEY(anno)
    )
'''
)


#recupero dati
df_partecipazione = query_db("SELECT * FROM occupazione")
df_regioni = query_db("SELECT * FROM regioni")

#join
df_partecipazione = pd.merge(df_partecipazione, df_regioni, left_on="id_regione", right_on="id")

#aggregazioni
df_partecipazione_aree = df_partecipazione.groupby(["anno", "area"])["percentuale"].sum().reset_index()

df_partecipazione_tot = df_partecipazione.groupby(["anno"])["percentuale"].sum().reset_index()

#rinomino prima di spostare i dati nella tabella
df_partecipazione_aree.rename(columns={"percentuale": "tot_partecipazione"}, inplace=True)

df_partecipazione_tot.rename(columns={"percentuale": "tot_partecipazione"}, inplace=True)

#sposto dati in una tabella

df_partecipazione_aree.to_sql("partecipazione_area", conn, if_exists="append", index=False)

df_partecipazione_tot.to_sql("partecipazione_tot", conn, if_exists="append", index=False)

conn.close()
