void setup(){
  size(640, 360); //サイズ設定
}

void draw(){
  background(200);
  fill(0);
  textSize(50);
  text("Save?", width/5, height/2);
  text("Press ENTER key", width/5, height/2+60);
}

void keyPressed(){
  //エンターキーが押されたら
  if(keyCode == ENTER){
    String fileName= nf(year(), 2) + nf(month(), 2) + nf(day(), 2) +"-"+ nf(hour(), 2) + nf(minute(), 2)+nf(second(), 2);
    fileName += ".jpeg";
    save(fileName);
  }
}