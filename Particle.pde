class Particle {
  float x, y;
  color c;
  float angle, speed;

  float vx, vy, ax, ay;
  float mass;
  float radius;

  Particle() { }

  Particle(float x, float y, float angle, float speed, color c,
           float vx, float vy, float ax, float ay, float mass, float radius) {
    this.x = x; this.y = y;
    this.angle = angle; this.speed = speed;
    this.c = c;
    this.vx = vx; this.vy = vy;
    this.ax = ax; this.ay = ay;
    this.mass = mass;
    this.radius = radius;
  }

  void move() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;

    float margin = 40;
    if (x < -margin) x = width + margin;
    if (x > width + margin) x = -margin;
    if (y < -margin) y = height + margin;
    if (y > height + margin) y = -margin;
  }

  void integrate() {
    vx += ax * dt;
    vy += ay * dt;
    x  += vx * dt;
    y  += vy * dt;

    float margin = 40;
    if (x < -margin) x = width + margin;
    if (x > width + margin) x = -margin;
    if (y < -margin) y = height + margin;
    if (y > height + margin) y = -margin;
  }

  void show() {
    noStroke();
    fill(c);
    ellipse(x, y, radius*2, radius*2);
  }
}
