from app.domain.user.repository import UserRepository
from app.domain.user.models import User

class UserService:
    def __init__(self):
        self.user_repo = UserRepository()
    
    def create_user(self, user_id, name, email):
        """Create a new user with the provided details."""
        user_data = {
            'user_id': user_id,
            'name': name,
            'email': email
        }
        user = User.from_dict(user_data)
        self.user_repo.set_user(user_id, user.to_dict())
        return {"message": "User created successfully"}
    
    def get_user(self, user_id):
        """Retrieve a user by ID."""
        user = self.user_repo.get_user(user_id)
        if user:
            return user.to_dict()
        return {"error": "User not found"}
    
    def delete_user(self, user_id):
        """Delete a user by ID."""
        self.user_repo.delete_user(user_id)
        return {"message": "User deleted successfully"}
    
    def update_user(self, user_id, name=None, email=None):
        """Update user details."""
        user_data = self.user_repo.get_user(user_id)
        if user_data:
            user_data = user_data.to_dict()
            if name:
                user_data['name'] = name
            if email:
                user_data['email'] = email
            updated_user = User.from_dict(user_data)
            self.user_repo.set_user(user_id, updated_user.to_dict())
            return {"message": "User updated successfully"}
        return {"error": "User not found"}
