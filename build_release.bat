@echo off
echo Building Palm Restaurant App - Release Version
echo ==============================================

echo.
echo Step 1: Cleaning build directory...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Building release APK...
flutter build apk --release

echo.
echo Build completed!
echo APK location: build\app\outputs\flutter-apk\app-release.apk

pause
