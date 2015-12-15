from sqlalchemy import (
    Table,
    Column,
    Index,
    Integer,
    Text,
    ForeignKey,
    UniqueConstraint,
    Unicode
    )

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import MetaData

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    relationship,
    backref
    )

from zope.sqlalchemy import ZopeTransactionExtension

from pyramid.security import (
    Allow,
    Everyone,
    Authenticated,
    authenticated_userid,
    forget,
    remember,
    ALL_PERMISSIONS
    )

import ziggurat_foundations.models
from ziggurat_foundations.models.base import BaseModel
from ziggurat_foundations.models.external_identity import ExternalIdentityMixin
from ziggurat_foundations.models.group import GroupMixin
from ziggurat_foundations.models.group_permission import GroupPermissionMixin
from ziggurat_foundations.models.group_resource_permission import GroupResourcePermissionMixin
from ziggurat_foundations.models.resource import ResourceMixin
from ziggurat_foundations.models.user import UserMixin
from ziggurat_foundations.models.user_group import UserGroupMixin
from ziggurat_foundations.models.user_permission import UserPermissionMixin
from ziggurat_foundations.models.user_resource_permission import UserResourcePermissionMixin
from ziggurat_foundations import ziggurat_model_init
from ziggurat_foundations.permissions import permission_to_pyramid_acls

import logging
log = logging.getLogger(__name__)

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()
#ziggurat_foundations.models.DBSession = DBSession

def get_session_callable(request):
   # if DBSession is located at "request.db_session"
   return DBSession
   # or if DBSession was located at "request.db"
  #return request.db

class Group(GroupMixin, Base):
    pass

class GroupPermission(GroupPermissionMixin, Base):
    pass

class UserGroup(UserGroupMixin, Base):
    pass

class GroupResourcePermission(GroupResourcePermissionMixin, Base):
    pass

class Resource(ResourceMixin, Base):
    # ... your own properties....
    pass

class UserPermission(UserPermissionMixin, Base):
    pass

class UserResourcePermission(UserResourcePermissionMixin, Base):
    pass

class User(UserMixin, Base):
    # ... your own properties....
    pass

class ExternalIdentity(ExternalIdentityMixin, Base):
    pass

ziggurat_model_init(User, Group, UserGroup, GroupPermission, UserPermission,
               UserResourcePermission, GroupResourcePermission, Resource,
               ExternalIdentity, passwordmanager=None)

class RootFactory(object):
    def __init__(self, request):
        self.__acl__ = [(Allow, Authenticated, u'view'), ]
        # general page factory - append custom non resource permissions
        # request.user object from cookbook recipie
        if request.user:
            for perm in request.user.permissions:
                log.debug('\n\nPERMISSIONS\n\n')
                self.__acl__.append((Allow, perm.user.id, perm.perm_name,))
                log.debug(self.__acl__)
                log.debug('\n\nPERMISSIONS\n\n')
            # or you could do
            # for outcome, perm_user, perm_name in permission_to_pyramid_acls(
            #         request.user.permissions):
            #     self.__acl__.append((outcome, perm_user, perm_name))


class ResourceFactory(object):
    def __init__(self, request):
        self.__acl__ = []
        rid = request.matchdict.get("resource_id")

        if not rid:
            raise HTTPNotFound()
        self.resource = Resource.by_resource_id(rid)
        if not self.resource:
            raise HTTPNotFound()
        if self.resource and request.user:
            # append basic resource acl that gives all permissions to owner
            self.__acl__ = self.resource.__acl__
            # append permissions that current user may have for this context resource
            for perm in self.resource.perms_for_user(request.user):
                self.__acl__.append((Allow, perm.user.id, perm.perm_name,))


