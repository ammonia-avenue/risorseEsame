import sqlite3
import pandas as pd

# Connessione al database
conn = sqlite3.connect('pesca.db')

# Funzione per interpolare i dati mancanti
def interpolate_missing_data(df, columns):
    for col in columns:
        df[col] = df[col].interpolate(method='linear')
    return df

# Interpolazione dei dati mancanti
for table, column in [('occupazione_pesca', 'occupazione'),
                      ('economia_pesca', 'importanza_economica'),
                      ('produttivita_pesca', 'produttivita')]:
    df = pd.read_sql_query(f"SELECT * FROM {table}", conn)
    df = interpolate_missing_data(df, [column])
    df.to_sql(table, conn, if_exists='replace', index=False)

conn.close()
