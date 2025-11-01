class OddballParticle extends Particle {

  public OddballParticle(float cx, float cy, float mass) {
    super(cx, cy,
          0, 0,
          color(255, 60, 210),
          0, 0, 0, 0,
          mass,
          18);
  }

  @Override
  public void integrate(float dt) {
    setX(width / 2.0);
    setY(height / 2.0);
    setVx(0);
    setVy(0);
    setAx(0);
    setAy(0);
  }

  @Override
  public void show() {
    noStroke();
    fill(255, 60, 210, 60);
    ellipse(getX(), getY(), getRadius()*5, getRadius()*5);
    fill(255, 60, 210);
    ellipse(getX(), getY(), getRadius()*2, getRadius()*2);
  }
}
