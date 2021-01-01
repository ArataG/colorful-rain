import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class rain extends PApplet {

//settings

final int BGCOLOR = 50;
final int MAXDROP = 1000; //mac number of DROPS

// roop cnt
int cnt = 0;
int score = 0;

//manage scene
final int START = 0;
final int GAME = 1;
final int END = 2;
final int SAVE = 3;

int scene = 0;

final int AUTO = 1;
final int PLAY = 0;
int mode = 0;

//rain
Drop[] drops = new Drop[MAXDROP];

//umbrella
PImage imgUmbrella;
Umbrella ub;

//field
Field field;

//player setthing
PImage imgPlayerRunRight;
PImage imgPlayerRunLeft;
PImage imgPlayerDmgRight;
PImage imgPlayerDmgLeft;
Player player;
float px = width/2;
int php;
int pdir = 1;
boolean cflg = false;


public void settings(){
  size(640, 360);
  //size(640, 480);
  imgUmbrella = loadImage("img/umbrella.png");
  imgPlayerRunRight = loadImage("img/player_run_right.png");
  imgPlayerRunLeft = loadImage("img/player_run_left.png");
  imgPlayerDmgRight =loadImage("img/player_dmg_right.png");
  imgPlayerDmgLeft =loadImage("img/player_dmg_left.png");
  //size(imgUmbrella.width/2, imgUmbrella.height/2);
}

public void setup(){
  imgUmbrella.resize(250, 190);
  for (int i = 0; i < drops.length; ++i) {
    drops[i] = new Drop();
  }
  ub = new Umbrella();
  player = new Player();
  field = new Field(); 
}

public void draw(){
  if(scene == START) start_scene();
  if(scene == GAME ) game_scene();
  if(scene == END ) end_scene();
  if(scene == SAVE ) save_scene();
}

/*
  START
*/
public void start_scene(){
  background(BGCOLOR); 
  player.set();
  field.set();
  php = player.hp;
  fill(250);
  textSize(50);
  text("Start", width/5, height/2);
  text("Press space key", width/5, height/2+60);
}

/*
  GAME
*/

public void game_scene(){
  int st = millis();
  
  background(BGCOLOR);

  //Drop
  for (int i = 0; i < drops.length; ++i) {
    drops[i].fall();
    drops[i].show();
  }
  
  //Umbrella
  ub.show(); 
  if(cnt%300 == 0 )ub.update();
  image(imgUmbrella,ub.x-ub.w+10, height/2);
  

  //player
  float tx = 0;
  if(mode == AUTO) tx = ub.x;
  else tx = mouseX; 

  float pspeed = 0.01f;
  if(px > tx) {  
    image(imgPlayerRunLeft,px-player.w/2, height-80);
    px -= pspeed*abs(px-tx); 
    pdir = -1;
  } 
  else {
    image(imgPlayerRunRight,px-player.w/2, height-80);
    px += pspeed*abs(px-tx);
    pdir = 1;
  }

  //collision detect
  for (int i = 0; i < drops.length; ++i) {
    if(px < ub.x + ub.w/2 && ub.x - ub.w/2 < px) continue; //umbrella
    if(drops[i].y < height - player.h/2) continue; //player height outrange
    if(drops[i].x < px + player.w/2  && drops[i].x > px-player.w/2){
      //println("hit");
      php -= 1;
      cflg = true;
      field.update(drops[i].red, drops[i].green, drops[i].blue, drops[i].thick);
      continue;
    }
    //else println("safe");
  }
  player.update();
  player.show();
  
  cnt++; //roop cnt add
  int et;
  do{
    et = millis()-st;
  }while(et < 30);

}

/*
  END
*/
public void end_scene(){
  background(BGCOLOR); 
  score = cnt;
  fill(250);
  textSize(20);
  text("SCORE: " + score, 25, 25);
  textSize(30);
  text("SPACE -> SAVE", width/5, height/2+120);
  text("q         -> Return START", width/5, height/2+150);

  field.demo();
}


/*
  SAVE
*/

public void save_scene(){
  background(BGCOLOR); 
  field.show();
  //save
  String fileName= nf(year(), 2) + nf(month(), 2) + nf(day(), 2) +"-"+ nf(hour(), 2) + nf(minute(), 2)+nf(second(), 2);
  fileName += ".jpeg";
  save(fileName);

  scene = END;
}




public void keyPressed() {
  if(scene == START){
    if(key == ' ') mode = PLAY;
    if(key == 'a') mode = AUTO;
    scene = GAME; 
  }
  if(scene == GAME)  if(key == 'q') scene = START; //press q key
  if(scene == END)   if(key == ' ') scene = SAVE; //press SPACE key
  if(scene == END)   if(key == 'q') scene = START; //press SPACE key
}
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

  public void fall(){
    y = y + yspeed;
     
    float grav = map(z, 0, 20, 0, 0.2f);
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

  public void show(){
    thick = map(z, 0, 20, 1, 3);
    strokeWeight(thick);
    //stroke(125);
    stroke(red, green, blue);
    line(x, y, x, y + len);
  }
}
class Field{
  final int H = 45;
  final int W  = 80;
  int p = 0;
  int len = H * W;
  float[] valr = new float[H*W];
  float[] valg = new float[H*W];
  float[] valb = new float[H*W];
  float[] valt = new float[H*W]; //thick
  float[] valh = new float[H*W]; 
  float[] valw = new float[H*W]; 
  
  float lit = 130;

  public void set(){
    for (int h = 0; h < H; ++h){
      for (int w = 0; w < W; ++w) {
        int pos = w + h * W;
        valr[pos] = 0;
        valg[pos] = 0;
        valb[pos] = 0;
      }
    }
  }

  public void update(float r, float g, float b, float t){
      if(p < H * W){
        valr[p] = r;
        valg[p] = g; 
        valb[p] = b; 
        valt[p] = t;
        valh[p] = random(45);
        valw[p] = random(80);
      }
      p++; 
  }
  
  public void demo(){
    int mag = 4;
    for (int h = 0; h < H; ++h){
      for (int w = 0; w < W; ++w) {
        int pos = w + h * W;
        stroke(valr[pos], valg[pos], valb[pos],lit+20);
        fill(valr[pos], valg[pos], valb[pos],lit);
        //mosaic
        // rect(w+w*mag+120, h+h*mag+30, 4, 4); //mosaic
        
        //ellipse random
        ellipse(valw[pos]+valw[pos]*mag+ 120,valh[pos]+valh[pos]*mag + 30, valt[pos]*mag, valt[pos]*mag); 
      }
    }
  }
  
  public void show(){
    int mag = width/W; 
    for (int h = 0; h < H; ++h){
      for (int w = 0; w < W; ++w) {
        int pos = w + h * W;
        stroke(valr[pos], valg[pos], valb[pos],lit+20);
        fill(valr[pos], valg[pos], valb[pos], lit);
        //mosaic
        //rect(w+w*mag, h+h*mag, mag, mag);
        
        //ellipse
        ellipse(valw[pos]+valw[pos]*mag,valh[pos]+valh[pos]*mag, valt[pos]*mag, valt[pos]*mag); 
      }
    }
  }


}
class Player{
  float x = width/2;
  float y = height;
  float w = 50;
  float h = 80;

  int hp;
  
  public void set(){
     x = width/2;
     y = height;
     hp = field.H * field.W; 
  }

  public void gameover(){
    scene = END;
    //println("dead"); //debug
  }

  public void update(){
    x = px;
    hp = php;
    if(hp < 0) gameover();
  }
    

  public void show(){
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
class Umbrella{
  float x = width/2;
  float y = height/4 * 3;
  float w = 140;

  public void update(){
     x = random(width);
  }
    

  public void show(){
    noStroke();
    //stroke(250,0,0); //debug
    fill(BGCOLOR);
    rect(x-w/2, y, w, w);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rain" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
