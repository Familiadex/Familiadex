# Familiada

[![Join the chat at https://gitter.im/Familiadex/Familiadex](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Familiadex/Familiadex?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. `mix ecto.create` seems to be broken, run `psql` & `create database familiada_dev owner <your_username>;`
  3. edit `config/dev.exs` and set proper database user as <your_username>;"
  4. If it complains about password please run `psql` & `alter user your_username with password '';`
  5. Migrate your database with `mix ecto.create && mix ecto.migrate`
  6. Run `npm install`
  7. Run `npm install -g elm`
  8. Run `cd web/elm` & `elm-package install`
  9. Start Phoenix endpoint with `mix phoenix.server`
  10. Install inotify(only linux) for automatic hot reload - http://www.phoenixframework.org/docs/installation

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
