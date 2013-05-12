eltacho
=======

Plataforma para incentivar y contabilizar la separación de residuos.

Pensada, planificada y ejecutada en el BA Hackaton '13

Setup
-----

You'll need Ruby to run the application. Use [RVM](https://rvm.io/) to install it ;)

Install all necessary gems:

    bundle install

And you're ready to start the server:

    ruby web.rb

Production
----------

The app runs on Heroku: <eltacho.herokuapp.com>

To deploy, add a "heroku" remote to git and:

    git push heroku master

Migrations
----------

Modifications to the DB schema are done by Sequel migrations defined on `db/migrations`.

To update a DB schema, add a migration and run:

    sequel -m db/migrations/ $DATABASE_URL

To run the migrations on Heroku, use `heroku run`:

    heroku run:detached 'sequel -m db/migrations/ $DATABASE_URL'