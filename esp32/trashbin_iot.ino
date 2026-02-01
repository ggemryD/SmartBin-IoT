
// #include <ESP32Servo.h>

// Servo myServo;

// #define SERVO_PIN 12

// void setup() {
//   Serial.begin(115200);

//   myServo.attach(SERVO_PIN);

//   // Start closed
//   myServo.write(0);
//   delay(1000);
// }

// void loop() {
//   // Open to 90 degrees
//   myServo.write(90);
//   Serial.println("Opened to 90°");
//   delay(3000);   // wait 3 seconds

//   // Close back to 0 degrees
//   myServo.write(0);
//   Serial.println("Closed to 0°");
//   delay(3000);   // wait before opening again
// }

// gana nang babaw for test close open sa servo ----------------

// ----------------------

// #include <WiFi.h>
// #include <Firebase_ESP_Client.h>
// #include <ESP32Servo.h>

// // Provide the token generation process info
// #include "addons/TokenHelper.h"
// // Provide the RTDB payload printing info and other helper functions
// #include "addons/RTDBHelper.h"

// // ---- WIFI ----
// #define WIFI_SSID "DELLE"
// #define WIFI_PASSWORD "SanKeKoi22"

// // ---- FIREBASE ----
// #define DATABASE_URL "https://trashhbin-iot-default-rtdb.firebaseio.com"
// #define DATABASE_SECRET "0YgL2Aht8nCfzfn2SPw2eec3Nk0kU56k26Q0ShIA"

// // ---- ULTRASONIC SENSOR ----
// #define TRIG_PIN 5
// #define ECHO_PIN 18

// // ---- SERVO ----
// #define SERVO_PIN 12
// Servo lidServo;

// // ---- SETTINGS ----
// const int FULL_THRESHOLD = 80; // % fill
// int lidState = 0; // 0 = CLOSED, 1 = OPEN

// // ---- FIREBASE OBJECTS ----
// FirebaseData fbData;
// FirebaseAuth auth;
// FirebaseConfig config;

// // ---- FUNCTION TO READ ULTRASONIC ----
// long readUltrasonicCM() {
//   digitalWrite(TRIG_PIN, LOW);
//   delayMicroseconds(2);
//   digitalWrite(TRIG_PIN, HIGH);
//   delayMicroseconds(10);
//   digitalWrite(TRIG_PIN, LOW);

//   long duration = pulseIn(ECHO_PIN, HIGH, 30000);
//   long distance = duration * 0.034 / 2;
//   return distance;
// }

// // ---- FUNCTION TO CALCULATE FILL LEVEL ----
// int calculateFillLevel(long distance) {
//   const int binDepth = 30; // cm, adjust to your bin
//   int fill = ((binDepth - distance) * 100) / binDepth;
//   if (fill > 100) fill = 100;
//   if (fill < 0) fill = 0;
//   return fill;
// }

// // ---- SETUP ----
// void setup() {
//   Serial.begin(115200);

//   // Connect WiFi
//   Serial.print("Connecting to WiFi");
//   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("\n✅ WiFi Connected!");

//   // Configure Firebase
//   config.database_url = DATABASE_URL;
//   config.signer.tokens.legacy_token = DATABASE_SECRET;

//   // Initialize Firebase
//   Firebase.begin(&config, &auth);
//   Firebase.reconnectWiFi(true);
  
//   Serial.println("✅ Firebase Initialized!");

//   // Setup Servo
//   lidServo.attach(SERVO_PIN);
//   lidServo.write(0); // Start CLOSED

//   // Ultrasonic pins
//   pinMode(TRIG_PIN, OUTPUT);
//   pinMode(ECHO_PIN, INPUT);

//   Serial.println("Setup Complete\n");
// }

// // ---- MAIN LOOP ----
// void loop() {
//   // Check if Firebase is ready
//   if (Firebase.ready()) {
//     // 1️⃣ Read ultrasonic sensor
//     long distance = readUltrasonicCM();
//     int fillLevel = calculateFillLevel(distance);
//     Serial.print("Fill level: ");
//     Serial.print(fillLevel);
//     Serial.println("%");

//     // 2️⃣ Write fillLevel to Firebase
//     if (Firebase.RTDB.setInt(&fbData, "/trashbin/fillLevel", fillLevel)) {
//       Serial.println("✅ FillLevel sent to Firebase");
//     } else {
//       Serial.print("❌ Firebase write failed: ");
//       Serial.println(fbData.errorReason());
//     }

//     // 3️⃣ Update status based on threshold
//     if (fillLevel >= FULL_THRESHOLD && lidState == 0) {
//       lidServo.write(0); // CLOSE lid
//       lidState = 0;

//       Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
//       Firebase.RTDB.setString(&fbData, "/trashbin/status", "FULL");
//       Serial.println("🚨 Bin FULL - Lid CLOSED");
//     } else if (fillLevel < FULL_THRESHOLD) {
//       Firebase.RTDB.setString(&fbData, "/trashbin/status", "NOT_FULL");
//     }

//     // 4️⃣ Listen for command from app
//     if (Firebase.RTDB.getString(&fbData, "/trashbin/command")) {
//       String command = fbData.stringData();
//       if (command == "OPEN" && lidState == 0) {
//         lidServo.write(90); // OPEN lid
//         lidState = 1;
//         Firebase.RTDB.setString(&fbData, "/trashbin/lid", "OPEN");
//         Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
//         Serial.println("📢 Command received: OPEN Lid");
//       }
//     } else {
//       Serial.print("❌ Firebase read failed: ");
//       Serial.println(fbData.errorReason());
//     }
//   } else {
//     Serial.println("⏳ Firebase not ready yet...");
//   }

//   delay(1000); // 1-second loop
// }

// gana na ang firebase aning babaw ---------------

// #include <WiFi.h>
// #include <Firebase_ESP_Client.h>
// #include <ESP32Servo.h>

// // Provide the token generation process info
// #include "addons/TokenHelper.h"
// // Provide the RTDB payload printing info and other helper functions
// #include "addons/RTDBHelper.h"

// // ---- WIFI ----
// // #define WIFI_SSID "Vivoy35"
// // #define WIFI_PASSWORD "123456789"

// #define WIFI_SSID "DELLE"
// #define WIFI_PASSWORD "SanKeKoi22"

// // #define WIFI_SSID "GIGA"
// // #define WIFI_PASSWORD "12345678"

// // ---- FIREBASE ----
// #define DATABASE_URL "https://trashhbin-iot-default-rtdb.firebaseio.com"
// #define DATABASE_SECRET "0YgL2Aht8nCfzfn2SPw2eec3Nk0kU56k26Q0ShIA"

// // ---- ULTRASONIC SENSOR ----
// #define TRIG_PIN 5
// #define ECHO_PIN 18

// // ---- SERVO ----
// #define SERVO_PIN 12
// Servo lidServo;

// // ---- SETTINGS ----
// // const int FULL_THRESHOLD = 80; // % fill
// const int FULL_THRESHOLD = 95;
// const int BIN_HEIGHT = 25;     // Total bin height in cm
// // const int SENSOR_TO_FULL = 3;  // Distance from sensor when bin is full (3 inches ≈ 7.62 cm)
// const int SENSOR_TO_FULL = 4;
// int lidState = 0; // 0 = CLOSED, 1 = OPEN

// // ---- FIREBASE OBJECTS ----
// FirebaseData fbData;
// FirebaseAuth auth;
// FirebaseConfig config;

// // ---- FUNCTION TO READ ULTRASONIC ----
// long readUltrasonicCM() {
//   digitalWrite(TRIG_PIN, LOW);
//   delayMicroseconds(2);
//   digitalWrite(TRIG_PIN, HIGH);
//   delayMicroseconds(10);
//   digitalWrite(TRIG_PIN, LOW);

//   long duration = pulseIn(ECHO_PIN, HIGH, 30000);
//   long distance = duration * 0.034 / 2;
//   return distance;
// }

// // ---- FUNCTION TO CALCULATE FILL LEVEL ----
// int calculateFillLevel(long distance) {
//   // When distance = SENSOR_TO_FULL (3 inches ≈ 7.62cm), bin is 100% full
//   // When distance = BIN_HEIGHT (30cm), bin is 0% full
  
//   int fill = ((BIN_HEIGHT - distance) * 100) / (BIN_HEIGHT - SENSOR_TO_FULL);
  
//   if (fill > 100) fill = 100;
//   if (fill < 0) fill = 0;
//   return fill;
// }

// // ---- SETUP ----
// void setup() {
//   Serial.begin(115200);

//   // Connect WiFi
//   Serial.print("Connecting to WiFi");
//   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("\n✅ WiFi Connected!");

//   // Configure Firebase
//   config.database_url = DATABASE_URL;
//   config.signer.tokens.legacy_token = DATABASE_SECRET;

//   // Initialize Firebase
//   Firebase.begin(&config, &auth);
//   Firebase.reconnectWiFi(true);
  
//   Serial.println("✅ Firebase Initialized!");

//   // Initialize Firebase paths
//   if (Firebase.ready()) {
//     Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
//     Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
//     Firebase.RTDB.setString(&fbData, "/trashbin/status", "NOT_FULL");
//     Firebase.RTDB.setInt(&fbData, "/trashbin/fillLevel", 0);
//     Serial.println("✅ Firebase paths initialized");
//   }

//   // Setup Servo
//   lidServo.attach(SERVO_PIN);
//   lidServo.write(0); // Start CLOSED
//   lidState = 0;

//   // Ultrasonic pins
//   pinMode(TRIG_PIN, OUTPUT);
//   pinMode(ECHO_PIN, INPUT);

//   Serial.println("Setup Complete\n");
// }

// // ---- MAIN LOOP ----
// void loop() {
//   // Check if Firebase is ready
//   if (Firebase.ready()) {
//     // 1️⃣ Read ultrasonic sensor
//     long distance = readUltrasonicCM();
//     int fillLevel = calculateFillLevel(distance);
//     Serial.print("Distance: ");
//     Serial.print(distance);
//     Serial.print(" cm | Fill level: ");
//     Serial.print(fillLevel);
//     Serial.println("%");

//     // 2️⃣ Write fillLevel to Firebase
//     if (Firebase.RTDB.setInt(&fbData, "/trashbin/fillLevel", fillLevel)) {
//       Serial.println("✅ FillLevel sent to Firebase");
//     } else {
//       Serial.print("❌ Firebase write failed: ");
//       Serial.println(fbData.errorReason());
//     }

//     // 3️⃣ Update status based on threshold
//     if (fillLevel >= FULL_THRESHOLD) {
//       Firebase.RTDB.setString(&fbData, "/trashbin/status", "FULL");
      
//       // Only close if it was open
//       if (lidState == 1) {
//         lidServo.write(0); // CLOSE lid
//         lidState = 0;
//         Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
//         Serial.println("🚨 Bin FULL - Lid AUTO-CLOSED");
//       }
//     } else {
//       Firebase.RTDB.setString(&fbData, "/trashbin/status", "NOT_FULL");
//     }

//     // 4️⃣ Listen for command from app
//     if (Firebase.RTDB.getString(&fbData, "/trashbin/command")) {
//       String command = fbData.stringData();
      
//       if (command == "OPEN" && lidState == 0) {
//         // lidServo.write(90); // OPEN lid
//         lidServo.write(100); // OPEN lid
//         lidState = 1;
//         Firebase.RTDB.setString(&fbData, "/trashbin/lid", "OPEN");
//         Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
//         Serial.println("📢 Command received: OPEN Lid");
//       } 
//       else if (command == "CLOSE" && lidState == 1) {
//         lidServo.write(0); // CLOSE lid
//         lidState = 0;
//         Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
//         Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
//         Serial.println("📢 Command received: CLOSE Lid");
//       }
//     } else {
//       // Handle path not exist gracefully
//       if (fbData.errorReason() == "path not exist") {
//         Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
//         Serial.println("ℹ️ Command path created");
//       }
//     }
//   } else {
//     Serial.println("⏳ Firebase not ready yet...");
//   }

//   delay(1000); // 1-second loop
// }

// ang babaw mao ni ang last gamit na working na pero di lng dynamic ang configure sa wifi ------------------

#include <WiFi.h>
#include <WebServer.h>
#include <EEPROM.h>
#include <Firebase_ESP_Client.h>
#include <ESP32Servo.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// ---- FIREBASE ----
#define DATABASE_URL "https://trashhbin-iot-default-rtdb.firebaseio.com"
#define DATABASE_SECRET "0YgL2Aht8nCfzfn2SPw2eec3Nk0kU56k26Q0ShIA"

// ---- ULTRASONIC SENSOR ----
#define TRIG_PIN 5
#define ECHO_PIN 18

// ---- SERVO ----
#define SERVO_PIN 12
Servo lidServo;

// ---- SETTINGS ----
const int FULL_THRESHOLD = 95;
const int BIN_HEIGHT = 25;
const int SENSOR_TO_FULL = 4;
int lidState = 0;

// ---- FIREBASE OBJECTS ----
FirebaseData fbData;
FirebaseAuth auth;
FirebaseConfig config;

// ---- WEB SERVER ----
WebServer server(80);

// ---- EEPROM ADDRESSES ----
#define EEPROM_SIZE 512
#define SSID_ADDR 0
#define PASS_ADDR 100
#define CONFIGURED_FLAG_ADDR 200

// ---- WiFi AP SETTINGS ----
const char* ap_ssid = "SmartBin_Setup";
// No password - open network for easy connection

String saved_ssid = "";
String saved_password = "";
bool wifiConfigured = false;

// ---- FUNCTION PROTOTYPES ----
void setupAccessPoint();
void handleRoot();
void handleConfigure();
void saveWiFiCredentials(String ssid, String password);
bool loadWiFiCredentials();
bool connectToWiFi();
long readUltrasonicCM();
int calculateFillLevel(long distance);

// ---- SETUP ----
void setup() {
  Serial.begin(115200);
  delay(1000);

  // Initialize EEPROM
  EEPROM.begin(EEPROM_SIZE);
  
  // Setup Servo
  lidServo.attach(SERVO_PIN);
  lidServo.write(0);
  lidState = 0;

  // Ultrasonic pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  Serial.println("\n\n=========================");
  Serial.println("Smart Trashbin Booting...");
  Serial.println("=========================\n");

  // Try to load saved WiFi credentials
  wifiConfigured = loadWiFiCredentials();

  if (wifiConfigured) {
    Serial.println("✅ WiFi credentials found in memory");
    Serial.print("📶 SSID: ");
    Serial.println(saved_ssid);
    
    if (connectToWiFi()) {
      Serial.println("✅ Connected to WiFi successfully!");
      initializeFirebase();
    } else {
      Serial.println("❌ Failed to connect to saved WiFi");
      Serial.println("🔧 Starting Access Point mode...");
      setupAccessPoint();
    }
  } else {
    Serial.println("⚠️ No WiFi credentials saved");
    Serial.println("🔧 Starting Access Point mode...");
    setupAccessPoint();
  }

  // Always start Access Point in background (dual mode)
  // This allows reconfiguration anytime
  Serial.println("\n🌐 Access Point 'SmartBin_Setup' is always available");
  WiFi.softAP(ap_ssid);
  Serial.print("📱 AP IP Address: ");
  Serial.println(WiFi.softAPIP());

  // Setup web server routes
  server.on("/", handleRoot);
  server.on("/configure", HTTP_POST, handleConfigure);
  server.begin();
  Serial.println("🌐 Web Server started\n");
}

// ---- MAIN LOOP ----
void loop() {
  // Handle web server requests
  server.handleClient();

  // Only run trashbin logic if connected to WiFi and Firebase
  if (WiFi.status() == WL_CONNECTED && Firebase.ready()) {
    // 1️⃣ Read ultrasonic sensor
    long distance = readUltrasonicCM();
    int fillLevel = calculateFillLevel(distance);
    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.print(" cm | Fill level: ");
    Serial.print(fillLevel);
    Serial.println("%");

    // 2️⃣ Write fillLevel to Firebase
    if (Firebase.RTDB.setInt(&fbData, "/trashbin/fillLevel", fillLevel)) {
      Serial.println("✅ FillLevel sent to Firebase");
    } else {
      Serial.print("❌ Firebase write failed: ");
      Serial.println(fbData.errorReason());
    }

    // 3️⃣ Update status based on threshold
    if (fillLevel >= FULL_THRESHOLD) {
      Firebase.RTDB.setString(&fbData, "/trashbin/status", "FULL");
      
      if (lidState == 1) {
        lidServo.write(0);
        lidState = 0;
        Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
        Serial.println("🚨 Bin FULL - Lid AUTO-CLOSED");
      }
    } else {
      Firebase.RTDB.setString(&fbData, "/trashbin/status", "NOT_FULL");
    }

    // 4️⃣ Listen for command from app
    if (Firebase.RTDB.getString(&fbData, "/trashbin/command")) {
      String command = fbData.stringData();
      
      if (command == "OPEN" && lidState == 0) {
        lidServo.write(100);
        lidState = 1;
        Firebase.RTDB.setString(&fbData, "/trashbin/lid", "OPEN");
        Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
        Serial.println("📢 Command: OPEN Lid");
      } 
      else if (command == "CLOSE" && lidState == 1) {
        lidServo.write(0);
        lidState = 0;
        Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
        Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
        Serial.println("📢 Command: CLOSE Lid");
      }
    } else {
      if (fbData.errorReason() == "path not exist") {
        Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
      }
    }

    delay(1000);
  } else {
    // Not connected - just wait
    delay(500);
  }
}

// ---- SETUP ACCESS POINT ----
void setupAccessPoint() {
  WiFi.mode(WIFI_AP_STA); // Both AP and Station mode
  WiFi.softAP(ap_ssid);
  
  Serial.println("\n✅ Access Point Started");
  Serial.print("📶 Network: ");
  Serial.println(ap_ssid);
  Serial.print("📱 IP Address: ");
  Serial.println(WiFi.softAPIP());
  Serial.println("🔓 No password required\n");
}

// ---- WEB SERVER: ROOT PAGE ----
void handleRoot() {
  String html = "<!DOCTYPE html><html><head>";
  html += "<meta name='viewport' content='width=device-width, initial-scale=1'>";
  html += "<style>";
  html += "body { font-family: Arial; margin: 0; padding: 20px; background: #f0f0f0; }";
  html += ".container { max-width: 500px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }";
  html += "h1 { color: #2196F3; text-align: center; }";
  html += "input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }";
  html += "button { width: 100%; padding: 15px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }";
  html += "button:hover { background: #45a049; }";
  html += ".info { background: #e3f2fd; padding: 10px; border-radius: 5px; margin: 15px 0; }";
  html += "</style></head><body>";
  html += "<div class='container'>";
  html += "<h1>🗑️ SmartBin WiFi Setup</h1>";
  html += "<div class='info'>Enter your WiFi credentials to connect SmartBin to your network</div>";
  html += "<form id='wifiForm'>";
  html += "<input type='text' name='ssid' placeholder='WiFi Network Name (SSID)' required>";
  html += "<input type='password' name='password' placeholder='WiFi Password'>";
  html += "<button type='submit'>Configure WiFi</button>";
  html += "</form>";
  html += "<div id='status' style='margin-top: 20px; text-align: center;'></div>";
  html += "<script>";
  html += "document.getElementById('wifiForm').onsubmit = async (e) => {";
  html += "  e.preventDefault();";
  html += "  const formData = new FormData(e.target);";
  html += "  const data = { ssid: formData.get('ssid'), password: formData.get('password') };";
  html += "  document.getElementById('status').innerHTML = '<p style=\"color: blue;\">Configuring...</p>';";
  html += "  try {";
  html += "    const res = await fetch('/configure', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(data) });";
  html += "    const result = await res.json();";
  html += "    document.getElementById('status').innerHTML = '<p style=\"color: green;\">✅ ' + result.message + '</p>';";
  html += "  } catch(err) {";
  html += "    document.getElementById('status').innerHTML = '<p style=\"color: red;\">❌ Configuration failed</p>';";
  html += "  }";
  html += "};";
  html += "</script>";
  html += "</div></body></html>";
  
  server.send(200, "text/html", html);
}

// ---- WEB SERVER: HANDLE CONFIGURE ----
void handleConfigure() {
  if (server.hasArg("plain")) {
    String body = server.arg("plain");
    
    // Parse JSON manually (simple approach)
    int ssidStart = body.indexOf("\"ssid\":\"") + 8;
    int ssidEnd = body.indexOf("\"", ssidStart);
    String ssid = body.substring(ssidStart, ssidEnd);
    
    int passStart = body.indexOf("\"password\":\"") + 12;
    int passEnd = body.indexOf("\"", passStart);
    String password = body.substring(passStart, passEnd);
    
    Serial.println("\n📥 Received WiFi Credentials:");
    Serial.print("SSID: ");
    Serial.println(ssid);
    Serial.print("Password: ");
    Serial.println(password);
    
    // Save to EEPROM
    saveWiFiCredentials(ssid, password);
    
    // Send success response
    String response = "{\"status\":\"success\",\"message\":\"WiFi configured! SmartBin will restart and connect.\"}";
    server.send(200, "application/json", response);
    
    // Restart ESP32 to apply new settings
    delay(1000);
    ESP.restart();
  } else {
    server.send(400, "application/json", "{\"status\":\"error\",\"message\":\"Invalid request\"}");
  }
}

// ---- SAVE WiFi CREDENTIALS TO EEPROM ----
void saveWiFiCredentials(String ssid, String password) {
  // Clear EEPROM
  for (int i = 0; i < EEPROM_SIZE; i++) {
    EEPROM.write(i, 0);
  }
  
  // Write SSID
  for (int i = 0; i < ssid.length(); i++) {
    EEPROM.write(SSID_ADDR + i, ssid[i]);
  }
  
  // Write Password
  for (int i = 0; i < password.length(); i++) {
    EEPROM.write(PASS_ADDR + i, password[i]);
  }
  
  // Set configured flag
  EEPROM.write(CONFIGURED_FLAG_ADDR, 1);
  
  EEPROM.commit();
  Serial.println("✅ WiFi credentials saved to EEPROM");
}

// ---- LOAD WiFi CREDENTIALS FROM EEPROM ----
bool loadWiFiCredentials() {
  // Check if configured
  if (EEPROM.read(CONFIGURED_FLAG_ADDR) != 1) {
    return false;
  }
  
  // Read SSID
  saved_ssid = "";
  for (int i = 0; i < 32; i++) {
    char c = EEPROM.read(SSID_ADDR + i);
    if (c == 0) break;
    saved_ssid += c;
  }
  
  // Read Password
  saved_password = "";
  for (int i = 0; i < 64; i++) {
    char c = EEPROM.read(PASS_ADDR + i);
    if (c == 0) break;
    saved_password += c;
  }
  
  return saved_ssid.length() > 0;
}

// ---- CONNECT TO WiFi ----
bool connectToWiFi() {
  Serial.print("🔄 Connecting to WiFi: ");
  Serial.println(saved_ssid);
  
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(saved_ssid.c_str(), saved_password.c_str());
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n✅ WiFi Connected!");
    Serial.print("📡 IP Address: ");
    Serial.println(WiFi.localIP());
    return true;
  } else {
    Serial.println("\n❌ WiFi Connection Failed");
    return false;
  }
}

// ---- INITIALIZE FIREBASE ----
void initializeFirebase() {
  config.database_url = DATABASE_URL;
  config.signer.tokens.legacy_token = DATABASE_SECRET;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  
  Serial.println("✅ Firebase Initialized!");
  
  if (Firebase.ready()) {
    Firebase.RTDB.setString(&fbData, "/trashbin/command", "NONE");
    Firebase.RTDB.setString(&fbData, "/trashbin/lid", "CLOSED");
    Firebase.RTDB.setString(&fbData, "/trashbin/status", "NOT_FULL");
    Firebase.RTDB.setInt(&fbData, "/trashbin/fillLevel", 0);
    Serial.println("✅ Firebase paths initialized\n");
  }
}

// ---- READ ULTRASONIC ----
long readUltrasonicCM() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);
  long distance = duration * 0.034 / 2;
  return distance;
}

// ---- CALCULATE FILL LEVEL ----
int calculateFillLevel(long distance) {
  int fill = ((BIN_HEIGHT - distance) * 100) / (BIN_HEIGHT - SENSOR_TO_FULL);
  
  if (fill > 100) fill = 100;
  if (fill < 0) fill = 0;
  return fill;
}

