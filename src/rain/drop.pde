class Drop{
  float x = random(width);
  float y = random(-500, -50);
  float z = random(0,20);

  float len = map(z, 0, 20, 10, 20);
  float yspeed = map(z, 0, 20, 4, 10);
  
  //color
  float red = random(255);
  float green = random(255);
  float blue = random(255);
  float thick;

  void fall(){
    y = y + yspeed;
     
    float grav = map(z, 0, 20, 0, 0.2);
    yspeed = yspeed +grav;//gravity

    //Reset y pos if outof height
    if(y > height){
      y = random(-200, -100);
      yspeed = map(z, 0, 20, 4, 10);
      red = random(255);
      green = random(255);
      blue = random(255);
    }
  }

  void show(){
    thick = map(z, 0, 20, 1, 3);
    strokeWeight(thick);
    //stroke(125);
    stroke(red, green, blue);
    line(x, y, x, y + len);
  }
}