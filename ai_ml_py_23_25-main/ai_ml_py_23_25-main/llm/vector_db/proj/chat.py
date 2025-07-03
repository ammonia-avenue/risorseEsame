from llama_index.llms.ollama import Ollama

from llama_index.core.llms import ChatMessage, MessageRole
from llama_index.core.chat_engine import SimpleChatEngine


from llama_index.core.storage.chat_store import SimpleChatStore
from llama_index.core.memory import ChatMemoryBuffer



# ===========
# CHAT
# ===========
class Chat:
    def __init__(self, 
                 user_id: str = "user",
                 model_name: str = "llama3.2:1b",
                 temperature: float = 0.5, 
                 top_p: float = 0.5, 
                 system_: str = "", ) -> None:

        # model
        model = Ollama(model=model_name, 
                         temperature=temperature,
                         top_p=top_p)


        # history
        memory = ChatMemoryBuffer.from_defaults(
             token_limit=3000,
            chat_store=SimpleChatStore(),
            chat_store_key="user1"
        )
    
        # prompt
        prefix_system = [ChatMessage(role=MessageRole.SYSTEM, content=system_)]
    
        # chat engine
        self.engine = SimpleChatEngine(llm=model, 
                                     memory=memory, 
                                     prefix_messages=prefix_system)

    def get_history(self):
        return self.engine.chat_history

    def complete(self, message_: str):
        return self.engine.chat(message_)
        




