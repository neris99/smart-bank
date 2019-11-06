FROM elixir:1.8.1

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales gcc g++ make \
    && rm -rf /var/cache/apt \
    && mix local.hex --force \
    && mix local.rebar --force \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

RUN mix deps.get && (cd deps/bcrypt_elixir && make clean && make) && mix deps.compile

CMD mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs && mix phx.server
