from flask import Blueprint, render_template, abort, current_app
from jinja2 import TemplateNotFound


authorize_blueprint = Blueprint('authorize', __name__, url_prefix="/authorize", template_folder='templates')


@authorize_blueprint.route('/authorize/<provider>',
                       methods=['GET'])
def oauth2_authorize(provider):
    if not current_user.is_anonymous:
        return redirect(url_for('index'))

    provider = current_app.config.OAUTH2_PROVIDERS.get(provider)
    if provider is None:
        abort(404)

    # generate a random string for the state parameter
    session['oauth2_state'] = secrets.token_urlsafe(16)

    # create a query string with all the OAuth2 parameters
    qs = urlencode({
        'client_id': provider.client_id],
        'redirect_uri': provider.provider_authorization_endpoint,
        'response_type': 'code',
        'scope': ' '.join(provider.scopes),
        'state': session['oauth2_state'],
    })

    # redirect the user to the OAuth2 provider authorization URL
    return provider_data['authorize_url'] + '?' + qs
