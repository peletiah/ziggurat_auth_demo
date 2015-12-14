from pyramid.response import Response
from pyramid.view import view_config

from pyramid.httpexceptions import HTTPNotFound, HTTPFound

from sqlalchemy.exc import DBAPIError

from .models import (
    DBSession,
    User,
    Group
    )

from pyramid.security import NO_PERMISSION_REQUIRED
from ziggurat_foundations.ext.pyramid.sign_in import ZigguratSignInSuccess
from ziggurat_foundations.ext.pyramid.sign_in import ZigguratSignInBadAuth
from ziggurat_foundations.ext.pyramid.sign_in import ZigguratSignOut

import logging
log = logging.getLogger(__name__)



@view_config(context=ZigguratSignInSuccess, permission=NO_PERMISSION_REQUIRED)
def sign_in(request):
    # get the user
    user = request.context.user
    # actions performed on sucessful logon, flash message/new csrf token
    # user status validation etc.
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    log.debug('######################## LOGIN SUCCESS #######################')
    if request.context.came_from != '/':
        return HTTPFound(location=request.context.came_from,
                         headers=request.context.headers)
    else:
        return HTTPFound(location=request.route_url('some_route'),
                         headers=request.context.headers)

@view_config(context=ZigguratSignInBadAuth, permission=NO_PERMISSION_REQUIRED)
def bad_auth(request):
    # The user is here if they have failed login, this example
    # would return the user back to "/" (site root)
    log.warn('############# LOGIN FAILED #################')
    log.warn('############# LOGIN FAILED #################')
    return HTTPFound(location=request.route_url('home'),
                     headers=request.context.headers)
    # This view would return the user back to a custom view
    return HTTPFound(location=request.route_url('declined_view'),
                 headers=request.context.headers)

@view_config(context=ZigguratSignOut, permission=NO_PERMISSION_REQUIRED)
def sign_out(request):
    return HTTPFound(location=request.route_url('home'),
                     headers=request.context.headers)

@view_config(route_name='home', renderer='login.jinja2')
def home(request):
    user = request.user
    # user is now a Ziggurat/SQLAlchemy object that you can access
    # Example for user Joe
    return {
            'user' : user
            }

@view_config(route_name='edit_note', renderer='templates/edit_note.jinja2',
        permission=u'edit')
def edit_note(request):
    return {}
