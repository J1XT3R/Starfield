class OddballParticle extends Particle {
  OddballParticle(float cx, float cy, float mass) {
    this.x = cx;
    this.y = cy;
    this.mass = mass;
    this.vx = 0; this.vy = 0;
    this.ax = 0; this.ay = 0;
    this.angle = 0; this.speed = 0;
    this.radius = 18;
    this.c = color(255, 60, 210);
  }

  void integrate() {
    this.x = width / 2.0;
    this.y = height / 2.0;
    this.vx = 0;
    this.vy = 0;
    this.ax = 0;
    this.ay = 0;
  }

  void show() {
    noStroke();
    fill(255, 60, 210, 60);
    ellipse(x, y, radius*5, radius*5);
    fill(255, 60, 210);
    ellipse(x, y, radius*2, radius*2);
  }
}
