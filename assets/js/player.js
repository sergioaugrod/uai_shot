export class Player {
    constructor(sprite) {
        this.sprite = sprite;
        this.shoot = false;
    }

    update(game, cursors, shootButton, channel) {
        this._checkCursors(cursors, game);
        this._checkShoot(shootButton, channel);
        this._updateAlpha();
        this._movePlayer(channel);
    }

    _movePlayer(channel) {
        channel.push('move_player', { x: this.sprite.x, y: this.sprite.y, rotation: this.sprite.rotation });
    }

    _shootBullet(channel) {
        let speedX = Math.cos(this.sprite.rotation) * 20;
        let speedY = Math.sin(this.sprite.rotation) * 20;

        channel.push('shoot_bullet', { x: this.sprite.x, y: this.sprite.y, rotation: this.sprite.rotation, speed_x: speedX, speed_y: speedY });
    }

    _checkCursors(cursors, game) {
        if (cursors.up.isDown) {
            game.physics.arcade.accelerationFromRotation(this.sprite.rotation, 300, this.sprite.body.acceleration);
        } else {
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
    }

    _checkShoot(shootButton, channel) {
        if (shootButton.isDown && !this.shoot) {
            this.shoot = true;
            this._shootBullet(channel);
        } else if(this.shoot) {
            this.shoot = false;
        }
    }

    _updateAlpha() {
        if(this.sprite.alpha < 1){
            this.sprite.alpha += (1 - this.sprite.alpha) * 0.2;
        } else {
            this.sprite.alpha = 1;
        }
    }
}
