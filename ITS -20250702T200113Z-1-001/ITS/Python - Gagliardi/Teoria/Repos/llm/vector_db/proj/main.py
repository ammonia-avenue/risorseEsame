

import gradio as gr



from chat import Chat

# ======================================
# SYSTEM PROMPT
# ======================================



CONTEXT = \
"""<CONTEXT>


"""


INSTRUCTION = \
"""<INSTRUCTION>


"""




OUTPUT = \
"""<OUTPUT>



"""


SYSTEM = \
CONTEXT + \
INSTRUCTION + \
OUTPUT


chat = Chat(user_id="User",
            temperature=0.2, 
            top_p=0.1,
            system_= SYSTEM)


def alternatingly_agree(message, history):
    response =   chat.complete(message_= message)
    return str(response)

if __name__ == "__main__":
    gr.ChatInterface(alternatingly_agree, type="messages").launch()