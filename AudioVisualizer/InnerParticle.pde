class InnerParticle {

  int particleId;
  int particleIdInRow;
  PVector currentPos;
  float size;

  float distance= 0;
  float baseRotation;
  InnerParticle(int id, int idInRow, float particleSize) {
    particleId = id;
    particleIdInRow = idInRow;
    size = particleSize;
    //currentPos = new PVector(25 + (id * 5), 25 + (idInRow * 5));
    baseRotation = 360 / numberOfParticles * particleId;
  }

  void update() {
    CalculatePos();
  }


  void display() {
    int r = Math.round(red(innerParticlesIn) * numberOfInnerParticles / (particleIdInRow + 1));
    int g = Math.round(green(innerParticlesIn) / numberOfInnerParticles * (particleIdInRow + 1));
    int b = Math.round(blue(innerParticlesIn) / numberOfInnerParticles * (particleIdInRow + 1));

    noFill();
    strokeWeight(1);
    stroke(r, g, b);

    circle(currentPos.x, currentPos.y, size);
  }
  void CalculatePos() {
    float angle = radians(baseRotation);
    baseRotation += innerParticleRotationSpeed;
    if (baseRotation > 360) {
      baseRotation = baseRotation - 360;
    }
    PVector currentVector = new PVector(centerPos.x + distance * cos(angle), centerPos.y + distance * sin(angle));
    currentPos = currentVector;
  }
}
