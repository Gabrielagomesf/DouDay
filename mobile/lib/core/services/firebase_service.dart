import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  late final FirebaseMessaging _messaging;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;

  // Initialize Firebase
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;

      // Request notification permissions
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      final token = await _messaging.getToken();
      if (kDebugMode) debugPrint('FCM Token: $token');

    } catch (e) {
      if (kDebugMode) debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Authentication methods
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error signing up: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Firestore methods
  Future<void> setUserDocument(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      if (kDebugMode) debugPrint('Error setting user document: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting user document: $e');
      rethrow;
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  // Storage methods
  Future<String> uploadFile({
    required String filePath,
    required File file,
    required String userId,
  }) async {
    try {
      final ref = _storage.ref().child('$userId/$filePath');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) debugPrint('Error uploading file: $e');
      rethrow;
    }
  }

  // Messaging methods
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;
}
