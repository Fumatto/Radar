#include <Stepper.h>

const int stepsPerRevolution = 2048;

//Inicializa a biblioteca utilizando as portas 12, 13, 25, 27 para ligacao ao motor
Stepper myStepper(stepsPerRevolution, 25, 12, 27, 13);

// Definicao dos pinos de trigger e eccho do sensor
#define trigPin 34
#define echoPin 32

// Variaveis para o valor da duracao e distancia
long duration;
int distance;

void setup() {
  pinMode(trigPin, OUTPUT); // Seta o pino do trigger como saida
  pinMode(echoPin, INPUT);  // Seta o pino do echo como entrada
  myStepper.setSpeed(3);
  Serial.begin(115200);
}

void loop() {
  for (int i = 0; i <= 360; i++) {
    /*
     * 2048 / 360 = 5.68888...
     */
    myStepper.step(-5);
    if (i % 10 == 0 ) {
      myStepper.step(-6);
    }
    if (i % 100 == 0) {
      myStepper.step(-9);
    }
    delay(30);
    distance = calculateDistance(); // Chama a funcao que calcula a distancia medida pelo sensor de cada grau

    Serial.print("Grau e Distancia:"); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
    Serial.print(i); // Envia o grau para a porta serial
    Serial.print(","); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
    Serial.print(distance); // Envia a distancia para a porta serial
    Serial.println("."); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
  }
  for (int i = 360; i > 0; i--) {
    myStepper.step(5);

    if (i % 10 == 0 ) {
      myStepper.step(6);
    }
    if (i % 100 == 0) {
      myStepper.step(9);
    }
    delay(30);
    distance = calculateDistance();// Chama a funcao que calcula a distancia medida pelo sensor de cada grau

    Serial.print("Grau e Distancia:"); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
    Serial.print(i); //  Envia o grau para a porta serial
    Serial.print(","); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
    Serial.print(distance); // Envia a distancia para a porta serial
    Serial.println("."); // Envia um caracter para indexacao do IDE - Processing para um proximo valor
  }
}
// Funcao para calcular a distancia
int calculateDistance() {

  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Seta o pino Trigger para alto por 10 microsegundos
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); // Le o pino Eccho, retorna a onda sonora em microsegundos
  distance = duration * 0.034 / 2;
  return distance;
}
