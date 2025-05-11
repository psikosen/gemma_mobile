import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SecurityService {
  static const String _passcodeKey = 'rchat_passcode';
  static const String _passcodeEnabledKey = 'rchat_passcode_enabled';
  static const String _biometricsEnabledKey = 'rchat_biometrics_enabled';
  static const String _databaseKeyKey = 'rchat_database_key';
  
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  
  SecurityService({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuth,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _localAuth = localAuth ?? LocalAuthentication();
  
  // Check if passcode is enabled
  Future<bool> isPasscodeEnabled() async {
    final result = await _secureStorage.read(key: _passcodeEnabledKey);
    return result == 'true';
  }
  
  // Set passcode
  Future<void> setPasscode(String passcode) async {
    // Hash the passcode before storing
    final hashedPasscode = _hashPasscode(passcode);
    
    await _secureStorage.write(key: _passcodeKey, value: hashedPasscode);
    await _secureStorage.write(key: _passcodeEnabledKey, value: 'true');
    
    // Generate or update database encryption key
    final encryptionKey = _generateEncryptionKey(passcode);
    await _secureStorage.write(key: _databaseKeyKey, value: encryptionKey);
  }
  
  // Verify passcode
  Future<bool> verifyPasscode(String passcode) async {
    final storedPasscode = await _secureStorage.read(key: _passcodeKey);
    if (storedPasscode == null) return false;
    
    final hashedInput = _hashPasscode(passcode);
    return storedPasscode == hashedInput;
  }
  
  // Disable passcode
  Future<void> disablePasscode() async {
    await _secureStorage.write(key: _passcodeEnabledKey, value: 'false');
  }
  
  // Check if biometrics is available and enabled
  Future<bool> isBiometricsAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }
  
  Future<bool> isBiometricsEnabled() async {
    final result = await _secureStorage.read(key: _biometricsEnabledKey);
    return result == 'true';
  }
  
  // Enable biometrics
  Future<void> enableBiometrics() async {
    await _secureStorage.write(key: _biometricsEnabledKey, value: 'true');
  }
  
  // Disable biometrics
  Future<void> disableBiometrics() async {
    await _secureStorage.write(key: _biometricsEnabledKey, value: 'false');
  }
  
  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) return false;
    
    final biometricsEnabled = await isBiometricsEnabled();
    if (!biometricsEnabled) return false;
    
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access RCHAT',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
  
  // Get database encryption key
  Future<String?> getDatabaseEncryptionKey() async {
    return await _secureStorage.read(key: _databaseKeyKey);
  }
  
  // Hash passcode using SHA-256
  String _hashPasscode(String passcode) {
    final bytes = utf8.encode(passcode);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Generate encryption key from passcode
  // In a production app, you would use a more secure method like PBKDF2
  String _generateEncryptionKey(String passcode) {
    final bytes = utf8.encode(passcode + 'RCHAT_SALT_2025');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
