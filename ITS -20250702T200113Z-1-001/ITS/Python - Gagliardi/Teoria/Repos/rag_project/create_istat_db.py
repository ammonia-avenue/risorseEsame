from documnt_loader import DocumentLoader
from vector_db import VectorDb
from pathlib import Path

VECDB_FILE = str(Path(__file__).resolve().parent / "vdb" / "istat_db")

if __name__ == '__main__':
    db = VectorDb(VECDB_FILE)
    collection = db.get_collection("istat")

    dataset = DocumentLoader(Path(__file__).resolve().parent / "dataset", chunk_size=256)
    docs = dataset.load_documents()

    for doc in docs:
        collection.add(doc.splits, doc.embeddings, doc.ids)






