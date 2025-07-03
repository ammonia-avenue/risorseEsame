from llama_index.core import SimpleDirectoryReader
from llama_index.core.node_parser import SentenceSplitter
from sentence_transformers import SentenceTransformer

from pathlib import Path

CHUNK_SIZE_256  = 256
CHUNK_SIZE_512  = 512
CHUNK_SIZE_1024 = 1024
CHUNK_SIZE_2048 = 2024


class DocumentPayload:
    def __init__(self,  model, splitter,  doc):
        splits = splitter.split_text(doc.text)
        self.ids: list[str] = [doc.metadata["page_label"] + str(i) for i in range(len(splits))]
        self.embeddings = model.encode(splits).tolist()
        self.splits = splits



class DocumentLoader:
    def __init__(self,
                 path,
                 chunk_size=CHUNK_SIZE_1024,
                 chunk_overlap=20):

        self.path = path
        self.model = SentenceTransformer('all-MiniLM-L6-v1')
        self.splitter = SentenceSplitter(chunk_size=chunk_size,
                                         chunk_overlap=chunk_overlap)

    def load_documents(self) -> list[DocumentPayload]:
        data = SimpleDirectoryReader(self.path).load_data()

        chunks: list[DocumentPayload] = []
        for doc in data:
            chunks.append(DocumentPayload(self.model,
                                          self.splitter,
                                          doc))
        return chunks


# TEST

if __name__ == '__main__':
    dataset = DocumentLoader(Path(__file__).resolve().parent / "dataset", chunk_size=CHUNK_SIZE_512)
    docs = dataset.load_documents()


