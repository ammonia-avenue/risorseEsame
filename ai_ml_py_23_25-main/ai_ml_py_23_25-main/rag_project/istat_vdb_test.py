from vector_db import VectorDb
from pathlib import Path

VECDB_FILE = str(Path(__file__).resolve().parent / "vdb" / "istat_db")




if __name__ == '__main__':
    db = VectorDb(VECDB_FILE)
    collection = db.get_collection("istat")

    response = collection.query("Cosa contiene il rappoorto del 2023?", n_results=4)

    for doc in response["documents"]:
        for chunk in doc:
            print(chunk)

