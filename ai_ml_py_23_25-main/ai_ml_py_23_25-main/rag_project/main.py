
import gradio as gr

from chat import Chat

from vector_db import VectorDb
from pathlib import Path

from prompt_istat import get_system_istat_prompt

VECDB_FILE = str(Path(__file__).resolve().parent / "vdb" / "istat_db")

def search(query: str) -> str:
    db = VectorDb(VECDB_FILE)
    collection = db.get_collection("istat")

    response = collection.query("Cosa contiene il rappoorto del 2023?", n_results=4)

    out = ""
    for doc in response["documents"]:
        for chunk in doc:
            out += chunk + "\n"
    return out


chat = Chat(user_id="User",
            temperature=0.2, 
            top_p=0.1,
            system_= "")


def chat_ui(message, history):

    response =   chat.complete(message_= get_system_istat_prompt(
        context=search(message),
        text=message
    ))
    return str(response)


if __name__ == "__main__":
    gr.ChatInterface(chat_ui, type="messages").launch()