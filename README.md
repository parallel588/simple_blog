# SimpleBlog

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Heroku deploy

http://www.phoenixframework.org/docs/heroku

set env var:

1. heroku config:set SECRET_KEY_BASE="your_key_here"
2. heroku config:set POOL_SIZE=18
3. heroku config:set GUARDIAN_SECRET_KEY="your_key_here"
4. heroku config:set HOST="your_host"

and setup SMTP

## Using Docker For Development
1. Given you already have docker and docker-compose installed on your machine, Simply run these following commands:
```
# Build all and pull images and containers
docker-compose build
# Build application dependencies.
# This will set permission to allow our build script to run.
# use config/dev.docker_example.exs
chmod +x build
./build
# Build the Docker image and start the `web` container, daemonized
docker-compose up -d web
visit to http://0.0.0.0:4000
```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
