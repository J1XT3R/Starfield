Particle[] particles;
OddballParticle odd;

float G = 1.0;
float soft2 = 100.0;
float dt = 1.0;

float impulseK = 255.0;
float falloff = 1.0;
float minDist = 10.0;
float randAngleMax = 0.35;
float randScaleMin = 0.8, randScaleMax = 1.2;

void setup() {
  size(900, 600);

  int N = 120;
  particles = new Particle[N];

  odd = new OddballParticle(width/2.0, height/2.0, 5000.0);
  particles[0] = odd;

  for (int i = 1; i < N; i++) {
    particles[i] = spawnOrbiterAround(width/2.0, height/2.0, odd.mass);
  }

  noStroke();
}

void draw() {
  background(10);

  // compute gravity from oddball to others
  for (int i = 1; i < particles.length; i++) {
    Particle p = particles[i];
    if (p == null || odd == null) continue;

    p.ax = 0;
    p.ay = 0;

    float dx = odd.x - p.x;
    float dy = odd.y - p.y;
    float r2 = dx*dx + dy*dy + soft2;
    float invR = 1.0 / sqrt(r2);
    float invR3 = invR * invR * invR;

    p.ax += G * odd.mass * dx * invR3;
    p.ay += G * odd.mass * dy * invR3;
  }

  if (odd != null) odd.show();

  for (int i = 1; i < particles.length; i++) {
    Particle p = particles[i];
    if (p == null) continue;
    p.move();
    p.show();
  }
}

void mousePressed() {
  applyRadialImpulse(mouseX, mouseY);
}

void applyRadialImpulse(float cx, float cy) {
  for (int i = 1; i < particles.length; i++) {
    Particle p = particles[i];
    if (p == null) continue;

    float rx = p.x - cx;
    float ry = p.y - cy;
    float r = sqrt(rx*rx + ry*ry);
    if (r < 1e-6) {
      float th = random(TWO_PI);
      rx = cos(th);
      ry = sin(th);
      r = 1.0;
    } else {
      rx /= r;
      ry /= r;
    }

    float mag = impulseK / pow(r + minDist, falloff);
    mag *= random(randScaleMin, randScaleMax);

    float jitter = random(-randAngleMax, randAngleMax);
    float cosJ = cos(jitter), sinJ = sin(jitter);
    float jx = rx * cosJ - ry * sinJ;
    float jy = rx * sinJ + ry * cosJ;

    p.vx += jx * mag / p.mass;
    p.vy += jy * mag / p.mass;
  }
}

Particle spawnOrbiterAround(float cx, float cy, float M) {
  float r = random(70, min(width, height) * 0.42);
  float theta = random(TWO_PI);

  float x = cx + r * cos(theta);
  float y = cy + r * sin(theta);

  float v = sqrt(G * M / r) * random(0.96, 1.04);
  float vx = -sin(theta) * v;
  float vy =  cos(theta) * v;

  color c = color(random(80,255), random(80,255), random(80,255), 230);
  float mass = random(2.0, 4.0);
  float radius = map(mass, 2, 4, 3, 6);

  return new Particle(x, y, 0, 0, c, vx, vy, 0, 0, mass, radius);
}

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
    fill(c);
    ellipse(x, y, radius*2, radius*2);
  }
}

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

  void move() {
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
