# crater-app OCI Container

This repo contains the files to build a container for the Crater invoicing app, and also to setup a testing environment to play around with it (through the use of podman-compose).

I used Podman as the container engine, but you may also replace `podman` with `docker` to use Docker and docker-compose instead.

**NOTE**: I would not recommend running this setup in production, only relying on podman-compose and without a proper database backup strategy or TLS in place.

## Disclaimer

I am not a contributor to the Crater project: I built this repo for ease of use and personal necessity, therefore I consider this setup a proof of concept.

## Build the container

Open this repo's directory in a terminal, then run the following command (*without* root for Podman):

```bash
podman build -t mycompany/crater-app:v1.0-amd64 -f Containerfile.amd64
```

The container build will also take into account some setup tasks that may be performed by hand, such as:
- create a default `.env` file by copying the `.env.example` file;
- mount the original repository as the application's code folder, under `/var/www`;
- install the crontab to periodically run PHP Artisan;
- generate an application key.

Differing from the original `crater-invoice` setup, I also made the build process take care of pulling a *specific* version of the app's code: this is managed at build time, by passing the argument `-e version=X.Y.Z` to `podman build`.

## Run the environment

### Prequisite

You should have installed the `podman-compose` script.

### podman-compose

Open the subfolder `compose` in a terminal, then run (also as non-root, with podman-compose):

```bash
podman-compose up -d
```

This will start 3 containers: an Nginx proxy, a PostgreSQL database and the PHP Crater app; to run on a particular version of these containers, edit the `image` variable declared inside the `podman-compose.yml` file.

You may find useful, for example, choosing another architecture than x86\_64.

To stop the containers, run `podman-compose down` from teh same folder.

**NOTE**: This compose setup will create a Podman volume called `crater`: it will be used to share the application code with the Nginx container and also to store some application settings; the database container will by default use a local filesystem folder (called `data`, inside the `compose` subfolder) to store its data.

**NOTE**: My container image build has only the PostgreSQL drivers, not MySQL ones for MariaDB interaction

## Issues

For issues with the application itself, please report them to the original project issue tracker [here](https://github.com/crater-invoice/crater/issues).

### Database not empty

You may experience this error when configuring the application for the first time, if running a MariaDB database container.

This seems a common recent issue: it has already been addressed from the Crater project issue tracker, and to "fix" it you just need to run the script named `database_shouldbeempty_fix.sh` inside the `compose` subfolder, then reload the Crater setup page.
