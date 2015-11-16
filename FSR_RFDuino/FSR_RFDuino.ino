#include <RFduinoBLE.h>

/* FSR testing sketch. 
 
Connect one end of FSR to power, the other end to Analog 0.
Then connect one end of a 10K resistor from Analog 0 to ground 
 
For more information see www.ladyada.net/learn/sensors/fsr.html */
 
int fsr1Pin = 2;     // the FSR and 10K pulldown are connected to a0
int fsr2Pin = 3;     // the FSR and 10K pulldown are connected to a0
int fsr3Pin = 4;     // the FSR and 10K pulldown are connected to a0
int fsr4Pin = 5;     // the FSR and 10K pulldown are connected to a0
int fsr5Pin = 6;     // the FSR and 10K pulldown are connected to a0
//int fsr6Pin = 5;     // the FSR and 10K pulldown are connected to a0
//int fsr7Pin = 6;     // the FSR and 10K pulldown are connected to a0
//int fsr8Pin = 7;     // the FSR and 10K pulldown are connected to a0
//int fsr9Pin = 8;     // the FSR and 10K pulldown are connected to a0
//int fsr10Pin = 9;     // the FSR and 10K pulldown are connected to a0
int fsr1Reading;     // the analog reading from the FSR resistor divider
int fsr2Reading;     // the analog reading from the FSR resistor divider
int fsr3Reading;     // the analog reading from the FSR resistor divider
int fsr4Reading;     // the analog reading from the FSR resistor divider
int fsr5Reading;     // the analog reading from the FSR resistor divider
//int fsr6Reading;     // the analog reading from the FSR resistor divider
//int fsr7Reading;     // the analog reading from the FSR resistor divider
//int fsr8Reading;     // the analog reading from the FSR resistor divider
//int fsr9Reading;     // the analog reading from the FSR resistor divider
//int fsr10Reading;     // the analog reading from the FSR resistor divider

void setup(void) {
  Serial.begin(4800);   // We'll send debugging information via the Serial monitor
//  for (int i = 0; i < 5; i++) {
//    pinMode(i, INPUT);  
//  }
  pinMode(fsr1Pin, INPUT);
  pinMode(fsr2Pin, INPUT);
  pinMode(fsr3Pin, INPUT);
  pinMode(fsr4Pin, INPUT);
  pinMode(fsr5Pin, INPUT);

  RFduinoBLE.advertisementData = "force";
  RFduinoBLE.advertisementInterval = 1000;
  // start the BLE stack
  RFduinoBLE.begin();
}
 
void loop(void) {
  fsr1Reading = analogRead(fsr1Pin);
  fsr2Reading = analogRead(fsr2Pin);
  fsr3Reading = analogRead(fsr3Pin);
  fsr4Reading = analogRead(fsr4Pin);
  fsr5Reading = analogRead(fsr5Pin);
  if (fsr1Reading < 100) {
    fsr1Reading = 0;
  }
  if (fsr2Reading < 100) {
    fsr2Reading = 0;
  }
  if (fsr3Reading < 100) {
    fsr3Reading = 0;
  }
  if (fsr4Reading < 100) {
    fsr4Reading = 0;
  }
  if (fsr5Reading < 100) {
    fsr5Reading = 0;
  }
  Serial.print("fsr1Reading = ");
  Serial.println(fsr1Reading);
  Serial.print("fsr2Reading = ");
  Serial.println(fsr2Reading);
  Serial.print("fsr3Reading = ");
  Serial.println(fsr3Reading);
  Serial.print("fsr4Reading = ");
  Serial.println(fsr4Reading);
  Serial.print("fsr5Reading = ");
  Serial.println(fsr5Reading);
  Serial.println("--------------------");
  int vals[5];
  vals[0] = fsr1Reading/100;
  vals[1] = fsr2Reading/100;
  vals[2] = fsr3Reading/100;
  vals[3] = fsr4Reading/100;
  vals[4] = fsr5Reading/100;

  char buf[20];

  for (int _i=0; _i<5; _i++)
      memcpy(&buf[_i*sizeof(int)], &vals[_i], sizeof(int));

  while (! RFduinoBLE.send((const char*)buf, 20)) 
      ;
  delay(1000);
}
