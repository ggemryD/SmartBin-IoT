# 🗑️ SmartBin IoT

A modern IoT-powered smart trash bin system with real-time monitoring, automatic lid control, and dynamic WiFi configuration. Built with Flutter and ESP32.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![ESP32](https://img.shields.io/badge/ESP32-000000?style=for-the-badge&logo=espressif&logoColor=white)

## ✨ Features

### 📱 Mobile App (Flutter)
- **Real-time Monitoring** - Track fill level, lid status, and bin status
- **Remote Lid Control** - Open/Close lid remotely via app
- **WiFi Configuration** - Easy setup through modern UI
- **Push Notifications** - Get notified when bin is full (Firebase Cloud Messaging)
- **Beautiful UI** - Modern, gradient-based design with smooth animations
- **Dark Mode Support** - Automatically adapts to system theme

### 🔧 Hardware (ESP32)
- **Ultrasonic Sensor** - Measures trash fill level accurately
- **Servo Motor** - Automatic lid control
- **WiFi Connectivity** - Connects to any WiFi network
- **Dynamic Configuration** - Change WiFi credentials without re-flashing
- **Access Point Mode** - Built-in WiFi setup portal (SmartBin_Setup)
- **EEPROM Storage** - Saves WiFi credentials permanently
- **Firebase Integration** - Real-time database sync
- **Auto-Close** - Lid automatically closes when bin is full

## 🛠️ Hardware Requirements

### Components
- **ESP32 Development Board**
- **HC-SR04 Ultrasonic Sensor**
- **SG90 Servo Motor** (or similar)
- **Jumper Wires**
- **Power Supply** (5V for ESP32 and Servo)

### Wiring Diagram

```
ESP32          Component
-----          ---------
GPIO 5    -->  Ultrasonic TRIG
GPIO 18   -->  Ultrasonic ECHO
GPIO 12   -->  Servo Signal
GND       -->  GND (Ultrasonic + Servo)
5V        -->  VCC (Ultrasonic + Servo)
```

## 📲 Software Requirements

### Mobile App
- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (2.17 or higher)
- **Android Studio** or **VS Code**
- **Firebase Project** with Realtime Database enabled

### ESP32 Firmware
- **Arduino IDE** (1.8.19 or higher) or **PlatformIO**
- **ESP32 Board Package**

### Required Arduino Libraries
```cpp
- WiFi.h (built-in)
- WebServer.h (built-in)
- EEPROM.h (built-in)
- Firebase_ESP_Client.h (install via Library Manager)
- ESP32Servo.h (install via Library Manager)
```

## 🚀 Installation

### 1. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Realtime Database**
3. Get your **Database URL** and **Database Secret**
4. Set up **Firebase Cloud Messaging** for notifications
5. Download `google-services.json` (Android) and add to Flutter project

### 2. ESP32 Setup

1. **Install Arduino Libraries**
   - Open Arduino IDE → Tools → Manage Libraries
   - Install: `Firebase ESP Client`, `ESP32Servo`

2. **Configure Firebase Credentials**
   ```cpp
   #define DATABASE_URL "https://your-project.firebaseio.com"
   #define DATABASE_SECRET "your-database-secret"
   ```

3. **Upload Code to ESP32**
   - Open `esp32_smartbin.ino`
   - Select Board: `ESP32 Dev Module`
   - Upload code

4. **First-Time WiFi Configuration**
   - ESP32 creates WiFi network: **SmartBin_Setup** (no password)
   - Connect to it from your phone
   - Open browser: `http://192.168.4.1`
   - Enter your WiFi credentials
   - ESP32 will restart and connect to your WiFi

### 3. Flutter App Setup

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   - Place `google-services.json` in `android/app/`
   - Update `android/app/build.gradle` with Firebase dependencies

3. **Run the App**
   ```bash
   flutter run
   ```

## 📖 Usage

### Initial Setup
1. Power on the SmartBin ESP32
2. Connect your phone to **SmartBin_Setup** WiFi network
3. Open the Flutter app
4. Tap the WiFi icon (⚙️) in the top-right corner
5. Enter your home WiFi credentials
6. Tap "Configure WiFi"
7. SmartBin will connect to your WiFi automatically

### Daily Use
- **Monitor Fill Level** - Check real-time trash level on dashboard
- **Control Lid** - Tap "Open Lid" or "Close Lid" buttons
- **Notifications** - Receive alerts when bin is full
- **Auto-Close** - Lid closes automatically at 95% capacity

### Reconfiguring WiFi
- SmartBin_Setup network is **always available**
- Connect anytime to change WiFi settings
- No need to re-flash firmware

## 🏗️ Project Structure

```
smartbin-iot/
├── lib/
│   ├── main.dart              # App entry point
│   ├── dashboard.dart         # Main dashboard screen
│   └── wificonfig.dart        # WiFi configuration page
├── android/                   # Android configuration
├── ios/                       # iOS configuration
├── esp32/
│   └── smartbin.ino           # ESP32 firmware
└── README.md
```

## 🔧 Configuration

### ESP32 Settings
```cpp
const int FULL_THRESHOLD = 95;     // Bin full at 95%
const int BIN_HEIGHT = 25;         // Bin height in cm
const int SENSOR_TO_FULL = 4;      // Distance when full (cm)
```

### Firebase Database Structure
```json
{
  "trashbin": {
    "fillLevel": 45,
    "status": "NOT_FULL",
    "lid": "CLOSED",
    "command": "NONE"
  }
}
```

## 🎨 Features Showcase

### Dashboard
- Real-time fill level with color-coded progress bar
- Animated status cards
- Pulsing icon when bin is full
- Gradient UI design

### WiFi Configuration
- Modern step-by-step interface
- Live status updates
- Password visibility toggle
- Success confirmation dialogs

## 🐛 Troubleshooting

### ESP32 Won't Connect to WiFi
- Check SSID and password (case-sensitive)
- Ensure WiFi is 2.4GHz (ESP32 doesn't support 5GHz)
- Connect to SmartBin_Setup and reconfigure

### App Can't Connect to Firebase
- Verify `google-services.json` is in correct location
- Check Firebase Database URL in ESP32 code
- Ensure Realtime Database is enabled

### Lid Not Opening/Closing
- Check servo wiring (GPIO 12)
- Verify servo power supply (5V)
- Test servo angle values (0° and 100°)

### Fill Level Inaccurate
- Adjust `BIN_HEIGHT` and `SENSOR_TO_FULL` values
- Clean ultrasonic sensor
- Check sensor wiring (TRIG: GPIO 5, ECHO: GPIO 18)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Gemry Delle Taparan**
- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Firebase for real-time database
- Flutter team for amazing framework
- ESP32 community for excellent libraries
- Ultrasonic sensor tutorials and resources

## 📞 Support

For support, please open an issue in the GitHub repository or contact [gemrydelle@gmail.com](mailto:gemrydelle@gmail.com)

---

⭐ **Star this repo** if you found it helpful!

🐛 **Found a bug?** Open an issue!

💡 **Have an idea?** Create a pull request!
