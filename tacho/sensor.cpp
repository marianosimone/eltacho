#include <NewPing.h>
// Proyecto: Tacho inteligente #BAHackaton 2013
// Integracion Arduino-Python-webservice
// By marcelo dot martinovic at gmail dot com
#
#
#define TRIGGER_PIN  12  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     11  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 2000 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
int pinBuzzer = 9;
int pinLed = 13;
int estado = 0;
int media = 0;
  int m1 = 0;
  int m2 = 0;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup() {
  Serial.begin(9600); // Open serial monitor at 115200 baud to see ping results.
  delayMicroseconds(1000);
  pinMode(pinBuzzer, OUTPUT);
  pinMode(pinLed, OUTPUT);
  digitalWrite(pinBuzzer, true);
  delay(100);
  digitalWrite(pinBuzzer, false);
  delay(100);
  delay(3000);
  media = sonar.ping();
}

void loop() {
  delay(50);                      // Wait 50ms between pings (about 20 pings/sec). 29ms should be the shortest delay between pings.
  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
  unsigned int dist = uS / US_ROUNDTRIP_CM;
  m1 = media - 500;
  m2 = media + 500;
  if (m1 > uS or m2 < uS){
        Serial.println(dist);
        digitalWrite(pinLed, true);
        digitalWrite(pinBuzzer, true);
        delay(200);
        digitalWrite(pinLed, false);
        digitalWrite(pinBuzzer, false);
        media = uS;
        estado = 1;
        delay(5000);
  }

  if (uS > 5800) {
      estado = 0;
  }
  
}
