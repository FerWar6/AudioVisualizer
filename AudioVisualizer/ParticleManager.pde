class ParticleManager {

  ParticleManager() {
    centerPos = new PVector(width/2, height/2);
    circleRadius = circleDiameter/2;
    particles = new ArrayList<Particle>();
    innerParticles  = new ArrayList<InnerParticle>();
    SpawnMainParticles();
    SpawnInnerParticles();
  }

  void update() {
    for (Particle p : particles) {
      p.update();
    }
    for (InnerParticle p : innerParticles) {
      p.update();
    }
    // update the current wave strength
    calculateWaveStrength();

    innerParticleRotationSpeed = sum * rotationMultiplier;

    if (!songPaused) {
      CalculateWave();
      UpdateInnerParticles();
      UpdateCircleSize();
    }

    if (beatDetector.isBeat()) {
      int centerId = int(random(0, particles.size()));

      findParticle(centerId).SetVelocity(currentWaveStrength);
    }
  }


  void display() {

    if (!isMenuOpen) {
      DrawLines();
      // Display all particles
      for (Particle v : particles) {
        v.display();
      }
      for (InnerParticle v : innerParticles) {
        v.display();
      }
    }
  }

  void calculateWaveStrength() {
    float realVolume = map(amp.analyze(), 0, curSoundVol, 0, 100);
    sum += (realVolume - sum) * smoothingFactor;
    currentWaveStrength = map(sum, 0, 1, 0, 100);
  }
  void CalculateWave() {
    float[] leftDeltas = new float[particles.size()];
    float[] rightDeltas = new float[particles.size()];

    // Do passes where particles affect their neighbors
    for (int pass = 0; pass < 8; pass++) {
      // Calculate deltas for each particle

      for (int i = 0; i < particles.size(); i++) {
        int leftNeighbor = (i - 1 + particles.size()) % particles.size();
        int rightNeighbor = (i + 1) % particles.size();

        // Calculate left and right deltas
        leftDeltas[i] = particles.get(i).distance - particles.get(leftNeighbor).distance;
        rightDeltas[i] = particles.get(i).distance - particles.get(rightNeighbor).distance;

        particles.get(leftNeighbor).velocity += leftDeltas[i] * spread;
        particles.get(rightNeighbor).velocity += rightDeltas[i] * spread;
      }
    }
    for (int i = 0; i < particles.size(); i++) {
      if (i > 0)
        particles.get(i - 1).distance += leftDeltas[i] * spread;
      if (i < particles.size() - 1)
        particles.get(i + 1).distance += rightDeltas[i] * spread;
    }
  }
  void DrawLines() {
    for (int i = 0; i < particles.size(); i++) {

      Particle previousParticle = findParticle((i - 1 + particles.size()) % particles.size());
      Particle mainParticle = findParticle(i);
      stroke(outerParticles);
      strokeWeight(lineThickness);
      line(previousParticle.currentPos.x, previousParticle.currentPos.y, mainParticle.currentPos.x, mainParticle.currentPos.y);
    }
  }
  void UpdateInnerParticles() {
    for (int i = 0; i < innerParticles.size(); i++) {
      InnerParticle currentParticle = innerParticles.get(i);
      if (currentParticle != null) {
        float distanceFromCenterToParticle = findParticle(currentParticle.particleId).distance + circleRadius;
        float dis =  distanceFromCenterToParticle / (numberOfInnerParticles + 1) * (currentParticle.particleIdInRow + 1);
        currentParticle.distance = dis;
      }
    }
  }
  void UpdateCircleSize() {
    float basePlusRaidus = circleRadius + currentWaveStrength * growSize;
    for (Particle p : particles) {
      float angle = radians(p.particleDegrees);
      PVector currentVector = new PVector(centerPos.x + basePlusRaidus * cos(angle), centerPos.y + basePlusRaidus * sin(angle));
      p.basePos = currentVector;
    }
  }

  //function to spawn the outer ring of particles
  void SpawnMainParticles() {
    int degrees = 0;

    for (int i =0; i < numberOfParticles; i++)
    {

      int pixelsPerDegrees = 360 / numberOfParticles;

      degrees = degrees + pixelsPerDegrees;

      if (degrees > 360) {
        degrees = degrees - 360;
      }

      float angle = radians(degrees);
      PVector currentVector = new PVector(centerPos.x + circleRadius * cos(angle), centerPos.y + circleRadius * sin(angle));
      particles.add(new Particle(currentVector.x, currentVector.y, i, degrees));
    }
  }

  //function to spawn all of the inner particles
  void SpawnInnerParticles() {
    for (int j = 0; j < numberOfParticles; j++) {
      for (int i = 0; i < numberOfInnerParticles; i++) {
        currentWaveStrength = map(i, 0, numberOfInnerParticles - 1, 0, 100);

        float canSpawn = random(i - numberOfInnerParticles - 1, 0);
        if (canSpawn > -1.5) {
          innerParticles.add(new InnerParticle(j, i, 1));
        }
      }
    }
  }

  // function to find a particle by id
  Particle findParticle(int id) {
    if (id < 0 || id >= numberOfParticles) {
      return null;
    }

    for (Particle p : particles) {
      if (p.particleId == id) {
        return p;
      }
    }
    return null;
  }

  // function to find an inner particle by id
  InnerParticle findInnerParticle(int id) {
    if (id < 0 || id >= innerParticles.size()) {
      return null;
    }

    for (InnerParticle p : innerParticles) {
      if (p.particleId == id) {
        return p;
      }
    }
    return null;
  }
}
