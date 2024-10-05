from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    id: str
    name: str
    email: str

    def __post_init__(self):
        for field in self.__dataclass_fields__:
          if self.__getattribute__(field) is None:
            raise MissingRequiredUserField("Missing field {field} in User dataclass")
