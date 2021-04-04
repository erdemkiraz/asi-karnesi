from enum import Enum


class UserVisibility(Enum):
    PRIVATE = 0
    ALL_ADMINS = 1
    PERMITTED_USERS = 2
    FRIENDS = 3
    PUBLIC = 4


class AdminPrivilege(Enum):
    ONLY_SAME_COUNTRY = 0
    EVERYONE = 1
    SUPER_ADMIN = 2  # Can assign new admins
