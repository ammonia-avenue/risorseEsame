# Assuming there is a chromadb module that provides Client, Database, Table, etc.
from pathlib import Path
import json
import chromadb
from llama_index.core import SimpleDirectoryReader
from llama_index.core.node_parser import SentenceSplitter
from sentence_transformers import SentenceTransformer
from chromadb.config import Settings

# Getting the current directory path using pathlib
CURRENT_PATH_DIRECTORY = Path(__file__).resolve().parent



class VectorCollection:
    def __init__(self, collection, model):
        self.collection = collection
        self.model   = model
        self.splitter = SentenceSplitter(chunk_size=1024,
                                         chunk_overlap=20)

    def insert_document(self, file_path):
        data = SimpleDirectoryReader(file_path).load_data()

        for doc in data:

            splits = self.splitter.split_text(doc.text)
            embeddings = self.model.encode(splits).tolist()

            info = doc.metadata
            ids = [info["page_label"] + str(i) for i in range(len(splits))]
            self.collection.add(documents=splits,
                                embeddings=embeddings,
                                ids=ids)

    def embeddings(self, messages: list[str]):
        return self.model.encode(messages).tolist()


    def query(self, query_embeddings, n_results=2):
        return self.collection.query(
            query_embeddings=query_embeddings,
            n_results=n_results  # Number of similar documents to retrieve
        )

class VectorDbClient:
    def __init__(self, db_path):
        self.client = chromadb.PersistentClient(db_path)
        self.model = SentenceTransformer('all-MiniLM-L6-v2')

    def collection(self, collection_name):
        return VectorCollection(collection=self.client.get_or_create_collection(name=collection_name),
                                model=self.model)

    def embeddings(self, messages: list[str]):
        return self.model.encode(messages).tolist()

if __name__ == '__main__':
   dataset_folder  = CURRENT_PATH_DIRECTORY.joinpath("dataset")
   database_folder = CURRENT_PATH_DIRECTORY.joinpath("vdb/")

   vdb = VectorDbClient(str(database_folder))
   coll = vdb.collection("test")
   coll.insert_document(str(dataset_folder))

   query = "Scrivi una breve spiegazione sugli ammassi di galassie"
   query_embedding = coll.embeddings([query])

   results = coll.query(query_embedding)
   print("Query:", query)
   for doc, score in zip(results["documents"][0], results["distances"][0]):
       print("\n")
       print(f"Document: {doc} \n Score: {score}")
       print("\n")