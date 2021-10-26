// Importa a biblioteca para a comunicacao serial
import processing.serial.*; 
// Importa a biblioteca para a leitura da comunicacao serial
import java.awt.event.KeyEvent; 
import java.io.IOException;

Serial myPort; // define o objeto serial
// define as variaveis
String angle=" ";
String distance=" ";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;

void setup() {
  
 size (1366, 768); // Resolucao da tela
 smooth();
 // Inicia a comunicacao serial
 myPort = new Serial(this,"COM3", 115200); 
 // Le a informacao da porta serial ate o caracter ".", ou seja: angulo, distancia
 myPort.bufferUntil('.'); 
 orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  fill(98,245,31); //Cor pra preencher as formas
  textFont(orcFont);
  // Simula o desfoque do movimento e o movimento lento da linha
  noStroke();
  fill(0,4); //Cor pra preencher as formas 
  rect(0, 0, width, height); //retangulo da tela
  
  fill(98,245,31); // Cor verde
  // Chama a funcao para desenhar o radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

// Inicia a comunicacao serial
void serialEvent (Serial myPort) { 
  // Le os dados ate o caracter '.' e ponha na variavel do tipo String "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  // acha o caracter '*' e coloca na variavel "index1"
  index2 = data.indexOf(":");
  // acha o caracter ',' e coloca na variavel "index1"
  index1 = data.indexOf(","); 
  // Le os dados desde a posicao "0" ate a posicao da variavel index1, o valor do angulo no caso
  angle= data.substring(index2+1, index1); 
  // Le os dados desde a posicao "index1" ate a posicao da variavel que e o valor da distancia
  distance= data.substring(index1+1, data.length()); 
  
  // Converte o tipo String para Int
  iAngle = int(angle);
  iDistance = int(distance);

  
}
  // Funcao que desenha o radar
void drawRadar() {
  pushMatrix();
  translate(width/2,height/2); // Move para outra posicao
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  
  // Desenha as linhas dos arcos
  
  arc(0,0,(width*0.20),(width*0.20),0,TWO_PI);
  arc(0,0,(width*0.40),(width*0.40),0,TWO_PI);
  arc(0,0,(width*0.60),(width*0.60),0,TWO_PI);
  arc(0,0,(width*0.80),(width*0.80),0,TWO_PI);
  arc(0,0,(width),(width),0,TWO_PI);
  
  // Desenha as linhas dos angulos
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line(0,0,(-width/2)*cos(radians(180)),(-width/2)*sin(radians(180)));
  line(0,0,(-width/2)*cos(radians(210)),(-width/2)*sin(radians(210)));
  line(0,0,(-width/2)*cos(radians(240)),(-width/2)*sin(radians(240)));
  line(0,0,(-width/2)*cos(radians(270)),(-width/2)*sin(radians(270)));
  line(0,0,(-width/2)*cos(radians(300)),(-width/2)*sin(radians(300)));
  line(0,0,(-width/2)*cos(radians(330)),(-width/2)*sin(radians(330)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}
  // Desenha o objeto na tela
void drawObject() {
  pushMatrix();
  translate(width/2,height/2); // Move as coordenadas iniciais para outro lugar
  strokeWeight(9);
  stroke(255,10,10); // Cor vermelho
  
  pixsDistance = ((iDistance*height*0.1)/10); //37.795275591
 
  
  // Limita a distancia em 50 centimentro
  if(iDistance<50){
  // Desenha o objeto conforme a distancia e o angulo
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(width/2,height/2); // Move as coordenadas iniciais para outro lugar 0.505
  line(0,0,(height-height*0.505)*cos(radians(iAngle)),-(height-height*0.505)*sin(radians(iAngle))); // Desenha a linha conforme o angulo e a distancia
 
  popMatrix();
}

void drawText() { // Desenha o texto na tela
  
  pushMatrix();
  if(iDistance>50) {
  noObject = "Fora";
  }
  else {
  noObject = "Dentro";
  }
  fill(0,0,0);
  noStroke();
  rect(0, 0, width*0.28, height*0.13);
  fill(98,245,31);
  textSize(10);
  text("10cm",width-width*0.45,height*0.49);
  text("20cm",width-width*0.35,height*0.49);
  text("30cm",width-width*0.25,height*0.49);
  text("40cm",width-width*0.15,height*0.49);
  text("50cm",width-width*0.05,height*0.49);
  fill(255,255,255);
  textSize(16);
  // 1/25=0.04
  text("Medições ", width*0.01, height*0.03);
  textSize(14);
  text("Alcance: " + noObject, width*0.01, height*0.06);
  text("Ângulo: " + iAngle +" °", width*0.01, height*0.09);
  text("Distância: ", width*0.01, height*0.12);
  
  if(iDistance<50) {
  text("        " + iDistance +" cm",  width*0.05, height*0.12);
  }
  else{
  text("        > 50 cm",  width*0.05, height*0.12);
  }
  textSize(10);
  popMatrix(); 
}
