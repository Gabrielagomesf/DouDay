"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const firebase_admin_1 = __importDefault(require("firebase-admin"));
class FirebaseService {
    constructor() {
        this.initializeFirebase();
    }
    static getInstance() {
        if (!FirebaseService._instance) {
            FirebaseService._instance = new FirebaseService();
        }
        return FirebaseService._instance;
    }
    initializeFirebase() {
        try {
            // Check if Firebase is already initialized
            if (firebase_admin_1.default.apps.length > 0) {
                this._app = firebase_admin_1.default.apps[0];
            }
            else {
                // Initialize Firebase Admin SDK
                const serviceAccount = {
                    projectId: process.env.FIREBASE_PROJECT_ID,
                    privateKeyId: process.env.FIREBASE_PRIVATE_KEY_ID,
                    privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
                    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
                    clientId: process.env.FIREBASE_CLIENT_ID,
                    authUri: process.env.FIREBASE_AUTH_URI,
                    tokenUri: process.env.FIREBASE_TOKEN_URI,
                };
                this._app = firebase_admin_1.default.initializeApp({
                    credential: firebase_admin_1.default.credential.cert(serviceAccount),
                    projectId: process.env.FIREBASE_PROJECT_ID,
                    storageBucket: process.env.FIREBASE_STORAGE_BUCKET || undefined,
                });
            }
            this._auth = this._app.auth();
            this._firestore = this._app.firestore();
            this._storage = this._app.storage();
            console.log('✅ Firebase Admin initialized successfully');
        }
        catch (error) {
            console.error('❌ Error initializing Firebase Admin:', error);
            throw error;
        }
    }
    // Getters
    get app() {
        return this._app;
    }
    get auth() {
        return this._auth;
    }
    get firestore() {
        return this._firestore;
    }
    get storage() {
        return this._storage;
    }
    // Authentication methods
    async createUser(email, password, displayName) {
        try {
            const userRecord = await this._auth.createUser({
                email,
                password,
                displayName,
            });
            return userRecord;
        }
        catch (error) {
            console.error('Error creating Firebase user:', error);
            throw error;
        }
    }
    async verifyIdToken(idToken) {
        try {
            const decodedToken = await this._auth.verifyIdToken(idToken);
            return decodedToken;
        }
        catch (error) {
            console.error('Error verifying ID token:', error);
            throw error;
        }
    }
    async getUser(uid) {
        try {
            const userRecord = await this._auth.getUser(uid);
            return userRecord;
        }
        catch (error) {
            console.error('Error getting Firebase user:', error);
            throw error;
        }
    }
    async updateUser(uid, data) {
        try {
            const userRecord = await this._auth.updateUser(uid, data);
            return userRecord;
        }
        catch (error) {
            console.error('Error updating Firebase user:', error);
            throw error;
        }
    }
    async deleteUser(uid) {
        try {
            await this._auth.deleteUser(uid);
        }
        catch (error) {
            console.error('Error deleting Firebase user:', error);
            throw error;
        }
    }
    // Firestore methods
    async createDocument(collection, data, customId) {
        try {
            const docRef = customId
                ? this._firestore.collection(collection).doc(customId)
                : this._firestore.collection(collection).doc();
            await docRef.set(data);
            return docRef;
        }
        catch (error) {
            console.error('Error creating Firestore document:', error);
            throw error;
        }
    }
    async getDocument(collection, docId) {
        try {
            const docRef = this._firestore.collection(collection).doc(docId);
            const docSnap = await docRef.get();
            return docSnap;
        }
        catch (error) {
            console.error('Error getting Firestore document:', error);
            throw error;
        }
    }
    async updateDocument(collection, docId, data) {
        try {
            const docRef = this._firestore.collection(collection).doc(docId);
            await docRef.update(data);
        }
        catch (error) {
            console.error('Error updating Firestore document:', error);
            throw error;
        }
    }
    async deleteDocument(collection, docId) {
        try {
            const docRef = this._firestore.collection(collection).doc(docId);
            await docRef.delete();
        }
        catch (error) {
            console.error('Error deleting Firestore document:', error);
            throw error;
        }
    }
    async queryCollection(collection, queries) {
        try {
            let query = this._firestore.collection(collection);
            queries.forEach(({ field, operator, value }) => {
                query = query.where(field, operator, value);
            });
            return await query.get();
        }
        catch (error) {
            console.error('Error querying Firestore collection:', error);
            throw error;
        }
    }
    // Storage methods
    async uploadFile(bucketPath, fileBuffer, metadata) {
        try {
            const bucket = this._storage.bucket();
            const file = bucket.file(bucketPath);
            await file.save(fileBuffer, metadata);
            const [url] = await file.getSignedUrl({
                action: 'read',
                expires: '03-01-2500', // Far future date
            });
            return url;
        }
        catch (error) {
            console.error('Error uploading file to Firebase Storage:', error);
            throw error;
        }
    }
    async deleteFile(bucketPath) {
        try {
            const bucket = this._storage.bucket();
            const file = bucket.file(bucketPath);
            await file.delete();
        }
        catch (error) {
            console.error('Error deleting file from Firebase Storage:', error);
            throw error;
        }
    }
    // Cloud Messaging
    async sendNotification(token, notification, data) {
        try {
            const message = {
                token,
                notification,
                data,
                android: {
                    priority: 'high',
                    notification: {
                        sound: 'default',
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    },
                },
                apns: {
                    payload: {
                        aps: {
                            sound: 'default',
                            badge: 1,
                        },
                    },
                },
            };
            const response = await this._app.messaging().send(message);
            return response;
        }
        catch (error) {
            console.error('Error sending notification:', error);
            throw error;
        }
    }
    async sendMulticastNotification(tokens, notification, data) {
        try {
            const message = {
                tokens,
                notification,
                data,
                android: {
                    priority: 'high',
                    notification: {
                        sound: 'default',
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    },
                },
                apns: {
                    payload: {
                        aps: {
                            sound: 'default',
                            badge: 1,
                        },
                    },
                },
            };
            const response = await this._app.messaging().sendMulticast(message);
            return response;
        }
        catch (error) {
            console.error('Error sending multicast notification:', error);
            throw error;
        }
    }
}
exports.default = FirebaseService;
