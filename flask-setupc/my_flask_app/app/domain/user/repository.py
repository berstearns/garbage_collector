from app.domain.user.models import User
from app import redis_client

class UserRepository:
    def __init__(self):
        self.redis = redis_client

    def set_user(self, user_id, user_data):
        """Store user data in Redis."""
        user = User.from_dict(user_data)
        self.redis.hset(f"user:{user_id}", mapping=user.to_dict())
    
    def get_user(self, user_id):
        """Retrieve user data from Redis."""
        user_data = self.redis.hgetall(f"user:{user_id}")
        if user_data:
            return User.from_dict(user_data)
        return None
    
    def delete_user(self, user_id):
        """Delete user data from Redis."""
        self.redis.delete(f"user:{user_id}")
