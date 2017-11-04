// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import {Game} from "./game";

let nickname = prompt("Hello! What's your name?");
let engine = new Phaser.Game(800, 600, Phaser.CANVAS, "phaser", { preload: preload, create: create, update: update });
let game = new Game(engine, nickname);
game.start();

function preload() {
    game.preload(this);
}

function create() {
    game.create(this);
}

function update() {
    game.update(this);
}
