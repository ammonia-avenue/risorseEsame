import chromadb

from documnt_loader import DocumentPayload
from sentence_transformers import SentenceTransformer


class VectorCollection:
    def __init__(self, collection):
        self.collection = collection
        self.model = SentenceTransformer('all-MiniLM-L6-v1')


    def add(self, documents, embeddings, ids):
        self.collection.add(documents=documents,
                            embeddings=embeddings,
                            ids=ids)

    def add_from_payload(self, doc_: DocumentPayload):
        return self.add(doc_.splits,
                        doc_.embeddings,
                        doc_.ids)

    def query(self, text, n_results=10):
        text_embedding = self.model.encode(text)
        return self.collection.query([text_embedding],
                                     n_results=n_results)



class VectorDb:
    def __init__(self, db_path):
        self.client = chromadb.PersistentClient(db_path)

    def get_collection(self, collection_name) -> VectorCollection:
        return VectorCollection(self.client.get_or_create_collection(name=collection_name))


