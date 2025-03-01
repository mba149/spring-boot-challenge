# Development setup
We currently support running locally using docker compose. When using docker compose you don't need to worry about installing any libraries or dependencies on your machine, other than docker.

### Pre-requisites

You will need to have the following installed:

- `Docker` - Docker Desktop for Mac, via Homebrew:
    ```
    brew install --cask docker
    ```
### First build (or re-build after clearing all caches)

In the root of `DEVOPS-CODING-CHALLENGE`, run the following commands:

```
docker compose build
```

The first build will take some time since it needs to pull all base images and build everything from scratch.

Subsequent builds will be faster, both because of Docker's layer cache and because we're explicitly copying Maven
dependencies from a remote build cache image.

### Run the service
After building everything successfully for the first time you can simply run `docker compose up -d` to start all the
services and seed the databases.

```
docker compose up -d
```

The `-d` flag is there to start the containers in the background. Otherwise you'll end up in a process that follows the
log output of all containers and hitting `Ctrl-C` will stop all containers. We usually don't want that.

### Re-build services

If you `git pull` or make local code changes you will need to rebuild the services. Either you rebuild all:

```
docker compose up --build -d
```
### Database state

The database containers normally keep their state when stopped and restarted, but if you want to make sure you start
with a clean slate you can run the following:

```
docker compose rm --stop --force --volumes mysql-data
```

Then you can start them again with:

```
docker compose up -d postgres mysql
```

### Logs

You can monitor all logs by running:

```
docker compose logs -f
```

### Reset environment

To reset the environment and clear the database state you can run the following:

```
docker compose down --remove-orphans --volumes
```

### Troubleshooting
#### The build or Docker containers exit abnormally

This might be because the build cache or Docker file system is full. You can check the status of the Docker file system
with:

```
docker system df
```

You can prune the build cache with:

```
docker builder prune
```

You can free up some space with:

```
docker system prune
```

And to remove all images and volumes and stuff you can use:

```
docker system prune --all
```