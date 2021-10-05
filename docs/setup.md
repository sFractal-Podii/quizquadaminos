# Setup guide
## Quick start locally

First ensure you have the following set up in your computer
- elixir 1.11.2
- nodejs > 12 LTS
- Postgresql > 11

You can use [the phoenix installation guide](https://hexdocs.pm/phoenix/installation.html#content) to ensure you
have everything set up as expected

### Start server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Set up Github OAuth app

Use [Github guide](https://docs.github.com/en/developers/apps/creating-an-oauth-app) to create an OAuth app.
Provide the information for `Homepage URL` and `Authorization Callback URL` in the following formats:

###### Homepage URL:

`http:External_IP`

###### Authorization Callback URL:

`http:External_IP/auth/github/callback`

`External_IP` is provided once a VM instance is launched.

## Set up Google OAuth app
Instructions to setup Google OAuth app can be found on [google setup docs](./docs/google_setup.md)

## Set up LinkedIn OAuth app
Instructions to setup LinkedIn OAuth app can be found on [google setup docs](./docs/linkedin_setup.md)

## SBOM
To access the SBOM of the project, visit `bom.json` or `bom.xml` to get them in json or xml format

## permission to run game
In order to run the game, you must be a configurable player who has been provided with permission access to play the game. Players are required to login with their github account.

Instruction of how to play the game has been provided on the dashboard. Once you start the game, you will be able to see list of instruction displayed.
