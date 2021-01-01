class Umbrella{
  float x = width/2;
  float y = height/4 * 3;
  float w = 140;

  void update(){
     x = random(width);
  }
    

  void show(){
    noStroke();
    //stroke(250,0,0); //debug
    fill(BGCOLOR);
    rect(x-w/2, y, w, w);
  }
}