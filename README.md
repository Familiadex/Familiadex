# Familiada

[![Join the chat at https://gitter.im/Familiadex/Familiadex](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Familiadex/Familiadex?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[Trello board](https://trello.com/b/4t4cuGYZ/workflow)

## Dependencies
  1. Elixir 1.2.2 / Phoenix 1.1.4
  2. Elm 2.0.0
  3. PostgreSQL 9+
  4. Redis

## Start the App
  1. Install dependencies with `mix deps.get`
  2. `mix ecto.create` seems to be broken, run `psql` & `create database familiada_dev owner <your_username>;`
  3. ~~edit `config/dev.exs` and set proper database user as <your_username>;"~~ `echo "export FAMILIADEX_DB_USER=your_username" >> ~/.bashrc"`
  4. If it complains about password please run `psql` & `alter user your_username with password '';`
  5. Migrate your database with `mix ecto.create && mix ecto.migrate`, then seed `mix run priv/repo/seeds.exs`
  6. Run `npm install`
  7. Run `npm install -g elm@2.0.0`
  8. Run `cd web/elm` & `elm-package install`
  9. Start Phoenix endpoint with `mix phoenix.server`
  10. Install inotify(only linux) for automatic hot reload - http://www.phoenixframework.org/docs/installation

### Facebook login config
  `echo "export FACEBOOK_CLIENT_SECRET=[filtered]" >> ~/.bashrc`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Test user
  * email: test@user.com
  * password: test


## Heroku hosting
https://familiadex.herokuapp.com/

=== familiadex Buildpack URLs
  1. https://github.com/HashNuke/heroku-buildpack-elixir
  2. https://github.com/Machiaweliczny/heroku-buildpack-elm

### Deploy to heroku
  1. Add priv/static files to git before pushing to heroku

## Learn more

  * Official website: http://www.phoenixframework.org/
  * http://elm-lang.org/docs
  * https://github.com/urfolomeus/seat_saver - phoenix + elm communication using channels
