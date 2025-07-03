

import gradio as gr



from chat import Chat

# ======================================
# SYSTEM PROMPT
# ======================================



CHEF_CONTEXT = \
"""<CONTEXT>
You are an expert chef, you are writing a recipe book for quick and simple dishes to make.


"""


CHEF_INSTRUCTION = \
"""<INSTRUCTION>
- Write One-dish recipes.
- Provide the cooking steps with the ingredients and the measurements for each.
- Write only vegetarian recipes.


"""




CHEF_OUTPUT = \
"""<OUTPUT>
- Write only one recipe.
- Write a one-sentence introduction to introduce the dish.
- Use a maximum of 100 words.
- Write the answer in italian
- Write the recipe ingredients as a html tab as follow:
    ```html
 <table>
  <tr>
    <th>Recipe</th>
    <th>Ingrediente</th>
    <th>Quantità</th>
  </tr>
</table>

    ```

- Write the recipe instruction steps as a bulleted list in html format.


"""


CHEF_SYSTEM = \
CHEF_CONTEXT + \
CHEF_INSTRUCTION + \
CHEF_OUTPUT 


chat = Chat(user_id="User",
            temperature=0.2, 
            top_p=0.1,
            system_= CHEF_SYSTEM)


def alternatingly_agree(message, history):
    response =   chat.complete(message_= message)
    return str(response)

if __name__ == "__main__":
    gr.ChatInterface(alternatingly_agree, type="messages").launch(share=True)