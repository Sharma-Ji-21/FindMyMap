# FindMyMap 🗺️

A Flutter application that integrates Google Maps with real-time location services, route planning, and navigation features. Built with clean architecture and modern Flutter practices.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Maps](https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)

## ✨ Features

- 📍 **Real-time Location Tracking** - Get your current location with GPS precision  
- 🗺️ **Interactive Google Maps** - Smooth map interactions with custom markers  
- 🛣️ **Route Planning** - Calculate optimal routes between two points  
- ⏱️ **Distance & Duration** - Real-time distance and travel time calculations  
- 📌 **Custom Markers** - Long-press to add origin and destination markers  
- 🎯 **Camera Controls** - Smooth camera animations to focus on locations  
- 🧭 **Navigation Ready** - Polyline routes with turn-by-turn directions

---

> ⚠️ **Important Note**  
> This application is currently **not fully functional** due to a recent change in Google Cloud's billing policy.  
> The **Directions API** now **requires an active billing account** to function properly, even for development purposes.  
> As a result, features like **route calculation and navigation** may not work unless billing is enabled in your Google Cloud Console.  
>
> 💳 If you're a student, you can explore the [Google Cloud Student Credits](https://cloud.google.com/free/docs/student-credits) program to get free access.

---

## 📱 Screenshots

| 🗺️ Map View | 🧭 Route Planning | 📍 Location Tracking |
|-------------|------------------|-----------------------|
| <img src="https://github.com/user-attachments/assets/e6104cd7-1edb-4ce0-9c18-35b6884ea2b1" width="250" /> | <img src="https://github.com/user-attachments/assets/6999c7d0-d706-481c-be25-a44400da7ff7" width="250" /> | <img src="https://github.com/user-attachments/assets/b8a3a80d-56cb-4aa4-9286-13c4e1788859" width="250" /> |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Google Maps API Key
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/findmymap.git
   cd findmymap
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Google Maps API**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Maps SDK for Android/iOS and Directions API
   - Create an API key
   - Create a `.env.dart` file in the `lib` directory:
   ```dart
   const String googleAPIKey = 'YOUR_API_KEY_HERE';
   ```

4. **Configure platform-specific settings**

   **For Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_API_KEY_HERE"/>
   ```

   **For iOS** (`ios/Runner/AppDelegate.swift`):
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── map_screen.dart          # Main map interface
├── direction_model.dart     # Data model for directions
├── direction_repo.dart      # API repository for Google Directions
└── .env.dart               # Environment variables (API keys)
```

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  flutter_polyline_points: ^1.0.0
  dio: ^5.3.2
```

## 📖 Usage

### Basic Usage

1. **Grant Location Permission**: The app will request location permissions on first launch
2. **View Current Location**: Tap the floating action button to center on your location
3. **Add Origin**: Long-press anywhere on the map to set the origin point
4. **Add Destination**: Long-press again to set the destination and calculate route
5. **View Route Info**: Distance and duration appear at the top of the screen
6. **Navigate Between Points**: Use the "Origin" and "Destination" buttons in the app bar

### Code Examples

**Getting Directions**:
```dart
final directions = await DirectionRepo().getDirection(
  origin: LatLng(28.613939, 77.209023),
  destination: LatLng(28.644800, 77.216721),
);
```

**Adding Custom Markers**:
```dart
Marker(
  markerId: const MarkerId('origin'),
  infoWindow: const InfoWindow(title: 'Origin'),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  position: latLng,
)
```

## 🔑 API Configuration

This project uses the following Google APIs:
- **Maps SDK for Android/iOS**: For map display
- **Directions API**: For route calculation
- **Geocoding API**: For address resolution (optional)

Make sure to enable these APIs in your Google Cloud Console and set up billing if required.

## 🛠️ Customization

### Changing Map Styles
```dart
GoogleMap(
  mapType: MapType.satellite, // or hybrid, terrain
  // ... other properties
)
```

### Custom Marker Icons
```dart
BitmapDescriptor.fromAssetImage(
  ImageConfiguration(size: Size(48, 48)),
  'assets/custom_marker.png',
)
```

### Route Polyline Styling
```dart
Polyline(
  polylineId: const PolylineId('route'),
  color: Colors.blue,
  width: 8,
  patterns: [PatternItem.dash(20), PatternItem.gap(10)],
)
```

---

⭐ **Star this repository if you found it helpful!**

Made with ❤️ by [Your Name]
