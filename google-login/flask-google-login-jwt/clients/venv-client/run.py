from flask_google_login_jwt import create_app, FlaskAppConfig
from dotenv import dotenv_values

dotenv_config = dotenv_values(".env")
if not all([dotenv_config.get(v,False) for v in ["client_id","client_secret"]]):
    raise Exception("missing some secret credentials in .env")

config = FlaskAppConfig(
    OAUTH2_PROVIDERS={
        "google": {
            'name': "google",
            'client_id': dotenv_config["client_id"],
            'client_secret': dotenv_config["client_secret"],
            'provider_authorization_endpoint': "https://accounts.google.com/o/oauth2/v2/auth",
            'provider_token_endpoint': "https://oauth2.googleapis.com/token",
            'userinfo':{
                "endpoint": "https://openidconnect.googleapis.com/v1/userinfo"
                },
            'scopes': ["openid", "email", "profile"]
        }
    }
)

app = create_app(config)
# print(app.repositories['user'].get(user_id=1))
app.run(port=5002, debug=True)

