# RoadSafe AI

RoadSafe AI - Pothole and Blind Spot Detection System.

## Android setup

The app requires a Google Maps Android API key. Add this line to your local
`android/gradle.properties` file (do not commit the key):

```properties
MAPS_API_KEY=your_key
```

For a Play Store release, create `android/key.properties` locally with these
fields and keep it out of source control:

```properties
storeFile=path/to/upload-keystore.jks
storePassword=...
keyAlias=...
keyPassword=...
```

Without `key.properties`, local release builds use the debug signing key only
as a development fallback.

Configure Firebase for Android by adding the project-generated
`android/app/google-services.json` and enabling Email/Password sign-in in the
Firebase console. The TFLite models used at runtime are stored in `models/`.

The training datasets are not required to run the app. Precision, recall, F1,
and mAP require the complete labeled datasets and original evaluation output.

## Getting Started

This project is a Flutter application for detecting potholes and blind spots using AI.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
