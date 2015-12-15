from pyramid.response import Response
from pyramid.view import view_config

from pyramid.httpexceptions import HTTPNotFound, HTTPFound

from sqlalchemy.exc import DBAPIError

from pyramid_ziggurat_auth_demo.models import (
    DBSession,
    User,
    Group
    )

from pyramid.security import (
        NO_PERMISSION_REQUIRED,
        authenticated_userid
        )

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
    params = {"status": "failed_login"}
    return HTTPFound(location=request.route_url('login', _query=params),
                     headers=request.context.headers
                     )
    
@view_config(context=ZigguratSignOut, permission=NO_PERMISSION_REQUIRED)
def sign_out(request):
    return HTTPFound(location=request.route_url('home'),
                     headers=request.context.headers)


@view_config(route_name='login', renderer='login.mako')
def login(request):
    failed_attempt = False
    came_from = request.params.get('came_from') or request.route_url('home')
    if request.GET:
        if request.GET['status'] == 'failed_login':
            failed_attempt = True
    user = request.user
    # user is now a Ziggurat/SQLAlchemy object that you can access
    # Example for user Joe
    return {
            'user' : user,
            'came_from' : came_from,
            'failed_attempt' : failed_attempt
            }


@view_config(
    route_name='home',
    renderer='home.mako',
)
def home_view(request):
    user_id = authenticated_userid(request)
    if user_id:
        user = User.by_id(user_id)
    else:
        user = None
    try:
        user_pages = DBSession.query(Page).filter(Page.owner == user.id).all()
    except:
        user_pages = None

    return {
        'user': user,
        'user_pages': user_pages,
        'request': request,
    }

@view_config(route_name='edit_note', renderer='templates/edit_note.jinja2')
def edit_note(request):
    log.debug(request)
    return {}
