# DuoDay - Setup Guide

## 🚀 Project Overview

DuoDay is a comprehensive couple's relationship management app built with Flutter (mobile) and Node.js (backend). The app helps couples manage their daily lives together through shared tasks, finances, emotional check-ins, and relationship insights.

## 📋 Prerequisites

### Development Environment
- **Node.js** 18+ 
- **Flutter** 3.10+ with Dart SDK
- **MongoDB** (local or cloud)
- **Git**

### Required Accounts
- **Firebase Project** (for notifications and authentication)
- **Email Service** (Gmail with App Password or other SMTP)

## 🛠️ Installation & Setup

### 1. Clone the Project
```bash
git clone <repository-url>
cd DouDay
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env
```

**Configure your `.env` file:**
```env
# Database
MONGODB_URI=mongodb://localhost:27017/duoday

# JWT Secrets (generate secure random strings)
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this

# Firebase Configuration
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR-KEY\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com

# Email Configuration
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# App Configuration
NODE_ENV=development
PORT=3000
FRONTEND_URL=http://localhost:3000
```

### 3. Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project "DuoDay"

2. **Enable Services**
   - Authentication (Email/Password)
   - Cloud Messaging
   - Firestore (optional)

3. **Download Service Account Key**
   - Project Settings → Service Accounts → Generate new private key
   - Save JSON file and copy credentials to `.env`

4. **Get FCM Config**
   - Project Settings → Cloud Messaging → Get sender ID
   - Add to Flutter app configuration

### 4. Flutter Setup

```bash
cd mobile

# Install dependencies
flutter pub get

# Copy environment file
cp assets/env/.env.example assets/env/.env

# Edit environment configuration
nano assets/env/.env
```

**Configure Flutter environment:**
```env
API_BASE_URL=http://localhost:3000
FIREBASE_PROJECT_ID=your-firebase-project-id
DEBUG_MODE=true
ENABLE_NOTIFICATIONS=true
```

### 5. Firebase Integration (Flutter)

1. **Add Firebase to Flutter**
   ```bash
   flutter pub add firebase_core firebase_messaging firebase_auth
   flutterfire configure
   ```

2. **Download `google-services.json`**
   - Firebase Console → Project Settings → Add app (Android/iOS)
   - Download config files to appropriate directories

## 🏃‍♂️ Running the Application

### Start Backend
```bash
cd backend
npm run dev
```
Backend will run on `http://localhost:3000`

### Start Flutter App
```bash
cd mobile
flutter run
```

## 📱 App Features

### 🔐 Authentication
- User registration and login
- JWT token authentication
- Password reset via email
- Secure token storage

### ❤️ Couple Connection
- Generate unique invite codes (DUO-XXXX)
- Connect with partner using invite code
- Relationship status management
- Partner profile information

### 📋 Core Modules
- **Tasks**: Shared task management with priorities
- **Finances**: Expense tracking and budget management  
- **Check-in**: Daily emotional connection
- **Agenda**: Shared calendar and events
- **Notes**: Real-time shared notes

### 🔔 Notifications
- Firebase Cloud Messaging
- Task reminders
- Check-in notifications
- Partner activity alerts

### 🎨 Design System
- Modern Material Design 3
- Purple primary color scheme (#7B61FF)
- Responsive layouts
- Dark/light theme support

## 🗂️ Project Structure

```
DouDay/
├── mobile/                 # Flutter app
│   ├── lib/
│   │   ├── core/          # Core services, themes, utils
│   │   ├── features/      # Feature modules
│   │   │   ├── auth/      # Authentication
│   │   │   ├── couple/    # Couple management
│   │   │   ├── tasks/     # Task management
│   │   │   ├── finances/  # Finance tracking
│   │   │   ├── checkin/   # Emotional check-in
│   │   │   └── agenda/    # Calendar/events
│   │   └── main.dart
│   ├── assets/
│   └── pubspec.yaml
├── backend/                # Node.js API
│   ├── src/
│   │   ├── models/        # MongoDB models
│   │   ├── routes/        # API endpoints
│   │   ├── middleware/    # Auth, validation
│   │   ├── services/      # Business logic
│   │   └── utils/         # Helper functions
│   ├── package.json
│   └── tsconfig.json
└── docs/                  # Documentation
```

## 🔧 Development Commands

### Backend
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm start           # Start production server
npm test            # Run tests
npm run lint        # Run linter
```

### Flutter
```bash
flutter pub get     # Install dependencies
flutter run         # Run app
flutter build apk   # Build Android APK
flutter build ios   # Build iOS app
flutter test        # Run tests
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test            # Run all tests
npm run test:watch  # Watch mode
```

### Flutter Tests
```bash
cd mobile
flutter test       # Run unit and widget tests
```

## 🚀 Deployment

### Backend (Production)
1. Set environment variables
2. Build: `npm run build`
3. Start: `npm start`
4. Use PM2 for process management

### Flutter (Production)
1. **Android**: `flutter build apk --release`
2. **iOS**: `flutter build ios --release`
3. Upload to respective app stores

## 🔒 Security Considerations

- JWT tokens with expiration
- Password hashing with bcrypt
- Rate limiting on API endpoints
- Input validation and sanitization
- HTTPS in production
- Secure storage for sensitive data

## 📞 Support & Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   - Check MongoDB URI in `.env`
   - Ensure MongoDB is running
   - Verify network connectivity

2. **Firebase Configuration**
   - Verify project ID matches
   - Check service account permissions
   - Ensure FCM is enabled

3. **Flutter Build Issues**
   - Run `flutter clean` and `flutter pub get`
   - Check Android/iOS configuration
   - Verify Firebase integration

### Getting Help
- Check the logs in backend console
- Use Flutter debugging tools
- Review Firebase console for errors
- Check network requests in browser dev tools

## 🎯 Next Steps

1. **Complete Core Features**
   - Implement all CRUD operations
   - Add real-time synchronization
   - Polish UI/UX

2. **Testing & Quality**
   - Write comprehensive tests
   - Performance optimization
   - Security audit

3. **Launch Preparation**
   - App store submission
   - Production deployment
   - Monitoring setup

---

**Happy Coding! 🚀**
