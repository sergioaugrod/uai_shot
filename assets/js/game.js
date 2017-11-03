import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});
let channel = socket.channel("game:lobby", {});

let game = new Phaser.Game(800, 600, Phaser.CANVAS, "phaser", { preload: preload, create: create, update: update });

let cursors;
let fireButton;

let players = {};
let bullets = [];

let playerId = null;
let player = {
    sprite: null,
    shoot: false,

    update: function() {
        if (cursors.up.isDown) {
            game.physics.arcade.accelerationFromRotation(this.sprite.rotation, 300, this.sprite.body.acceleration);
        }
        else {
            this.sprite.body.acceleration.set(0);
        }

        if (cursors.left.isDown) {
            this.sprite.body.angularVelocity = -300;
        }
        else if (cursors.right.isDown) {
            this.sprite.body.angularVelocity = 300;
        }
        else {
            this.sprite.body.angularVelocity = 0;
        }

        if (fireButton.isDown && !this.shoot) {
            let speed_x = Math.cos(this.sprite.rotation) * 20;
            let speed_y = Math.sin(this.sprite.rotation) * 20;
            this.shoot = true;

            channel.push("shoot_bullet", { x: this.sprite.x,
                                           y: this.sprite.y,
                                           rotation: this.sprite.rotation,
                                           speed_x: speed_x,
                                           speed_y: speed_y });
        } else if(this.shoot) {
            this.shoot = false;
        }

        if(this.sprite.alpha < 1){
            this.sprite.alpha += (1 - this.sprite.alpha) * 0.2;
        } else {
            this.sprite.alpha = 1;
        }

        game.world.wrap(this.sprite, 16);
        channel.push("move_player", { x: this.sprite.x,
                                      y: this.sprite.y,
                                      rotation: this.sprite.rotation });
    }
};

function preload() {
    game.load.image("bullet", "images/bullet.png");
    game.load.image("ship", "images/ship.png");
}

function createShip(x, y, type, rotation) {
    let sprite = game.add.sprite(x, y, type);
    game.physics.arcade.enable(sprite);

    sprite.rotation = rotation;
    sprite.body.drag.set(70);
    sprite.body.maxVelocity.set(200);

    return sprite;
}

function create() {
    let sprite = createShip(400, 30, "ship", 0);
    player.sprite = sprite;

    cursors = this.input.keyboard.createCursorKeys();
    fireButton = this.input.keyboard.addKey(Phaser.KeyCode.SPACEBAR);

    channel.push("new_player", { x: sprite.x, y: sprite.y, rotation: sprite.rotation });
}

function update() {
    player.update();

    for(let id in players) {
        let player = players[id];

        if(player.alpha < 1) {
            player.alpha += (1 - player.alpha) * 0.2;
        } else {
            player.alpha = 1;
        }
    }
}

socket.connect();

channel
    .join()
    .receive("ok", payload => playerId = payload.player_id);

channel.on("update_players", function(payload){
    payload.players.forEach(player => {
        if(!players[player.id] && player.id != playerId) {
            players[player.id] = createShip(player.x, player.y, "ship", player.rotation);
        }

        if (player.id != playerId) {
            players[player.id].x = player.x;
            players[player.id].y = player.y;
            players[player.id].rotation = player.rotation;
        }
    });

    for(let id in players) {
        if(!payload.players.some(p => p.id == id)) {
            players[id].destroy();
            delete players[id];
        }
    }
});

channel.on("update_bullets", function(payload){
    payload.bullets.forEach((bullet, index) => {
        if(bullets[index] == undefined) {
            bullets[index] = game.add.sprite(bullet.x, bullet.y, "bullet");
        } else {
            bullets[index].x = bullet.x;
            bullets[index].y = bullet.y;
        }
    });

    for(let index = payload.bullets.length; index < bullets.length; index++){
        bullets[index].destroy();
        bullets.splice(index, 1);
        index--;
    }
});

channel.on("hit_player", function(payload){
    if(playerId != payload.player_id) {
        let playerHit = players[payload.player_id];
        playerHit.alpha = 0;
    } else {
        player.sprite.alpha = 0;
    }
});
