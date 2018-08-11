# justswap.it server repository


## Useful links
[trello](https://trello.com/justswapme)

## Style guidelines
* Follow [PEP8](https://www.python.org/dev/peps/pep-0008/) for Python code.

* Try to keep line width under 120 characters.

* Use [formatted string literals](https://www.python.org/dev/peps/pep-0498/) for string formatting.

* Use [Type Hints](https://www.python.org/dev/peps/pep-0484/) whenever possible.

* For docstrings in everything but views use [google style docstring.](http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html)

* Code for the API endpoints should be places in `api` folder, except of the `search` endpoint.

* Names, variables, docstring, comments, etc. should be written in english.

* Test files should be placed in `tests` dir in directory where tested file is.

## Makefile
There is a Makefile with following commands:

* `build-all` - Build all containers, dev-build by default:
    * `build-redis`
    * `build-postgres`
    * `build-django`
    * `build-nginx`
    * `build-rabbitmq`
    * `build-celery`
* `rebuild-all` - Remove all containers and volumes and rebuilds them:
    * `rebuild-redis`
    * `rebuild-postgres`
    * `rebuild-django`
    * `rebuild-nginx`
    * `rebuild-rabbitmq`
    * `rebuild-celery`
* `run-dev` - Run containers in development mode
* `run-dev-no-logs` - Run containers in development mode without output to the console
* `migrate` - Run migrations in flask container
* `stop` - Stop all containers:
    * `stop-redis`
    * `stop-postgres`
    * `stop-django`
    * `stop-nginx`
    * `stop-rabbitmq`
    * `stop-celery`
* `rm` - Remove all containers:
    * `rm-redis`
    * `rm-postgres`
    * `rm-django`
    * `rm-nginx`
    * `rm-rabbitmq`
    * `rm-celery`
* `rm-all-volumes` - Remove all volumes:
    * `rm-db-volume`
    * `rm-nginx-volume`
* `clean-all` - Stop and remove all containers and volumes:
    * `clean-redis`
    * `clean-postgres`
    * `clean-django`
    * `clean-nginx`
    * `clean-rabbitmq`
    * `clean-celery`
* `shell-redis` - Open Bash shell in redis container
* `shell-postgres` - Open Bash shell in postgres container
* `shell-django` - Open Bash shell in django container
* `shell-nginx` - Open Bash shell in nginx container
* `shell-celery` - Open Bash shell in celery container
* `logs` - Output all logs to the terminal:
    * `logs-redis`
    * `logs-postgres`
    * `logs-django`
    * `logs-nginx`
    * `logs-rabbitmq`
    * `logs-celery`
* `dev-reload` - Watch files for changes and reloads services when needed.
* `reload-nginx` - Reload nginx
* `prepare-tests` - Start containers in test mode
* `test` - Run tests inside containers.