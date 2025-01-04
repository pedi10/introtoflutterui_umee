# Firebase Integration Commands Reference

## 1. Firebase and Firestore Integration

Below are the essential commands to integrate Firebase and Firestore into your Flutter project:

| Step | Command | Purpose |
|------|---------|----------|
| 1 | `firebase login` | Authenticate with Firebase CLI |
| 2 | `dart pub global activate flutterfire_cli` | Install FlutterFire CLI tools |
| 3 | `flutterfire configure` | Configure Firebase for your Flutter project |
| 4 | `flutter pub add firebase_core cloud_firestore` | Add Firebase core and Firestore packages |
| 5 | `flutterfire configure` | Reconfigure Firebase after adding packages |

## 2. Firebase Hosting Deployment

Commands for deploying your Flutter web app to Firebase Hosting:

| Step | Command | Purpose |
|------|---------|----------|
| 1 | `flutter build web` | Build web version of your Flutter app |
| 2 | `firebase init hosting` | Initialize Firebase Hosting 
| 3 | `firebase deploy --only hosting` | Deploy your web app to Firebase Hosting |

### Notes:
- Ensure you are in your project directory when running these commands
- For `firebase init hosting`, select:
    - Use existing project
    - Select "us-central1" for server location
    - `build/web` as public directory
    - Configure as single-page app: Yes
    - Set up automatic builds: No
