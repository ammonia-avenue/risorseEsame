from ollama import Client, ChatResponse
from pathlib import Path
from cot_prompts import CotPrompts




def save_to_file(content: str, filename: Path) -> None:
    """Save content to a file in the output directory.

    Args:
        content: Text content to save
        filename: Name of the file to create
    """
    try:
        output_dir = Path("output")
        output_dir.mkdir(exist_ok=True)

        output_file = output_dir / filename
        output_file.write_text(content)
    except Exception as e:
        print(f"Error saving file: {e}")


def invoke(model: str, prompt: str) -> str:
    client = Client(
        host='http://localhost:11434'
    )
    response = client.chat(model=model, messages=[
        {
            'role': 'user',
            'content': prompt,
        },
    ])
    return response["message"]["content"]



OUT_STR = \
"""
# **FEW SHOT**

{assistant_few_shot}

---

# **SELF CONSISTENCY**

{assistant_self_consistency}

---

# **CHAIN OF VERIFICATION**

{assistant_chain_of_verification}

---

# **MULTI STEP REASONING**

{assistant_multi_step_reasoning}

"""

def cot_test(model: str):
    cot_prompts = CotPrompts()
    assistant_few_shot = invoke(model, cot_prompts.few_shot())
    assistant_self_consistency = invoke(model, cot_prompts.self_consistency())
    assistant_chain_of_verification = invoke(model, cot_prompts.chain_of_verification())
    assistant_multi_step_reasoning = invoke(model, cot_prompts.multi_step_reasoning())

    save_to_file(OUT_STR.format(assistant_few_shot=assistant_few_shot,
                                assistant_self_consistency=assistant_self_consistency,
                                assistant_chain_of_verification=assistant_chain_of_verification,
                                assistant_multi_step_reasoning=assistant_multi_step_reasoning),
                                Path(f"{model}.md"))



# ======================================================================================================================
# MAIN
# ======================================================================================================================

# LLAMA
# https://ollama.com/library/llama3.1
LLAMA3_1_8b = "llama3.1:8b"

# DOLPHIN
# https://ollama.com/library/dolphin3
DOLPHIN3_8b = "dolphin3:latest"

# QWEN
# https://ollama.com/library/qwen3
QWEN3_8b = "qwen3:8b"

# DEEPSEEK
# https://ollama.com/library/deepseek-r1
DEEP_SEEK_R1_8b = "deepseek-r1:8b"

# GRANITE
# https://ollama.com/library/granite3.3
GRANITE3_3_8b = "granite3.3:8b"


if __name__ == '__main__':
    cot_test(GRANITE3_3_8b)