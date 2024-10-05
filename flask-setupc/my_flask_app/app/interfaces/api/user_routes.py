from flask import Blueprint, request, jsonify
from app.domain.user.services import UserService

# Create a Blueprint for user routes
user_routes_blueprint = Blueprint('user_routes', __name__)

# Instantiate the UserService
user_service = UserService()

@user_routes_blueprint.route('/<user_id>', methods=['GET'])
def get_user(user_id):
    """Retrieve a user by ID."""
    result = user_service.get_user(user_id)
    if 'error' in result:
        return jsonify(result), 404
    return jsonify(result), 200

@user_routes_blueprint.route('/', methods=['POST'])
def create_user():
    """Create a new user."""
    data = request.json
    user_id = data.get('user_id')
    name = data.get('name')
    email = data.get('email')

    if not user_id or not name or not email:
        return jsonify({"error": "user_id, name, and email are required"}), 400
    
    result = user_service.create_user(user_id, name, email)
    return jsonify(result), 201

@user_routes_blueprint.route('/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete a user by ID."""
    result = user_service.delete_user(user_id)
    if 'error' in result:
        return jsonify(result), 404
    return jsonify(result), 200

@user_routes_blueprint.route('/<user_id>', methods=['PUT'])
def update_user(user_id):
    """Update user details."""
    data = request.json
    name = data.get('name')
    email = data.get('email')

    if not name and not email:
        return jsonify({"error": "At least one of name or email must be provided"}), 400

    result = user_service.update_user(user_id, name, email)
    if 'error' in result:
        return jsonify(result), 404
    return jsonify(result), 200
