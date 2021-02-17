# Quadquizaminos
A tretrominoes (tetris-like) game with quiz questions to get powerups to help with game. This is an extension to quadblocks by Grox.io which is based on the Phoenix framework with liveview.

## Setup guide
First ensure you have the following set up in your computer
- elixir 1.11.2
- nodejs > 12 LTS
- Postgresql > 11

You can use [the phoenix installation guide](https://hexdocs.pm/phoenix/installation.html#content) to ensure you
have everything set up as expected

## Start server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Deployment to GCP

Instructions to deployment can be found on [deployment docs](./docs/deployment.md)

## Set up Github OAuth app

Use [Github guide](https://docs.github.com/en/developers/apps/creating-an-oauth-app) to create an OAuth app.
Provide the information for `Homepage URL` and `Authorization Callback URL` in the following formats:

###### Homepage URL:

`http:External_IP`

###### Authorization Callback URL:

`http:External_IP/auth/github/callback`

`External_IP` is provided once a VM instance is launched.


## SBOM
To access the SBOM of the project, visit `bom.json` or `bom.xml` to get them in json or xml format

## to run game
In order to run the game, you must be a configurable player who has been provided with permission access to play the game. Players are required to login with their github account.

Instruction of how to play the game has been provided on the dashboard. Once you start the game, you will be able to see list of instruction displayed.


## Convenience make tasks
This project includes a couple of convenience `make` tasks. To get the full list
of the tasks run the command `make targets` to see a list of current tasks. For example

```shell
Targets
---------------------------------------------------------------
compile                compile the project
deploy-existing-image  creates an instance using existing gcp docker image
docker-image           builds docker image
format                 Run formatting tools on the code
lint-compile           check for warnings in functions used in the project
lint-format            Check if the project is well formated using elixir formatter
lint                   Check if the project follows set conventions such as formatting
push-and-serve-gcp     creates docker image then push to gcp and launches an instance with the image
push-image-gcp         push image to gcp
release                Build a release of the application with MIX_ENV=prod
test                   Run the test suite
update-instance        updates image of a running instance
```

## game rules
blah blan


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
