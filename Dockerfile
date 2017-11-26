FROM elixir:1.5

ENV MIX_ENV prod
ENV PORT 4000

# Install Hex, Rebar and Phoenix
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

RUN mkdir /opt/uai_shot
ADD . /opt/uai_shot
WORKDIR /opt/uai_shot

# Install assets deps
RUN (cd assets; npm install)
RUN (cd assets; node node_modules/brunch/bin/brunch build)

RUN mix do deps.get
RUN mix phx.digest

CMD mix phx.server

EXPOSE 4000
