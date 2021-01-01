class Player{
  float x = width/2;
  float y = height;
  float w = 50;
  float h = 80;

  int hp;
  
  void set(){
     x = width/2;
     y = height;
     hp = field.H * field.W; 
  }

  void gameover(){
    scene = END;
    //println("dead"); //debug
  }

  void update(){
    x = px;
    hp = php;
    if(hp < 0) gameover();
  }
    

  void show(){
    if(cflg){ //if hit body to red
     if(pdir == -1) image(imgPlayerDmgLeft,px-player.w/2, height-80);
     if(pdir ==  1) image(imgPlayerDmgRight,px-player.w/2, height-80);
     //fill(255, 0, 0); //debug
     //ellipse(x, y, w, w); //debug
     cflg = false;
    }
    noStroke();
    // stroke(250,0,50);  //debug
    noFill();
    rect(x-w/2, y-h, w, h);
    fill(250);
    textSize(20);
    text("HP: " + hp, 10, 20);
  }
}