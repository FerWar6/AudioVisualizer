class Particle {
  float particleDegrees;
  int particleId;
  PVector currentPos;
  PVector basePos;
  PVector centerPos;

  float velocity = 0;
  float k = 0.02f;
  float distance = 0;



  Particle(float x, float y, int id, float degrees) {
    particleId = id;
    basePos = new PVector(x, y);
    currentPos = new PVector(x, y);
    particleDegrees = degrees;
    centerPos = new PVector(width/2, height/2);
  }

  void update() {
    CalculateCenter();
    GetBackToPos();
  }


  void display() {

    //noStroke();
    //fill(255, 0, 0);
    //ellipse(basePos.x, basePos.y, 3, 3);

    //stroke(45, 197, 244);
    //circle(currentPos.x, currentPos.y, 4);
  }
  void SetVelocity(float vel) {
    velocity = vel;
  }
  float GetVelocity() {
    return velocity;
  }

  void GetBackToPos() {

    float x = calculateX();

    float force = - k * x;

    velocity += force;
    distance += velocity;

    velocity *= 0.995;

    CalculatePosition();
  }
  void CalculatePosition() {
    float angle = radians(particleDegrees);
    PVector currentVector = new PVector(basePos.x + distance * cos(angle), basePos.y + distance * sin(angle));
    currentPos = currentVector;
  }
  float calculateX() {
    float x = dist(centerPos.x, centerPos.y, currentPos.x, currentPos.y) - circleRadius;

    if (-0.09 < x && x < 0.09) {
      return 0;
    }

    return x;
  }
  void CalculateCenter(){
    
    
  }
}
