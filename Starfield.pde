Particle[] particles;
OddballParticle odd;

double G = 1.0;
double soft2 = 100.0;
double dt = 1.0;

double impulseK = 255.0;
double falloff = 1.0;
double minDist = 10.0;
double randAngleMax = 0.35;
double randScaleMin = 0.8, randScaleMax = 1.2;

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

  for (int i = 1; i < particles.length; i++) {
    Particle p = particles[i];
    if (p == null || odd == null) continue;

    p.ax = 0;
    p.ay = 0;

    double dx = odd.x - p.x;
    double dy = odd.y - p.y;
    double r2 = dx*dx + dy*dy + soft2;
    double invR = 1.0 / Math.sqrt(r2);
    double invR3 = invR * invR * invR;

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

void applyRadialImpulse(double cx, double cy) {
  for (int i = 1; i < particles.length; i++) {
    Particle p = particles[i];
    if (p == null) continue;

    double rx = p.x - cx;
    double ry = p.y - cy;
    double r = Math.sqrt(rx*rx + ry*ry);
    if (r < 1e-6) {
      double th = random(TWO_PI);
      rx = Math.cos(th);
      ry = Math.sin(th);
      r = 1.0;
    } else {
      rx /= r;
      ry /= r;
    }

    double mag = impulseK / Math.pow(r + minDist, falloff);
    mag *= random((float)randScaleMin, (float)randScaleMax);

    double jitter = random((float)(-randAngleMax), (float)(randAngleMax));
    double cosJ = Math.cos(jitter), sinJ = Math.sin(jitter);
    double jx = rx * cosJ - ry * sinJ;
    double jy = rx * sinJ + ry * cosJ;

    p.vx += jx * mag / p.mass;
    p.vy += jy * mag / p.mass;
  }
}

Particle spawnOrbiterAround(double cx, double cy, double M) {
  double r = random(70, min(width, height) * 0.42);
  double theta = random(TWO_PI);

  double x = cx + r * Math.cos(theta);
  double y = cy + r * Math.sin(theta);

  double v = Math.sqrt(G * M / r) * random(0.96, 1.04);
  double vx = -Math.sin(theta) * v;
  double vy =  Math.cos(theta) * v;

  color c = color(random(80,255), random(80,255), random(80,255), 230);
  double mass = random(2.0, 4.0);
  float radius = (float)map((float)mass, 2, 4, 3, 6);

  return new Particle(x, y, 0, 0, c, vx, vy, 0, 0, mass, radius);
}

class Particle {
  double x, y;
  color c;
  double angle, speed;

  double vx, vy, ax, ay;
  double mass;
  float radius;

  Particle() { }

  Particle(double x, double y, double angle, double speed, color c,
           double vx, double vy, double ax, double ay, double mass, float radius) {
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
    ellipse((float)x, (float)y, radius*2, radius*2);
  }
}

class OddballParticle extends Particle {
  OddballParticle(double cx, double cy, double mass) {
    this.x = cx;
    this.y = cy;
    this.mass = mass;
    this.vx = 0; this.vy = 0;
    this.ax = 0; this.ay = 0;
    this.angle = 0; this.speed = 0;
    this.radius = 18;
    this.c = color(255, 60, 210);
  }

  @Override
  void move() {
    this.x = width / 2.0;
    this.y = height / 2.0;
    this.vx = this.vy = 0;
    this.ax = this.ay = 0;
  }

  @Override
  void show() {
    noStroke();
    fill(255, 60, 210, 60);
    ellipse((float)x, (float)y, radius*5, radius*5);
    fill(255, 60, 210);
    ellipse((float)x, (float)y, radius*2, radius*2);
  }
}
