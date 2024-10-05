from typing import Mapping
from flask import Blueprint, render_template, abort, current_app
from jinja2 import TemplateNotFound


login_blueprint = Blueprint('login', __name__, url_prefix="/login", template_folder='templates')

class InvalidProviderName(Exception):
    pass

def oauth2_authorize(provider):

    if provider is None:
       raise InvalidProviderName("Invalid provider name") 

    # generate a random string for the state parameter
    session['oauth2_state'] = secrets.token_urlsafe(16)

    # create a query string with all the OAuth2 parameters
    qs = urlencode({
        'client_id': provider.client_id,
        'redirect_uri': provider.provider_authorization_endpoint,
        'response_type': 'code',
        'scope': ' '.join(provider.scopes),
        'state': session['oauth2_state'],
    })

    # redirect the user to the OAuth2 provider authorization URL
    return provider_data['authorize_url'] + '?' + qs

@login_blueprint.route('/',
                       methods=['GET'])
def login_view():
    if not current_user.is_anonymous:
        return redirect(url_for('index'))

    providers_auth_urls: Mapping[str, str] = {}
    for provider_name, provider in current_app.config.OAUTH2_PROVIDERS.values():
        providers_auth_urls[provider_name] = oauth2_authorize(provider)

    return render_template(
           f'login.html', 
           providers_auth_urls=providers_auth_urls
    )

@login_blueprint.route('/',
                       methods=['POST'])
def login_request():
    return render_template(f'login.html')
