# ======================================
# SYSTEM PROMPT
# ======================================



INSTRUCTION = \
"""
<INSTRUCTION>
Answare to the user question using the follow context information:

{context}
"""


OUTPUT = \
"""
<OUTPUT>
Answare using italian language.
"""

CHAT = \
"""
<CHAT>
question: {text}
answare:
"""




def get_system_istat_prompt(context, text) -> str:
    prompt = INSTRUCTION + \
           OUTPUT
    return prompt.format(context=context, text=text)
