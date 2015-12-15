from pyramid.config import Configurator
from pyramid.session import UnencryptedCookieSessionFactoryConfig
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy

from sqlalchemy import engine_from_config
from ziggurat_foundations.models import groupfinder

from .models import (
    DBSession,
    Base
    )

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine

    # Set the session secret as per out ini file
    session_factory = UnencryptedCookieSessionFactoryConfig(
        settings['session.secret'],
    )

    authn_policy = AuthTktAuthenticationPolicy(settings['session.secret'],
        callback=groupfinder)
    authz_policy = ACLAuthorizationPolicy()

    config = Configurator(settings=settings,
    root_factory='pyramid_ziggurat_auth_demo.models.RootFactory',
                          authentication_policy=authn_policy,
                          authorization_policy=authz_policy)
    config.include('ziggurat_foundations.ext.pyramid.get_user')
    config.include('pyramid_jinja2')
    config.include('pyramid_mako')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('login', '/login')
    config.add_route('logout', '/sign_out')
    config.add_route('edit_note', '/edit_note')

    config.add_route('user', '/user')
    config.add_route('users', '/users')
    config.add_route('create_user', '/create_user')

    config.add_route('pages', '/pages')
    config.add_route('create_page', '/create_page')
    config.add_route('page', '/page/{title}')
    config.add_route('edit_page', '/page/{title}/edit')

    config.add_route('groups', '/groups')
    config.add_route('create_group', '/create_group')
    config.add_route('edit_group', '/group/{name}/{action}') 

    config.scan()
    return config.make_wsgi_app()
