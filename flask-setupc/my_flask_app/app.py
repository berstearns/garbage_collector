from flask import Flask
from flask_redis import FlaskRedis

# Initialize Redis client
redis_client = FlaskRedis()

def create_app(config_class='config.settings'):
    # Initialize the Flask application
    app = Flask(__name__)
    
    # Load configuration from settings
    app.config.from_object(config_class)
    
    # Initialize Redis with the app
    redis_client.init_app(app)
    
    # Register blueprints
    from app.interfaces.api.user_routes import user_routes_blueprint
    from app.interfaces.api.session_routes import session_routes_blueprint
    from app.interfaces.api.auth_routes import auth_routes_blueprint

    app.register_blueprint(user_routes_blueprint, url_prefix='/users')
    app.register_blueprint(session_routes_blueprint, url_prefix='/sessions')
    app.register_blueprint(auth_routes_blueprint, url_prefix='/auth')
    
    @app.route('/')
    def home():
        return "Welcome to the minimal Flask app with Redis!"
    
    return app

# Factory function to create and run the app
if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)

