UGUITO API
================

## API Documentation

[UGUITO API Apiary](https://widergytraininguguitoapi.docs.apiary.io)

## Running local server

### 1- Installing basic dependencies:

  - If you are using Ubuntu:

  ```bash
    sudo apt update
    sudo apt install build-essential libpq-dev nodejs libssl-dev libreadline-dev zlib1g-dev redis-server
  ```

  - If you are using MacOS:

  ```bash
    brew install postgresql
    brew install redis
  ```

### 2- Installing Ruby

- Clone the repository by running `git clone {REMOTE_URL}`
- Go to the project root by running `cd {REPOSITORY_NAME}`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout). Read the [How rbenv hooks into your shell](https://github.com/rbenv/rbenv#how-rbenv-hooks-into-your-shell) section and the `rbenv init - ` output carefully. You may need to do step 1 of that section manually.
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 3- Installing Rails gems

- Inside your project's directory install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-document
  rbenv rehash
```
- Install all the gems included in the project.

```bash
  bundle -j 20
```

### 4- Database Setup

- Install postgres in your local machine:

  - If you are using Ubuntu:

  ```bash
    sudo apt install postgresql
  ```

  - If you are using MacOS: install [Postgres.app](https://postgresapp.com/)

- Create the database role:

  - If you are using Ubuntu:

    Run in terminal:

    ```bash
      sudo -u postgres psql
      CREATE ROLE "uguito-api" LOGIN CREATEDB PASSWORD 'uguito-api';
    ```

  - If you are using MacOS:

    Run in terminal:

    ```bash
      psql -U postgres
      CREATE ROLE "uguito-api" LOGIN CREATEDB PASSWORD 'uguito-api';
    ```

- Log out from postgres

- Check if you have to get a `.env` file, and if you have to, copy it to the root.

- Create the development database. Run in terminal:

```bash
  bundle exec rake db:create db:migrate
```

### 5- Application Setup



Your server is ready to run. You can do this by executing `bundle exec rails server` inside the project's directory and going to [http://localhost:3000](http://localhost:3000).

Your app is ready. Happy coding!

PS: If you don't want to have to use `bundle exec` for rails commands, then run in terminal:

```bash
  sudo gem install rails
```

If you want to access to the rails console you can just execute `rails console` inside the project's directory.

#### Running tests & linters

- For running the test suite:

  - The first time assure to have redis up. Run in terminal:

  ```bash
    redis-server
  ```

  - Run in terminal:

  ```bash
    bundle exec rspec
  ```

- For running code style analyzer:

```bash
  bundle exec rubocop app spec
```

#### Git pre push hook

You can modify the [pre-push.sh](script/pre-push.sh) script to run different scripts before you `git push` (e.g Rspec, Linters). Then you need to run the following:

```bash
  chmod +x script/pre-push.sh
  sudo ln -s ../../script/pre-push.sh .git/hooks/pre-push
```

You can skip the hook by adding `--no-verify` to your `git push`.

## About

This project is written by [Widergy](http://www.widergy.com).

[![W-logotipo-RGBsinfondo.png](https://i.postimg.cc/Vsg8YBwL/W-logotipo-RGBsinfondo.png)](https://postimg.cc/G94NKD9Z)
