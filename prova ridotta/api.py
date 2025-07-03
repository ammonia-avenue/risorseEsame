from fastapi import FastAPI
from typing import Optional
import sqlite3
import pandas as pd

app = FastAPI

def query_db(query: str, params: tuple = ()):
    conn = sqlite3.connect('database.db')
    df = pd.read_sql_query(query, conn, params=params)
    conn.close()
    return df

@app.get("/partecipazione_area")
def get_partecipazione_area(da_anno: Optional[int] = None, a_anno: Optional[int] = None):
    query = "SELECT * FROM partecipazione_area"
    params = []
    if da_anno and a_anno:
        query += "WHERE anno BETWEEN ? AND ?"
        params.extend([da_anno, a_anno])
    df = query_db(query, tuple(params))
    return df.to_dict(orient='records')