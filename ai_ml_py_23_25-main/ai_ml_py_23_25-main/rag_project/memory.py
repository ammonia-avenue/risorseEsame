from llama_index.core.memory import ChatMemoryBuffer
from llama_index.core.llms import ChatMessage, MessageRole


class  Memory:
    def __init__(self,  token_limit: int = 3000):
        self.buffer = ChatMemoryBuffer(token_limit=token_limit)


    def add_messages(self , messages: list[ChatMessage]):
        self.buffer.put_messages(messages)


    def add_user_message(self, message: str):
        self.buffer.put(ChatMessage(role=MessageRole.USER,
                                    content=message))

    def add_assistant_message(self, message: str):
        self.buffer.put(ChatMessage(role=MessageRole.ASSISTANT,
                                    content=message))

    def get(self):
        self.buffer.get()
