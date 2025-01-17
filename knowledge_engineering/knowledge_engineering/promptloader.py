from dataclasses import dataclass
from jinja2 import Template


class MissingPromptLoader(Exception):
    pass


@dataclass
class PromptLoaderConfig:
    PROMPT_TEMPLATE_FP: str = None
    SYSTEM_TEMPLATE_FP: str = None

    def __post_init__(self):
        for key in self.__dataclass_fields__:
            if self.__getattribute__(key) is None:
                raise MissingPromptLoader(f"missing {key} config property")


class PromptLoader:
    def __init__(self, config_dict):
        self.config = PromptLoaderConfig(**config_dict)

    def __call__(self):
        with open(self.config.PROMPT_TEMPLATE_FP) as inpf:
            prompt_template = Template(inpf.read())

        if not self.config.SYSTEM_TEMPLATE_FP is None:
            with open(self.config.SYSTEM_TEMPLATE_FP) as inpf:
                system_template = Template(inpf.read())
        else:
            system_template = Template("")

        return system_template, prompt_template
