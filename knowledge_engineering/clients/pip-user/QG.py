'''
 Given a knowledge graph representating the art
 A selected prompt and LLM
 generate a complete or partial story of the target art
'''
import json

from knowledge_engineering import PromptLoaderConfig, PromptLoader,\
                QuestionGenerationPipeline, QuestionGenerationConfig 

art_id="school-boy_van-gogh"
SG_config = {
        "KG_FP": f"./data/data.md",
        #"INPUT_FP":"./data/chunks/raw_text/hamlet_act1_chunks_6.txt",
        "OUTPUT_FOLDER": f"./data/questions",
        "MODEL_NAME": 'olmo2',
        "CLIENT": "ollama"
        # 'allenai/OLMo-2-1124-7B-Instruct',
        #'allenai/OLMo-1B',#gpt2'#'olmo2',#'mixtral',
        #"PORT": 11434
}

prompt_config = {
    "PROMPT_TEMPLATE_FP": "./prompts/QuestionGeneration.jinja2",
    "SYSTEM_TEMPLATE_FP": "./prompts/QuestionGenerationSystem.jinja2"
}

prompter = PromptLoader(prompt_config)

taskRunner = QuestionGenerationPipeline(SG_config, prompter)
taskRunner.run()
