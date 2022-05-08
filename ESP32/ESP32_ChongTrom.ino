#include <FirebaseESP32.h>    
#include <Wifi.h>  
#define FIREBASE_HOST "https://esp32-realtime-813e1-default-rtdb.firebaseio.com/"              
#define FIREBASE_AUTH "fp1vJ2wsFBJwjIDW9Q3gRNftTZ4QI6gmtER6VawQ"  

#define trigPin 2 //d7
#define echoPin 14 //d6

char* ssid = "ADMIN 7060";
char* password = "9953j0W@";

long int data;
long duration;
long inches;

FirebaseData fbdo;
String device = "/ESP32_Device";

void setup() {
  pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
 WiFi.begin(ssid,password);
  Serial.begin(115200);
  while(WiFi.status()!=WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }
  Serial.println("");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
   Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
   Firebase.setString( fbdo, device + "/notification/status", "no");    

}

void loop() {
  visitoralert();

}

void visitoralert(){
  digitalWrite(trigPin, LOW);
 delayMicroseconds(1);
  digitalWrite(trigPin, HIGH);
 delayMicroseconds(10);
 digitalWrite(trigPin, LOW);
 pinMode(echoPin, INPUT);
 duration = pulseIn(echoPin, HIGH);
 inches = (duration / 2) / 74;
 
  if (inches < 8) {
    Firebase.setString(fbdo, device + "/notification/status", "yes"); 
    Serial.println("Warning!");
    delay(2000);
 
  }
  else{
    Firebase.setString(fbdo, device + "/notification/status", "no"); 
  }
}
