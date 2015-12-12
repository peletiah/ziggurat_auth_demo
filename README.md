Pyramid Authorization and Authentication Demo based on Ziggurat
===============================================================

Ziggurat Foundations Demo based on https://ziggurat-foundations.readthedocs.org/en/latest/configuration.html#configure-ziggurat-with-pyramid-framework

Installation
------------

```bash
virtualenv env
cd env
git clone git://github.com/peletiah/pyramid_auth_demo_sqlalchemy.git auth_tut
cd auth_tut
../bin/python setup.py develop
../bin/pserve development.ini --reload
```

If everything looks fine, go to http://localhost:6543, else let me know!

Maintenance/Testing
-------------------


You can get an interactive python-shell where you can test the DB-model and other functions by issuing
```
../bin/python auth_tut/devtools/sqlalchemy_shell.py
```
