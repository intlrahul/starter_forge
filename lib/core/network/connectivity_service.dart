import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:starter_forge/core/logging/app_logger.dart';

/// Service for monitoring network connectivity
class ConnectivityService {
  factory ConnectivityService() => _instance;

  ConnectivityService._internal();
  static final ConnectivityService _instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  bool _isConnected = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// Get the current connectivity status
  bool get isConnected => _isConnected;

  /// Stream of connectivity changes
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    try {
      // Check initial connectivity
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          AppLogger.error('Connectivity stream error', error);
        },
      );

      AppLogger.info('Connectivity service initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize connectivity service', e);
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    _isConnected = _hasActiveConnection(result);

    if (wasConnected != _isConnected) {
      AppLogger.info(
        'Connectivity changed: ${_isConnected ? 'Connected' : 'Disconnected'}',
      );
      _connectionController.add(_isConnected);
    }
  }

  /// Check if any of the connectivity results indicate an active connection
  bool _hasActiveConnection(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn;
  }

  /// Get detailed connectivity information
  Future<ConnectivityInfo> getConnectivityInfo() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final isConnected = _hasActiveConnection(result);

      ConnectivityType type = ConnectivityType.none;
      if (isConnected) {
        switch (result) {
          case ConnectivityResult.wifi:
            type = ConnectivityType.wifi;
            break;
          case ConnectivityResult.mobile:
            type = ConnectivityType.mobile;
            break;
          case ConnectivityResult.ethernet:
            type = ConnectivityType.ethernet;
            break;
          case ConnectivityResult.vpn:
            type = ConnectivityType.vpn;
            break;
          default:
            type = ConnectivityType.other;
        }
      }

      return ConnectivityInfo(
        isConnected: isConnected,
        type: type,
        result: result,
      );
    } catch (e) {
      AppLogger.error('Failed to get connectivity info', e);
      return ConnectivityInfo(
        isConnected: false,
        type: ConnectivityType.none,
        result: ConnectivityResult.none,
      );
    }
  }

  /// Check if we have a mobile connection
  Future<bool> hasMobileConnection() async {
    final info = await getConnectivityInfo();
    return info.type == ConnectivityType.mobile;
  }

  /// Check if we have a WiFi connection
  Future<bool> hasWifiConnection() async {
    final info = await getConnectivityInfo();
    return info.type == ConnectivityType.wifi;
  }

  /// Wait for connection to be established
  Future<void> waitForConnection({Duration? timeout}) async {
    if (_isConnected) return;

    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = connectionStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('Connection timeout', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
    AppLogger.info('Connectivity service disposed');
  }
}

/// Connectivity information
class ConnectivityInfo {
  const ConnectivityInfo({
    required this.isConnected,
    required this.type,
    required this.result,
  });
  final bool isConnected;
  final ConnectivityType type;
  final ConnectivityResult result;

  @override
  String toString() {
    return 'ConnectivityInfo(isConnected: $isConnected, type: $type, result: $result)';
  }
}

/// Simplified connectivity types
enum ConnectivityType { none, wifi, mobile, ethernet, vpn, other }
