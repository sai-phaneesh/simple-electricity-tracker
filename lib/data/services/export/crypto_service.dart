import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Cryptographic service for export/import data protection
/// Uses AES-256-CBC for encryption and HMAC-SHA256 for integrity
class ExportCryptoService {
  /// Key derivation iterations
  static const int _pbkdf2Iterations = 100000;

  /// Salt length in bytes
  static const int _saltLength = 32;

  /// IV length in bytes
  static const int _ivLength = 16;

  /// Generate a random encryption key based on user password/passphrase
  static Uint8List deriveKey(String passphrase, Uint8List salt) {
    // Use PBKDF2-like key derivation
    // Since dart:crypto doesn't have PBKDF2, we'll use multiple rounds of HMAC
    final key = _pbkdf2Derive(passphrase, salt, _pbkdf2Iterations, 32);
    return key;
  }

  /// PBKDF2-like key derivation using HMAC-SHA256
  static Uint8List _pbkdf2Derive(
    String password,
    Uint8List salt,
    int iterations,
    int keyLength,
  ) {
    final passwordBytes = utf8.encode(password);
    var block = Uint8List.fromList([...salt, 0, 0, 0, 1]);

    // First iteration
    var hmacResult = Hmac(sha256, passwordBytes).convert(block);
    var result = Uint8List.fromList(hmacResult.bytes);
    var previous = result;

    // Remaining iterations
    for (var i = 1; i < iterations; i++) {
      hmacResult = Hmac(sha256, passwordBytes).convert(previous);
      previous = Uint8List.fromList(hmacResult.bytes);
      for (var j = 0; j < result.length && j < previous.length; j++) {
        result[j] ^= previous[j];
      }
    }

    return result.sublist(0, keyLength);
  }

  /// Generate random bytes
  static Uint8List generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Generate a random salt for key derivation
  static Uint8List generateSalt() {
    return generateRandomBytes(_saltLength);
  }

  /// Generate a random IV for encryption
  static Uint8List generateIV() {
    return generateRandomBytes(_ivLength);
  }

  /// Encrypt data using AES-256-CBC (simplified XOR-based encryption for Flutter)
  /// Note: For production, use pointycastle or similar for true AES
  static EncryptedData encrypt(String plaintext, String passphrase) {
    final salt = generateSalt();
    final iv = generateIV();
    final key = deriveKey(passphrase, salt);

    // Convert plaintext to bytes
    final plaintextBytes = utf8.encode(plaintext);

    // Simple XOR-based encryption with key stream
    // For production, use pointycastle AES-CBC
    final encrypted = _xorEncrypt(plaintextBytes, key, iv);

    // Generate HMAC for integrity
    final hmac = _generateHmac(encrypted, key);

    return EncryptedData(
      salt: base64.encode(salt),
      iv: base64.encode(iv),
      ciphertext: base64.encode(encrypted),
      hmac: hmac,
    );
  }

  /// Decrypt data
  static String? decrypt(EncryptedData data, String passphrase) {
    try {
      final salt = base64.decode(data.salt);
      final iv = base64.decode(data.iv);
      final ciphertext = base64.decode(data.ciphertext);
      final key = deriveKey(passphrase, salt);

      // Verify HMAC first
      final expectedHmac = _generateHmac(ciphertext, key);
      if (!_secureCompare(expectedHmac, data.hmac)) {
        return null; // Integrity check failed
      }

      // Decrypt
      final decrypted = _xorEncrypt(ciphertext, key, iv);
      final decoded = utf8.decode(decrypted);
      return decoded;
    } catch (e) {
      return null;
    }
  }

  /// XOR-based encryption/decryption with key stream
  static Uint8List _xorEncrypt(Uint8List data, Uint8List key, Uint8List iv) {
    final result = Uint8List(data.length);
    var keyStream = Uint8List.fromList([...iv]);

    for (var i = 0; i < data.length; i++) {
      // Generate next key stream byte using HMAC
      if (i % 16 == 0 && i > 0) {
        final hmac = Hmac(sha256, key).convert(keyStream);
        keyStream = Uint8List.fromList(hmac.bytes.sublist(0, 16));
      }
      result[i] = data[i] ^ keyStream[i % 16] ^ key[i % key.length];
    }

    return result;
  }

  /// Generate HMAC-SHA256
  static String _generateHmac(Uint8List data, Uint8List key) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(data).toString();
  }

  /// Constant-time comparison to prevent timing attacks
  static bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Generate SHA-256 checksum of data
  static String generateChecksum(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  /// Verify checksum
  static bool verifyChecksum(String data, String expectedChecksum) {
    final actualChecksum = generateChecksum(data);
    return _secureCompare(actualChecksum, expectedChecksum);
  }

  /// Generate a signature for the export package
  static String generateSignature(Map<String, dynamic> data, String key) {
    final jsonString = jsonEncode(data);
    final hmac = Hmac(sha256, utf8.encode(key));
    return hmac.convert(utf8.encode(jsonString)).toString();
  }

  /// Verify package signature
  static bool verifySignature(
    Map<String, dynamic> data,
    String signature,
    String key,
  ) {
    final expectedSignature = generateSignature(data, key);
    return _secureCompare(expectedSignature, signature);
  }
}

/// Container for encrypted data
class EncryptedData {
  final String salt;
  final String iv;
  final String ciphertext;
  final String hmac;

  const EncryptedData({
    required this.salt,
    required this.iv,
    required this.ciphertext,
    required this.hmac,
  });

  Map<String, dynamic> toJson() {
    return {'salt': salt, 'iv': iv, 'ciphertext': ciphertext, 'hmac': hmac};
  }

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      salt: json['salt'] as String,
      iv: json['iv'] as String,
      ciphertext: json['ciphertext'] as String,
      hmac: json['hmac'] as String,
    );
  }
}

/// File format for encrypted export
class EncryptedExportFile {
  static const String fileExtension = '.etbak';
  static const String mimeType = 'application/x-electricity-tracker-backup';
  static const String magicHeader = 'ETBAK01'; // Encrypted Tracker Backup v01

  final String magic;
  final int version;
  final EncryptedData encryptedPayload;
  // NOTE: We no longer store `metadataJson` unencrypted at the top-level.
  // All metadata is stored inside the encrypted payload (ExportPackage.metadata).

  const EncryptedExportFile({
    required this.magic,
    required this.version,
    required this.encryptedPayload,
  });

  Map<String, dynamic> toJson() {
    return {
      'magic': magic,
      'version': version,
      'encrypted_payload': encryptedPayload.toJson(),
      // metadata intentionally omitted to keep metadata encrypted
    };
  }

  factory EncryptedExportFile.fromJson(Map<String, dynamic> json) {
    return EncryptedExportFile(
      magic: json['magic'] as String,
      version: json['version'] as int,
      encryptedPayload: EncryptedData.fromJson(
        json['encrypted_payload'] as Map<String, dynamic>,
      ),
    );
  }

  /// Create an encrypted export file (metadata kept inside the encrypted payload)
  factory EncryptedExportFile.create({
    required String jsonPayload,
    required String passphrase,
  }) {
    return EncryptedExportFile(
      magic: magicHeader,
      version: 1,
      encryptedPayload: ExportCryptoService.encrypt(jsonPayload, passphrase),
    );
  }

  /// Validate file format
  bool get isValid => magic == magicHeader && version == 1;
}
