<div style="background-color: #215294; color: white; text-align: center; padding: 20px;">
    <h1>Dashboard Page Walkthrough</h1>
</div>

---
### This guide create a Dashboard Page, connect it to Firebase and Google Maps for Data, and deploy to Firebase Hosting.
---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [1. Preparation and Setup](#1-preparation-and-setup)
  - [1.1 Package dependencies in pubspec.yaml](#11-package-dependencies-in-pubspecyaml)
  - [1.2 Firebase project setup](#12-firebase-project-setup)
    - [Creating Firebase project](#creating-firebase-project)
    - [Adding flutter app](#adding-flutter-app)
  - [1.3 Google Maps setup](#13-google-maps-setup)
- [2. Run and Deploy WebApp](#2-run-and-deploy-webapp)
  - [2.1 Copy the Code](#21-copy-the-code)
  - [2.2 Run the App](#22-run-the-app)
  - [2.3 Populate Data in Firestore](#23-populate-data-in-firestore)
  - [2.4 Initialize Firebase Hosting](#24-initialize-firebase-hosting)
  - [2.9 Deploy to Production](#29-deploy-to-production)

---

## 1. Preparation and Setup

### 1.1 Package dependencies in pubspec.yaml

To use internationalization and date formatting, add the `intl` package to your `pubspec.yaml` file. Save the file to apply the changes.

```yaml
dependencies:
    intl: ^0.20.1
```

### 1.2 Firebase project setup

#### Creating Firebase project
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click on "Add project" and follow the steps to create a new Firebase project.
3. From the left panel, select `Build` and then select `Firestore Database`
4. Click on `Create database`
5. remain `nam5` as location and click next
6. select `Start in test mode` and click `Create`
    - Test mode will enable you to write and read from your database without performing authentication for 30 days.

#### Adding flutter app
Below is the guide that is useful for workshop. Follow [Firebase x Flutter Offical Guideline](https://firebase.google.com/docs/flutter/setup) as your reference in the future.
1. Open a New Terminal from the menu of IDX on top left.
   
2. Login to Firebase account:
   1. Run the following command: `firebase login`
   2. select `no` for usage and reporting
   3. There will be a URL and a code given to you in terminal.
   4. Visit the URL given to you and login with your Google account.
   5. confirm the code shown is same as your terminal.
   6. copy the given code in the browser and paste in your terminal.
   
3. Register your app with Firebase:
   1. Run the following command: `dart pub global activate flutterfire_cli`
   2. Run the following command: `flutterfire configure`
   3. Select your project
   4. Use space on your keyboard to select `android` and `web` only.
   5. For android application id, write `com.example.app`
   
- After registering your app, you may have an error in your `firebase_options.dart`. ignore it as it is asking for packages. follow to next step to solve it. 

4. Add required packages to your app:
   1. Run the following command: `flutter pub add firebase_core cloud_firestore`
   2. Run the following command: `flutterfire configure` and select yes

5. Add the Firebase initialization to `main.dart`. Replace your `main.dart` with below:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:firebase_core/firebase_core.dart';
    import 'firebase_options.dart';
    import 'login.dart';

    Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        );
    }
    }
    ```

### 1.3 Google Maps setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/) and Create a new project.
2. Add the Google Maps package to your `pubspec.yaml`:
    ```yaml
    dependencies:
    flutter:
        sdk: flutter

    cupertino_icons: ^1.0.8
    intl: ^0.20.1
    firebase_core: ^3.9.0
    cloud_firestore: ^5.6.0
    google_maps_flutter: ^2.10.0
    ```

3. Follow `Getting Started` in [Google Maps Flutter Package](https://pub.dev/packages/google_maps_flutter) to enable Google Maps, retrieve your API key and add the package and related permissions to your app.
- As this demo is targeting a WebApp, add the following line in your `index.html` under your `web` folder, right before `<title>myapp</title>`:
  
    ```html
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
    ```
    - replace `YOUR_API_KEY` with your Google Maps API Key.

---

## 2. Run and Deploy WebApp

### 2.1 Copy the Code

- Copy the code from the [Ready Dashboard File](dashboard.dart) and paste it into your `dashboard.dart` file.

### 2.2 Run the App

- Run the app, log in, and navigate to the Dashboard Page.

### 2.3 Populate Data in Firestore

- Click on the menu icon in the top left corner to open the drawer. 

- Select the "Reset Summary" item to generate summary data in your Firestore. you should be able to see the summary cards now. 
  
- Select the "Add 20 Orders" item to generate order data in your Firestore. 

- Close the drawer.

- Click on the Refresh icon button in the top right corner. The app should now display order list and google maps.

### 2.4 Initialize Firebase Hosting

- In the left panel of IDX, select "Project IDX" (one item above Flutter). 
  
- Choose "Firebase Hosting" and then select "Initialize Firebase Hosting".

- When prompted in terminal, select "Use Existing Project", choose your project, and confirm to use the existing Flutter web codebase.

- Choose "us-central1 (Iowa)" as your region.

- Select "No" for automatic build and deploy with GitHub.

### 2.9 Deploy to Production

- In the left panel, select "Deploy to production".

- Wait for a while for terminal to build and deploy the project.
  
- Get the deployment link from your terminal.
