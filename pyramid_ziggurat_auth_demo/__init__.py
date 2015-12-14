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
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('edit_note', '/edit_note')
    config.scan()
    return config.make_wsgi_app()
