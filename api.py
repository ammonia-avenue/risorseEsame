from fastapi import FastAPI
from typing import Optional
import sqlite3
import pandas as pd

app = FastAPI(
    title="API del Settore della Pesca",
    description="Questa API fornisce dati sulla produttività, l'occupazione e l'importanza economica del settore della pesca nelle varie regioni e aree geografiche italiane.",
    version="1.0.0",
    contact={
        "name": "Alberto Puggioni",
        "url": "https://github.com/AlbertoPuggioniITS/simulazione_prova",
        "email": "alberto.puggioni@edu.itspiemonte.it",
    },
    license_info={
        "name": "MIT License",
        "url": "https://opensource.org/licenses/MIT",
    },
)

def query_db(query: str, params: tuple = ()):
    conn = sqlite3.connect('pesca.db')
    df = pd.read_sql_query(query, conn, params=params)
    conn.close()
    return df

@app.get("/produttivita_totale_aree")
def get_produttivita_totale_aree(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM produttivita_totale_aree"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')

@app.get("/produttivita_totale_nazionale")
def get_produttivita_totale_nazionale(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM produttivita_totale_nazionale"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')

@app.get("/media_percentuale_valore_aggiunto_aree")
def get_media_percentuale_valore_aggiunto_aree(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM media_percentuale_valore_aggiunto_aree"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')

@app.get("/media_variazione_percentuale_occupazione_nazionale")
def get_media_variazione_percentuale_occupazione_nazionale(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM media_variazione_percentuale_occupazione_nazionale"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')

@app.get("/media_variazione_percentuale_occupazione_aree")
def get_media_variazione_percentuale_occupazione_aree(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM media_variazione_percentuale_occupazione_aree"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')

@app.get("/dati_brutti")
def get_dati_brutti(da_anno: Optional[int] = None, a_anno: Optional[int] = None, tabella: str = 'economia_pesca'):
    query = f"SELECT * FROM {tabella}"
    params = []
    if da_anno and a_anno:
        query += " WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')
