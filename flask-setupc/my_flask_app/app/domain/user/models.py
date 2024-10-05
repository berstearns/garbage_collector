class User:
    """A class to represent a User."""

    def __init__(self, user_id, name, email):
        self.user_id = user_id
        self.name = name
        self.email = email

    def to_dict(self):
        """Convert the User instance to a dictionary."""
        return {
            'user_id': self.user_id,
            'name': self.name,
            'email': self.email
        }

    @classmethod
    def from_dict(cls, data):
        """Create a User instance from a dictionary."""
        return cls(
            user_id=data.get('user_id'),
            name=data.get('name'),
            email=data.get('email')
        )
