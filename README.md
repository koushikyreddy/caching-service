# Caching-Service

A simple caching service (written in Python) that allows connected microservices to access a centralized cache.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

Create a docker network for the 2 conatiners to communicate.

```bash
$ docker network create caching-net
```

Launch a Redis instance in the created network.

```bash
$ docker run --name redis-db --net caching-net -d redis
```
Build the Dockerfile locally

```bash
$ docker build -t caching-service .
```
Launch the Caching service in the network created by giving SERVER_PORT and
REDIS_URL as environmental variables.

```bash
$ docker run -p 80:5001 --name caching-svc --net caching-net -e
SERVER_PORT=5001 -e REDIS_URL=redis-db -d caching-service
```

List the running containers

```bash
$ docker ps

CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES

dd3dc08ee88f caching-service "python server.py" 8 seconds ago Up 4 seconds
caching-svc

6592a240ecba redis "docker-entrypoint.s…" 12 minutes ago Up 12 minutes 6379/tcp
redis-db
```

## Validation steps are as follows:

If the key doesn’t exist in the cache, the API will return a 404 status code.

## <http://localhost/get/test>

![](src/images/gettest.png)

Adding a key to redis by doing a POST.

![](src/images/post.png)

**Response:**

![](src/images/postresponse.png)

Adding a key to redis by doing a POST.

![](src/images/keyadd.png)

**Response:**

## <http://localhost/get/koushik>

![](src/images/getkoushik.png)

**HEROKU DEPLOY**

https://devcenter.heroku.com/articles/container-registry-and-runtime#logging-in-to-the-registry

Make sure you have a working Docker installation (eg. docker ps) and that you’re
logged in to Heroku (heroku login).

Log in to Container Registry:

```bash
$ heroku container:login
```
Get code by cloning an source code:

```bash
$ git clone https://github.com/koushikyreddy/caching-service.git
```

Export the Heroku API key for Authentication

```bash
$ export HEROKU_API_KEY=****************
```
Heroku runs a container registry on registry.heroku.com. You can log in with:

```bash
$ docker login --username=koushikReddy --password=$HEROKU_API_KEY
registry.heroku.com
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

Login Succeeded
```
Navigate to the app’s directory and create a Heroku app:

```bash
$ heroku create caching-koushik
```
Build the image and push to Container Registry:

```bash
$ heroku container:push web --app caching-koushik
```
Then release the image to your app:

```bash
$ heroku container:release web --app caching-koushik
Releasing images web to caching-koushik... done
```

Now open the app in your browser:

```bash
$ heroku open --app caching-koushik
```
URL to access the app:

```bash
https://caching-koushik.herokuapp.com/
```

**HEROKU REDIS:**

### [Create a new instance](https://devcenter.heroku.com/articles/heroku-redis#create-a-new-instance)

Heroku Redis can be attached to an application via the CLI:

Use the heroku addons command to see if your application already has a Redis
instance provisioned:

```bash
$ heroku addons:create heroku-redis:hobby-dev -a caching-koushik
```
```bash
$ heroku addons | grep heroku-redis

caching-koushik redis-corrugated-45294 heroku-redis:hobby-dev free created
```

Once Heroku Redis has been created, the new release will be created and the
application will restart. A REDIS_URL config var will be made available in the
app configuration and will contain the URL used to access the newly provisioned
Heroku Redis instance. This can be confirmed using the heroku config command.

```bash
$ heroku config --app caching-koushik
=== caching-koushik Config Vars

REDIS_URL:
redis://h:p2f74b69e0bf4b6f98d52bbad70e7d051dce77525855bccde0f891f906643e061@ec2-100-25-128-227.compute-1.amazonaws.com:10149
```