from pathlib import Path
import yaml

COT_PROMPTS_DIR = Path(__file__).parent / "cot_prompts.yml"

class CotPrompts:
    def __init__(self, path=COT_PROMPTS_DIR):
        self.prompts = yaml.safe_load(path.read_text())


    def few_shot(self):
        return self.prompts["few_shot"]
    def self_consistency(self):
        return self.prompts["self_consistency"]
    def chain_of_verification(self):
        return self.prompts["chain_of_verification"]
    def multi_step_reasoning(self):
        return self.prompts["multi_step_reasoning"]



