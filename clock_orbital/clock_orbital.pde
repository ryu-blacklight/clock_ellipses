int radiusHour, radiusMin, radiusSec, radiusStr1, radiusStr2, varI1;

int[] colors = {160,100,100};  //色のHSBだけ格納。

int[][] backEllipse = new int [20][20];

float[][] secCoord = new float [2][60];  //秒ごとの座標の二次元配列。
float[][] minCoord = new float [2][60];  //分ごと。
float[][] hourCoord = new float [2][24];  //時間ごと。

float[][] stringCoord1 = new float [2][8];  //時刻目盛り。
float[][] stringCoord2 = new float [2][12];  //分と秒目盛り。

boolean[] visSec = new boolean [60]; //最初に配置した図形の可視性の値を保管。
boolean[] visMin = new boolean [60];
boolean[] visHour = new boolean [24];


void setup(){  
  size(800,800);
  colorMode(HSB, 360, 100, 100, 1);
  frameRate(30);
  
  radiusSec = 350;
  radiusMin = 320;
  radiusHour = 200;
  radiusStr1 = 166;
  radiusStr2 = 296;
  //中心からの距離を設定。
  //好きな自然数を入れてヨシ！
  
  repeatCalc(60, 6, "second");
  repeatCalc(60, 6, "minute");
  repeatCalc(24, 15, "hour");
  repeatCalc(8, 45, "24/3");
  repeatCalc(12, 30, "60/5");
  
  varI1 = 1;
}


void draw(){
  translate(width/2,height/2);
  background(0,0,0,1);
  
  backEllipse();
  
  visiblitySet();
  
  for(int i = 0; i < 60; i++){
    setEllipse(secCoord[0][i], secCoord[1][i], 8, true, visSec[i]);
    setEllipse(minCoord[0][i], minCoord[1][i], 20 ,false, visMin[i]);
  }
  for(int j = 0; j < 24; j++){
    setEllipse(hourCoord[0][j], hourCoord[1][j], 36, false, visHour[j]);
  }
  
  for(int k = 0; k < 8; k++){
    int varK = k*3;
    setScale(stringCoord1[0][k], stringCoord1[1][k], varK);
  }
  for(int l = 0; l < 12; l++){
    int varL = l*5;
    setScale(stringCoord2[0][l], stringCoord2[1][l], varL);
  }
  
  secCounter();
}


//以下、全て独自関数


void repeatCalc(int j,  int degK, String type){
  for(int i = 0; i < j; i++){
    int varI = -90 +(i*degK);
    
    float rad = radians(varI);
    
    calcCoord(i, rad, type);
    
  }
}


void calcCoord(int i, float rad, String type){
  //setupで呼び出される、これから置かれる図形の座標を予め計算して配列に保管する関数。
  
  switch(type){  //文字列で判定
    case "second":
      secCoord[0][i] = radiusSec * cos(rad);
      secCoord[1][i] = radiusSec * sin(rad);
      break;
      
    case "minute":
      minCoord[0][i] = radiusMin * cos(rad);
      minCoord[1][i] = radiusMin * sin(rad);
      break;
      
    case "hour":
      hourCoord[0][i] = radiusHour * cos(rad);
      hourCoord[1][i] = radiusHour * sin(rad);
      break;
      
    case "24/3":
      stringCoord1[0][i] = radiusStr1 * cos(rad);
      stringCoord1[1][i] = radiusStr1 * sin(rad);
      break;
    
    case "60/5":
      stringCoord2[0][i] = radiusStr2 * cos(rad);
      stringCoord2[1][i] = radiusStr2 * sin(rad);
      break;
  }
}


void visiblitySet(){
  repSet(60,second(),"second");
  repSet(60,minute(),"minute");
  repSet(24,hour(),"hour");
}


void repSet(int repeat, int check, String type){
  for(int i = 0; i < repeat; i++){
    if(i <= check){  //秒の図形の可視設定。
      switch(type){
        case "second":
          visSec[i] = true;
          break;
        case "minute":
          visMin[i] = true;
          break;
        case "hour":
          visHour[i] = true;
          break;
      }
    }else{
      switch(type){
        case "second":
          visSec[i] = false;
          break;
        case "minute":
          visMin[i] = false;
          break;
        case "hour":
          visHour[i] = false;
          break;
      }
    }
  }
}


void setEllipse(float x, float y, int dia, boolean filling, boolean visible){  //円を描写を担当。これ一つで正円は全て描写可能。個別の色指定は厳しい設定。
  
  char vis;
  
  if(visible == false){  //ブーリアンをエセ２進数に変換。
    //可視設定がfalseの時。
    vis = 0;
  }else{
    //trueの時。
    vis = 1;
  }
  
  if(filling == false){  //fillするかどうかの引数に対する設定の呼び出し。
    //fillしなくていい時。
    noFill();
    strokeWeight(2);
    stroke(colors[0], colors[1], colors[2], vis);
  }else{
    //fillしたい時。
    fill(colors[0], colors[1], colors[2], vis);
    noStroke();
  }
  ellipseMode(CENTER);
  ellipse(x, y, dia, dia);
}


void setScale(float x, float y, int scaleNumber){
  
  fill(colors[0], colors[1], colors[2],1);
  textAlign(CENTER,CENTER);
  textSize(18);
  text(scaleNumber,x,y-3);
  
}


void secCounter(){
  stroke(colors[0], colors[1]-varI1, colors[2],1);
  noFill();
  
  float shrink = (30/varI1)*4;
  ellipse(0, 0, 150 - shrink, 150 - shrink);
  
  if(varI1 > 30){
    varI1 = 1;
  }else{
    varI1++;
  }
}


void backEllipse(){
  //背景の円の波。
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 20; j++){
      int a = (i * 40) -380;
      int b = (j * 40) -380;
      
      int surp = ((i+j)+second()) % 12;  //12の余りが
      
      if(surp != 0){
        //ある（0以外）時。
        noStroke();
        fill(190,40,10,1);
        ellipse(a,b,41,41);
      }else{
        //ない時。
        noStroke();
        fill(190,30,12,1);
        ellipse(a,b,45,45);
      }
    }
  }
}


/*
参考記事

三角関数を使った円形配置の方法
  https://www.webdelog.info/entry/2016/06/12/arranged-in-the-circumferential-direction.html
  https://r-dimension.xsrv.jp/classes_j/sine_cosine/

*/
