# Uai Shot [![Build Status](https://travis-ci.org/sergioaugrod/uai_shot.svg?branch=master)](https://travis-ci.org/sergioaugrod/uai_shot)

A multiplayer ship game built with Elixir, Phoenix Framework and Phaser.

## Demo

<https://uaishot.gigalixirapp.com>

## Prerequisites

You will need the following things properly installed on your computer:

* [Elixir 1.7.3](https://github.com/elixir-lang/elixir)
* [Erlang 21.1](https://www.erlang-solutions.com/resources/download.html)
* [Node.js](https://github.com/nodejs/node)

## Installation

Execute the following commands to install dependencies:

```bash
$ cd uai_shot
$ mix deps.get
$ (cd assets; npm install)
```

## Usage

Init project:

```bash
$ iex -S mix phx.server
```

Now you can visit <http://localhost:4000> from your browser.

## Game

![Game sample](/assets/static/images/game.png)

## Contributing

1. Clone it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
