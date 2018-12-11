import css from '../css/app.css';

import 'pixi';
import 'p2';
import Phaser from 'phaser';

import {Game} from './game';

let nickname = prompt("Hello! What's your name?");
let engine = new Phaser.Game(800, 600, Phaser.CANVAS, 'phaser', { preload: preload, create: create, update: update });
let game = new Game(engine, nickname);

function preload() {
    game.preload(this);
}

function create() {
    game.create(this);
}

function update() {
    game.update(this);
}
