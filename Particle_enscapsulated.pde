class Particle {
  private float x, y;
  private int c;
  private float angle, speed;

  private float vx, vy, ax, ay;
  private float mass;
  private float radius;

  public Particle() {
    this(0, 0, 0, 0, color(255), 0, 0, 0, 0, 1, 4);
  }

  public Particle(float x, float y, float angle, float speed, int c,
                  float vx, float vy, float ax, float ay, float mass, float radius) {
    this.x = x; this.y = y;
    this.angle = angle; this.speed = speed;
    this.c = c;
    this.vx = vx; this.vy = vy;
    this.ax = ax; this.ay = ay;
    this.mass = mass;
    this.radius = radius;
  }

  public void move() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
    wrap(40);
  }

  public void integrate(float dt) {
    vx += ax * dt;
    vy += ay * dt;
    x  += vx * dt;
    y  += vy * dt;
    wrap(40);
  }

  private void wrap(float margin) {
    if (x < -margin) x = width + margin;
    if (x > width + margin) x = -margin;
    if (y < -margin) y = height + margin;
    if (y > height + margin) y = -margin;
  }

  public void show() {
    noStroke();
    fill(c);
    ellipse(x, y, radius*2, radius*2);
  }

  public float getX() { return x; }
  public float getY() { return y; }
  public int   getColor() { return c; }
  public float getAngle() { return angle; }
  public float getSpeed() { return speed; }

  public float getVx() { return vx; }
  public float getVy() { return vy; }
  public float getAx() { return ax; }
  public float getAy() { return ay; }

  public float getMass() { return mass; }
  public float getRadius() { return radius; }

  public void setX(float v) { x = v; }
  public void setY(float v) { y = v; }
  public void setColor(int col) { c = col; }
  public void setAngle(float v) { angle = v; }
  public void setSpeed(float v) { speed = v; }

  public void setVx(float v) { vx = v; }
  public void setVy(float v) { vy = v; }
  public void setAx(float v) { ax = v; }
  public void setAy(float v) { ay = v; }

  public void setMass(float v) { mass = v; }
  public void setRadius(float v) { radius = v; }
}
