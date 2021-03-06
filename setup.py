import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.txt')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.txt')) as f:
    CHANGES = f.read()

requires = [
    'pyramid',
    'pyramid_jinja2',
    'pyramid_debugtoolbar',
    'pyramid_tm',
    'SQLAlchemy',
    'transaction',
    'zope.sqlalchemy',
    'waitress',
    'ziggurat_foundations',
    'bcrypt',
    'alembic'
    ]

setup(name='pyramid_ziggurat_auth_demo',
      version='0.0',
      description='pyramid_ziggurat_auth_demo',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='',
      author_email='',
      url='',
      keywords='web wsgi bfg pylons pyramid',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      test_suite='pyramid_ziggurat_auth_demo',
      install_requires=requires,
      entry_points="""\
      [paste.app_factory]
      main = pyramid_ziggurat_auth_demo:main
      [console_scripts]
      initialize_pyramid_ziggurat_auth_demo_db = pyramid_ziggurat_auth_demo.scripts.initializedb:main
      """,
      )
