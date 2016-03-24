# Django Rest Framework Quickstart

## Purpose

This quickstart guide is intended to speed up the initialization of a new REST API using Django Rest Framework.

Additional goals include the implementation of Token authentication for securing API calls, as well as a custom User class for easier user management.

## Instructions

### Download Django and Django Rest Framework

Initialize a `virtualenv`, and then activate it:

	$ virtualenv .
	$ source bin/activate
	(quickstarter) $

Next, install Django and Django Rest Framework:

    (quickstarter) $ pip install django djangorestframework

_(It is assumed from this point on that the virtual environment is currently activated.)_

### Create a new Django project and app

Generate a new project, and then navigate into it:

	$ django-admin startproject quickstarter
	$ cd quickstarter

Projects are intended to house multiple apps. Create a new app with the `startapp` command:

	$ python manage.py startapp apiapp

### Install Django Rest Framework and your app

Edit `settings.py` to include `rest_framework` and the above app in the list of `INSTALLED_APPS`:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    ...
    'rest_framework',
    'apiapp'
]
```

### Set up Token Authentication

Start by adding `rest_framework.authtoken` to `INSTALLED_APPS`:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    ...
    'rest_framework',
    'rest_framework.authtoken',
    'apiapp'
]
```

App-wide token authentication can be configured by adding `TokenAuthentication` to `DEFAULT_AUTHENTICATION_CLASSES` within a `REST_FRAMEWORK` dictionary created in `settings.py`:

```python
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.TokenAuthentication',
    )
}
```

Token authentication can also be specified on a per-view basis:

```python
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView

class ExampleView(APIView):
    authentication_classes = (TokenAuthentication,)
```

Lastly, set up an API endpoint that users can POST to to login and retrieve their access token. Add the following URL pattern in `urls.py`:

```python
from rest_framework.authtoken import views
urlpatterns += [
    url(r'^api-token-auth/?$', views.obtain_auth_token)
]
```

Any custom URL can be substituted for `api-auth-token/`.

### Create a custom User model for additional management flexibility

The default Django User model is pretty useful for basic user management, but using a separate model to keep track of additional user information introduces an additional level of complexity that can easily be avoided. Note that this option will require future project apps to use this custom User model as well.

The Django docs include [a detailed write-up](https://docs.djangoproject.com/en/1.9/topics/auth/customizing/#specifying-a-custom-user-model) on how to implement a custom User model. The simplest way to get started is to inherit a class from `AbstractBaseUser` and customize from there:

```python
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models

class Account(AbstractBaseUser):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=40, unique=True, blank=True)

    first_name = models.CharField(max_length=40, blank=True)
    last_name = models.CharField(max_length=40, blank=True)
    tagline = models.CharField(max_length=140, blank=True)

    is_admin = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = AccountManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __unicode__(self):
        return self.email

    def get_full_name(self):
        return ' '.join([self.first_name, self.last_name])

    def get_short_name(self):
        return self.first_name
```

You'll also need to define a custom `BaseUserManager` to handle the new `Account` model:

```python
class AccountManager(BaseUserManager):
    def create_user(self, email, password=None):
        if not email:
            raise ValueError('User must provide an e-mail address')

        account = self.model(
            email=self.normalize_email(email)
        )

        account.set_password(password)
        account.save()

        return account

    def create_superuser(self, email, password=None):
        account = self.create_user(email, password)

        account.is_admin = True
        account.save()

        return account
```

Django will need to be updated to use this new User model. Open `settings.py` and define the `AUTH_USER_MODEL` variable with this new model:

```python
AUTH_USER_MODEL = 'apiapp.Account'
```

Next, migrate all of the above changes to the database:

	python manage.py makemigrations
	python manage.py migrate

During migration a prompt will appear confirming the deletion of the old User model:

	The following content types are stale and need to be deleted:

	    auth | user

	Any objects related to these content types by a foreign key will also
	be deleted. Are you sure you want to delete these content types?
	If you're unsure, answer 'no'.

	    Type 'yes' to continue, or 'no' to cancel:

Type `yes` to confirm the deletion. From this point on Django will use this custom User class when creating user accounts.

## Verification

Before we can check that everything is working properly, a new user must be created:

	python manage.py createsuperuser

Run through the guided setup, then start the server:

	python manage.py runserver

Send a POST request to the API server with a `username` and `password` payload set to the above user's values (using [HTTPIE](https://github.com/jkbrzt/httpie)):

	http POST http://localhost:8000/api-token-auth username=test@user.com password=4P4ssw0rd!

If everything went right, the server should return a JSON-encoded payload with a single `token` value:

	{
	    "token": "1b2dcebcf460a4f76d8c7f5f23909a48e3d0d39d"
	}

Endpoints requiring authentication can be accessed by including a valid token within the request header as "Authorization: Token":

> http http://localhost:8000/some-endpoint "Authorization: Token 1b2dcebcf460a4f76d8c7f5f23909a48e3d0d39d"