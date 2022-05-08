#include <Arduino.h>
#include <WebSocketsServer.h> //import for websocket
#include <ArduinoJson.h> //data Json
#include "DHT.h" //dht11
#include <FirebaseESP32.h>


#define FIREBASE_HOST "https://esp32-realtime-813e1-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "fp1vJ2wsFBJwjIDW9Q3gRNftTZ4QI6gmtER6VawQ"


#define WIFI_SSID "ADMIN 7060" // Tên wifi của bạn "Adobe Creative Cloud"
#define WIFI_PASSWORD "9953j0W@" // Password wifi của bạn "GeometryNodes"

#include "WebServer.h" 

FirebaseData fbdo;

const char *ssid =  "ESP32";   //Wifi SSID (Name)
const char *pass =  "123123123"; //wifi password

const char *server = "api.thingspeak.com";

const char * writeAPIKey = "ACXEC1HMMBYDSARQ";

WebSocketsServer webSocket = WebSocketsServer(81); //websocket init with port 81

unsigned long t_tick = 0;

StaticJsonDocument<500> TempDoc;

//properties DHT11 & init library dht11
#define DHTPIN 2    //D4,D3,D5    
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
#define ledpin 14

double humi;
double tempC;
int intValue = 0;
void setup() {
  Serial.begin(115200); //serial start
  dht.begin();
  pinMode(ledpin, OUTPUT);
  // set First value
  TempDoc["tempC"] = 0;
  TempDoc["humi"] = 0;

  Serial.println("Connecting to wifi");

  IPAddress apIP(192, 168, 99, 100);   //Static IP for wifi gateway
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  WiFi.softAP(ssid, pass); //turn on WIFI

  WiFi.begin (WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Dang ket noi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println ("");
  Serial.println ("Da ket noi WiFi!");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  webSocket.begin(); //websocket Begin
  webSocket.onEvent(webSocketEvent); //set Event for websocket
  Serial.println("Websocket is started");
}

  String device = "/ESP32_Device";
void loop() {

  webSocket.loop(); //keep this line on loop method
  if (millis() - t_tick > 1000) {
    //Read humi & tempC
    humi = dht.readHumidity();
    tempC = dht.readTemperature();
    if (isnan(tempC) || isnan(humi)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }
    Serial.print("Temperature: ");
    Serial.print(tempC);
    Serial.print("°C Humidity: ");
    Serial.print(humi);
    Serial.println("%");
    dhtEvent();
    t_tick = millis();

    Firebase.setFloat( fbdo, device + "/Temperature/Data", tempC);

    Firebase.setFloat ( fbdo, device + "/Humidity/Data", humi);
    if (Firebase.getInt(fbdo, device + "/Led/status")) {
      if (fbdo.dataType() == "int") {
        intValue = fbdo.intData();
        Serial.println(intValue);
          if(intValue == 1){
            digitalWrite(ledpin, HIGH);
          } 
          else {
          digitalWrite(ledpin, LOW);
          }   
      }
    }
   }


    WiFiClient client;
    const int httpPort = 80;
    if (!client.connect(server, httpPort)){
      return;  
    }

    String url = "/update?key=";

    url += writeAPIKey;
    url += "&field1=";
    url += String(tempC);
    url += "&field2=";
    url += String(humi); 
    url += "\r\n";

    //request to the server
    client.print(String("GET ")+ url + "HTTP/1/1\r\n" + 
                  "Host: " + server + "\r\n" + "Connection: close\r\n\r\n"
    );
    Serial.println("Send to ThingSpeak.\n");
    client.stop();
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  //webscket event method
  String cmd = "";
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.println("Websocket is disconnected");
      break;
    case WStype_CONNECTED: {
        Serial.println("Websocket is connected");
        Serial.println(webSocket.remoteIP(num).toString());
        webSocket.sendTXT(num, "connected");
      }
      break;
    case WStype_TEXT:
      cmd = "";
      for (int i = 0; i < length; i++) {
        cmd = cmd + (char) payload[i];
      } //merging payload to single string
  
      if(cmd == "poweron"){ //when command from app is "poweron"
                digitalWrite(ledpin, HIGH);   //make ledpin output to HIGH  
      }else if(cmd == "poweroff"){
                digitalWrite(ledpin, LOW);    //make ledpin output to LOW on 'pweroff' command.
       }
       webSocket.sendTXT(num, cmd+":success");
      break;
    default:
      break;
  }
}

void dhtEvent() {
  TempDoc["humi"] = humi;
  TempDoc["tempC"] = tempC;
  char msg[256];
  serializeJson(TempDoc, msg);
  webSocket.broadcastTXT(msg);
}
