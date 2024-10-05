import os 
from dataclasses import dataclass
from typing import List, Mapping
from .infrastructure import load_database,\
                    InMemoryUserRepository
from .routes import login_blueprint
from .domain import User

from flask import Flask, blueprints, session
from flask_login import LoginManager, login_user, logout_user,\
                            current_user,\
                            UserMixin, AnonymousUserMixin

class MissingRequiredConfigField(Exception):
    pass

class UnexpectedConfigFieldType(Exception):
    pass

@dataclass(frozen=True)
class Provider:
    name: str
    client_id: str
    client_secret: str
    provider_authorization_endpoint: str
    provider_token_endpoint: str
    userinfo: dict
    scopes: List[str]

type Providers = Mapping[ str, Provider]

@dataclass
class FlaskAppConfig:
    OAUTH2_PROVIDERS: Providers = None

    def __post_init__(self):
        for field in self.__dataclass_fields__:
            field_value = self.__getattribute__(field)
            expected_type = self.__annotations__[field]
            if field_value is None:
                raise MissingRequiredConfigField(f"missing field {field}")
            elif type(field_value) != expected_type :
                if isinstance(field_value, dict) and str(expected_type) == "Providers":
                    self.field = {k:Provider(**d)
                           for k, d in field_value.items()}
                else:
                    raise UnexpectedConfigFieldType(f"field {field} was supposed to be {expected_type} instead of {type(field_value)}")




class FlaskUser(UserMixin):
    def setdata(self, data: User):
        for field in user.__dataclass_fields__:
          self.field =  User.__getattribute__(field)

class FlaskAnonymousUser(AnonymousUserMixin):
    pass

def create_app(config: FlaskAppConfig):
    app = Flask(__name__)
    app.config["SECRET_KEY"] = "A DUMMY SECRET KEY"
    app.config["OAUTH2_PROVIDERS"] = config.OAUTH2_PROVIDERS
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = "login"

    app.register_blueprint(login_blueprint)
    app.domain = load_database()
    app.repositories = {
            "user": InMemoryUserRepository(app) 
            }

    @app.before_request
    def before_request():
        g.user = current_user
        print('current_user: %s, g.user: %s, leaving bef_req' % (current_user, g.user))

    @login_manager.user_loader
    def load_user(user_id):
        UserSearch = app.repositories["user"].get(user_id)
        if UserSearch is None:
            return FlaskAnonymousUser()  
        else:
            data = app.repositories["user"].get(user_id)
            user = FlaskUser()
            user.setdata(data)
            return user 

    return app
