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

  void set(){
    for (int h = 0; h < H; ++h){
      for (int w = 0; w < W; ++w) {
        int pos = w + h * W;
        valr[pos] = 0;
        valg[pos] = 0;
        valb[pos] = 0;
      }
    }
  }

  void update(float r, float g, float b, float t){
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
  
  void demo(){
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
  
  void show(){
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