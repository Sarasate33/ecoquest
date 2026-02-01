## Getting Started

Ecoquest is a cross-device application providing interactive guided tours.

# Set up

## Install VSCode

1. Install git
2. install VSCode

## Install Flutter

1. Open VSCode
2. Add Flutter Extension (https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
3. Open command palette, type flutter
4. Select Flutter: New Project
5. Select Download SDK
6. Choose where you want to install it
7. Click Clone Flutter (may take a few minutes)
8. Click Add SDK to PATH
9. May display Google Analytics notice: click ok if you agree
10. Close and reopen terminals
11. run flutter doctor to verify installation

## Running

12. Type flutter run in terminal
13. Select an emulator (Chrome or whatever is available)

*Note: Question function will not work as you will have no BLE Beacon to trigger it

*Note: for any troubles visit: https://docs.flutter.dev/install/quick

##Sources:
### Code:
Lookup source for flutter functionality/how we learned flutter:   https://www.youtube.com/watch?v=3kaGC_DrUnw
Quiz Functionality:   https://www.youtube.com/watch?v=VEbNXOe2O04
theme.dart:   https://www.christianfindlay.com/blog/flutter-mastering-material-design3
              https://docs.flutter.dev/cookbook/design/themes
AI Source:    https://claude.ai/new
              used to generate bluetooth permissions in ios/info.plist and Android/app/src/AndroidManifest
              used to build beacon_service.dart

### BLE Beacon
Hardware doc for BLE beacon: https://docs.nordicsemi.com/bundle/nan_36/resource/nan_36.pdf

### Images:
tour_krugpark.jpg: Pixabay (uploaded by: @thomashendele), https://pixabay.com/photos/forest-hiking-trees-path-trail-682003/ , accessed 16.12.2025.
tour_neustadt.jpg: Pixabay (uploaded by: @Pixel-Sepp), https://pixabay.com/photos/waldkirch-of-city-at-night-230711/, accessed 16.12.2025.
tour_thb.jpg: THB/Oliver Karaschewski, https://jobs.b-ite.com/api/v1/assets/0d30fb89-322e-494b-98df-95eea33759e7.jpeg, accessed 28.01.2026.

### Icons
Google Material Symbols, https://fonts.google.com/icons, accessed 16.12.2025.

### Fonts
Inter, Google Fonts, https://fonts.google.com/specimen/Inter?query=inter, accessed 16.12.2025
Merriweather, Google Fonts, https://fonts.google.com/specimen/Merriweather, accessed 16.12.2025
 
