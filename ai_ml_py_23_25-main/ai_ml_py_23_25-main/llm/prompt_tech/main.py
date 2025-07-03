
"""
CHINOOK DB:  https://www.sqlitetutorial.net/sqlite-sample-database/

albums          employees       invoices        playlists
artists         genres          media_types     tracks
customers       invoice_items   playlist_track
"""

from sqlalchemy import (create_engine)


from llama_index.llms.ollama import Ollama
from llama_index.core import SQLDatabase
from llama_index.core.query_engine import NLSQLTableQueryEngine




if __name__ == "__main__":
    
    llm = Ollama(model="llama3.2:1b")


    engine = create_engine("sqlite:///db/chinook.db")
    sql_database = SQLDatabase(engine)


    query_engine = NLSQLTableQueryEngine(
        sql_database=sql_database,
        tables=["albums", "tracks", "artists"],
        llm=llm,
        embed_model='local'
    )
    
    response = query_engine.query(
        "What are some tracks from the artist AC/DC? Limit it to 3"
        )

    print(response)

