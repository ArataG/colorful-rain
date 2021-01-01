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


void settings(){
  size(640, 360);
  //size(640, 480);
  imgUmbrella = loadImage("img/umbrella.png");
  imgPlayerRunRight = loadImage("img/player_run_right.png");
  imgPlayerRunLeft = loadImage("img/player_run_left.png");
  imgPlayerDmgRight =loadImage("img/player_dmg_right.png");
  imgPlayerDmgLeft =loadImage("img/player_dmg_left.png");
  //size(imgUmbrella.width/2, imgUmbrella.height/2);
}

void setup(){
  imgUmbrella.resize(250, 190);
  for (int i = 0; i < drops.length; ++i) {
    drops[i] = new Drop();
  }
  ub = new Umbrella();
  player = new Player();
  field = new Field(); 
}

void draw(){
  if(scene == START) start_scene();
  if(scene == GAME ) game_scene();
  if(scene == END ) end_scene();
  if(scene == SAVE ) save_scene();
}

/*
  START
*/
void start_scene(){
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

void game_scene(){
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

  float pspeed = 0.01;
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
void end_scene(){
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

void save_scene(){
  background(BGCOLOR); 
  field.show();
  //save
  String fileName= nf(year(), 2) + nf(month(), 2) + nf(day(), 2) +"-"+ nf(hour(), 2) + nf(minute(), 2)+nf(second(), 2);
  fileName += ".jpeg";
  save(fileName);

  scene = END;
}




void keyPressed() {
  if(scene == START){
    if(key == ' ') mode = PLAY;
    if(key == 'a') mode = AUTO;
    scene = GAME; 
  }
  if(scene == GAME)  if(key == 'q') scene = START; //press q key
  if(scene == END)   if(key == ' ') scene = SAVE; //press SPACE key
  if(scene == END)   if(key == 'q') scene = START; //press SPACE key
}