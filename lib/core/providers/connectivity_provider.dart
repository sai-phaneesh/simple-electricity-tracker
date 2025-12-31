import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the current network connectivity state
enum ConnectivityStatus { online, offline, checking }

/// Provider that monitors network connectivity status
final connectivityStatusProvider =
    NotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>(
      ConnectivityStatusNotifier.new,
    );

/// Stream provider for real-time connectivity updates
final connectivityStreamProvider = StreamProvider<ConnectivityStatus>((ref) {
  final notifier = ref.watch(connectivityStatusProvider.notifier);
  return notifier.connectivityStream;
});

/// Notifier that manages network connectivity state
class ConnectivityStatusNotifier extends Notifier<ConnectivityStatus> {
  @override
  ConnectivityStatus build() {
    _checkConnectivity();
    _startPeriodicCheck();
    return ConnectivityStatus.checking;
  }

  Timer? _periodicTimer;
  final _streamController = StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get connectivityStream => _streamController.stream;

  /// Checks network connectivity by attempting a DNS lookup
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Performs a connectivity check and updates state
  Future<void> _checkConnectivity() async {
    final hasConnection = await _hasInternetConnection();
    final newStatus = hasConnection
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    if (state != newStatus) {
      state = newStatus;
      _streamController.add(newStatus);
    }
  }

  /// Starts periodic connectivity checks every 30 seconds
  void _startPeriodicCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });
  }

  /// Manually trigger a connectivity check
  Future<void> checkNow() async {
    state = ConnectivityStatus.checking;
    await _checkConnectivity();
  }

  /// Returns true if currently online
  bool get isOnline => state == ConnectivityStatus.online;

  /// Returns true if currently offline
  bool get isOffline => state == ConnectivityStatus.offline;
}

/// Extension methods for easier connectivity checks
extension ConnectivityStatusExtension on ConnectivityStatus {
  bool get isOnline => this == ConnectivityStatus.online;
  bool get isOffline => this == ConnectivityStatus.offline;
  bool get isChecking => this == ConnectivityStatus.checking;

  String get displayMessage {
    switch (this) {
      case ConnectivityStatus.online:
        return 'Connected';
      case ConnectivityStatus.offline:
        return 'No internet connection';
      case ConnectivityStatus.checking:
        return 'Checking connection...';
    }
  }
}
