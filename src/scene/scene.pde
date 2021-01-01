

final int START = 0;
final int GAME = 1;
final int END = 2;

int scene = 0;

void setup(){
  size(640, 360);
  textSize(50);
}

void draw(){
  if(scene == START) start_scene();
  if(scene == GAME ) game_scene();
  if(scene == END ) end_scene();
}

/*
  START
*/
void start_scene(){
  background(200); 
  
  fill(0);
  text("Start", width/5, height/2);
  text("Press space key", width/5, height/2+60);
}

/*
  MAIN
*/
void game_scene(){
  
  background(200); 
  fill(0);
  text("GAME", width/5, height/2);
  text("Press q key", width/5, height/2+60);
}

/*
  END
*/
void end_scene(){
  background(200); 
  fill(0);
  text("END", width/5, height/2);
  text("Press space key", width/5, height/2+60);
  text("Back to START", width/5, height/2+120);
}


/*

*/
void keyPressed() {
  if(scene == START) if(key == ' ') scene = GAME; //press SPACE key
  if(scene == GAME)  if(key == 'q') scene = END; //press q key
  if(scene == END)   if(key == ' ') scene = START; //press SPACE key
}