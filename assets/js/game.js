import {Player} from "./player";
import {Socket} from "phoenix";

export class Game {
    constructor(engine) {
        this.players = [];
        this.bullets = [];
        this.engine = engine;
    }

    start() {
        this._connectToLobby();
        this._updatePlayers();
        this._updateBullets();
        this._hitPlayer();
    }

    preload(state) {
        this.engine.load.image("bullet", "images/bullet.png");
        this.engine.load.image("ship", "images/ship.png");
        this.engine.load.image("space", "images/space.png");
    }

    create(state) {
        this.engine.add.tileSprite(0, 0, 800, 600, "space");

        this._setKeyboard(state);
        this._createPlayer();
    }

    update(state) {
        this.player.update(this.engine, this.cursors, this.shootButton, this.channel);
        this._updateAlpha();
    }

    _updateAlpha() {
        for(let id in this.players) {
            let player = this.players[id];

            if(player.alpha < 1) {
                player.alpha += (1 - player.alpha) * 0.2;
            } else {
                player.alpha = 1;
            }
        }
    }

    _setKeyboard(state) {
        this.cursors = state.input.keyboard.createCursorKeys();
        this.shootButton = state.input.keyboard.addKey(Phaser.KeyCode.SPACEBAR);
    }

    _createPlayer() {
        let sprite = this._createShip(400, 30, "ship", 0);
        sprite.body.collideWorldBounds = true;
        this.player = new Player(sprite);
        this.channel.push("new_player", { x: sprite.x, y: sprite.y, rotation: sprite.rotation });
    }

    _createShip(x, y, type, rotation) {
        let sprite = this.engine.add.sprite(x, y, type);
        this.engine.physics.arcade.enable(sprite);

        sprite.rotation = rotation;
        sprite.body.drag.set(70);
        sprite.body.maxVelocity.set(200);

        return sprite;
    }

    _updatePlayers() {
        this.channel.on("update_players", payload => {
            payload.players.forEach(player => {
                if(!this.players[player.id] && player.id != this.playerId) {
                    this.players[player.id] = this._createShip(player.x, player.y, "ship", player.rotation);
                }

                if (player.id != this.playerId) {
                    this.players[player.id].x = player.x;
                    this.players[player.id].y = player.y;
                    this.players[player.id].rotation = player.rotation;
                }
            });

            for(let id in this.players) {
                if(!payload.players.some(p => p.id == id)) {
                    this.players[id].destroy();
                    delete this.players[id];
                }
            }
        });
    }

    _updateBullets() {
        this.channel.on("update_bullets", payload => {
            payload.bullets.forEach((bullet, index) => {
                if(this.bullets[index]) {
                    this.bullets[index].x = bullet.x;
                    this.bullets[index].y = bullet.y;
                } else {
                    this.bullets[index] = this.engine.add.sprite(bullet.x, bullet.y, "bullet");
                }
            });

            for(let index = payload.bullets.length; index < this.bullets.length; index++){
                this.bullets[index].destroy();
                this.bullets.splice(index, 1);
                index--;
            }
        });
    }

    _hitPlayer() {
        this.channel.on("hit_player", payload => {
            if(this.playerId != payload.player_id) {
                this.players[payload.player_id].alpha = 0;
            } else {
                this.player.sprite.alpha = 0;
            }
        });
    }

    _connectToLobby() {
        let socket = new Socket("/socket", {params: {token: window.userToken}});
        socket.connect();
        let channel = socket.channel("game:lobby", {});
        channel
            .join()
            .receive("ok", payload => this.playerId = payload.player_id);
        this.channel = channel;
    }
}
