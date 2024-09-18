int value;

void setup() {Serial.begin(9600);}

void loop() {
value = analogRead(0);
Serial.println(value);
Serial.print('a');
delay(1);
}