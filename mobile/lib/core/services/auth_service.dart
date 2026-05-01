import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import '../models/user_model.dart';
import '../utils/api_client.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiClient _apiClient = ApiClient();
  
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  String? _pendingResetToken;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null && !JwtDecoder.isExpired(_accessToken!);
  bool get isConnectingPartner => _currentUser != null && _currentUser!.coupleId == null;
  
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final data = response.data;
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      _currentUser = User.fromJson(data['user']);
      
      await _storage.write(key: 'access_token', value: _accessToken);
      await _storage.write(key: 'refresh_token', value: _refreshToken);
      await _storage.write(key: 'user_data', value: jsonEncode(data['user']));
      
    } catch (e) {
      throw Exception('Falha no login: ${e.toString()}');
    }
  }
  
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      final data = response.data;
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      _currentUser = User.fromJson(data['user']);
      
      await _storage.write(key: 'access_token', value: _accessToken);
      await _storage.write(key: 'refresh_token', value: _refreshToken);
      await _storage.write(key: 'user_data', value: jsonEncode(data['user']));
      
    } catch (e) {
      throw Exception('Falha no cadastro: ${e.toString()}');
    }
  }
  
  Future<void> refreshToken() async {
    try {
      final response = await _apiClient.post('/auth/refresh', data: {
        'refresh_token': _refreshToken,
      });
      
      final data = response.data;
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      
      await _storage.write(key: 'access_token', value: _accessToken);
      await _storage.write(key: 'refresh_token', value: _refreshToken);
      
    } catch (e) {
      await logout();
      throw Exception('Sessão expirada. Faça login novamente.');
    }
  }
  
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Ignore logout errors
    }
    
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;
    
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_data');
  }
  
  static const _rememberedEmailKey = 'remembered_email';

  Future<void> saveRememberedEmail(String email) async {
    await _storage.write(key: _rememberedEmailKey, value: email);
  }

  Future<String?> loadRememberedEmail() async {
    return await _storage.read(key: _rememberedEmailKey);
  }

  Future<void> clearRememberedEmail() async {
    await _storage.delete(key: _rememberedEmailKey);
  }

  Future<void> loadStoredCredentials() async {
    try {
      _accessToken = await _storage.read(key: 'access_token');
      _refreshToken = await _storage.read(key: 'refresh_token');
      
      if (_accessToken != null && !JwtDecoder.isExpired(_accessToken!)) {
        // Load user data from storage or API
        final userData = await _storage.read(key: 'user_data');
        if (userData != null) {
          final decoded = jsonDecode(userData);
          if (decoded is Map<String, dynamic>) {
            _currentUser = User.fromJson(decoded);
          } else if (decoded is Map) {
            _currentUser = User.fromJson(decoded.cast<String, dynamic>());
          } else {
            await refreshUserProfile();
          }
        } else {
          await refreshUserProfile();
        }
      } else if (_refreshToken != null) {
        await refreshToken();
      }
    } catch (e) {
      await logout();
    }
  }
  
  Future<void> refreshUserProfile() async {
    try {
      final response = await _apiClient.get('/auth/profile');
      final data = response.data;
      final userJson = data is Map<String, dynamic> ? data['user'] : null;
      if (userJson is Map<String, dynamic>) {
        _currentUser = User.fromJson(userJson);
        await _storage.write(key: 'user_data', value: jsonEncode(userJson));
      } else {
        throw Exception('Resposta inválida ao carregar perfil');
      }
    } catch (e) {
      throw Exception('Falha ao carregar perfil: ${e.toString()}');
    }
  }
  
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post('/auth/forgot-password', data: {'email': email});
    } catch (e) {
      throw Exception('Falha ao enviar email de recuperação: ${e.toString()}');
    }
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post('/auth/verify-reset-code', data: {
        'email': email,
        'code': code,
      });
      final data = response.data;
      _pendingResetToken = data['reset_token'] as String?;
      if (_pendingResetToken == null || _pendingResetToken!.isEmpty) {
        throw Exception('Resposta inválida ao verificar código');
      }
    } catch (e) {
      throw Exception('Falha ao verificar código: ${e.toString()}');
    }
  }
  
  Future<void> resetPassword({
    required String newPassword,
  }) async {
    try {
      if (_pendingResetToken == null || _pendingResetToken!.isEmpty) {
        throw Exception('Código não verificado');
      }
      await _apiClient.post('/auth/reset-password', data: {
        'token': _pendingResetToken,
        'password': newPassword,
      });
      _pendingResetToken = null;
    } catch (e) {
      throw Exception('Falha ao redefinir senha: ${e.toString()}');
    }
  }
  
  Future<void> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      final response = await _apiClient.put('/auth/profile', data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      });
      
      final data = response.data;
      final userJson = data is Map<String, dynamic> ? data['user'] : null;
      if (userJson is Map<String, dynamic>) {
        _currentUser = User.fromJson(userJson);
        await _storage.write(key: 'user_data', value: jsonEncode(userJson));
      } else {
        throw Exception('Resposta inválida ao atualizar perfil');
      }
      
    } catch (e) {
      throw Exception('Falha ao atualizar perfil: ${e.toString()}');
    }
  }
  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.put('/auth/password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Falha ao alterar senha: ${e.toString()}');
    }
  }
}

final _authServiceSingleton = AuthService();

final authServiceProvider = Provider<AuthService>((ref) {
  return _authServiceSingleton;
});
