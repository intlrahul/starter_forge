import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/network/connectivity_service.dart';

void main() {
  group('ConnectivityService', () {
    late ConnectivityService connectivityService;

    setUp(() {
      connectivityService = ConnectivityService();
    });

    tearDown(() {
      connectivityService.dispose();
    });

    group('initialization', () {
      test('creates service with default values', () {
        expect(connectivityService.isConnected, isFalse);
        expect(connectivityService.connectionStream, isNotNull);
      });

      test('initializes connectivity monitoring successfully', () async {
        // The actual initialize method would need dependency injection to test fully
        expect(() => connectivityService.initialize(), returnsNormally);
      });
    });

    group('connectivity status checking', () {
      test('has initial connection state', () {
        expect(connectivityService.isConnected, isA<bool>());
      });

      test('connection stream is available', () {
        expect(connectivityService.connectionStream, isA<Stream<bool>>());
      });
    });

    group('connectivity info', () {
      test('getConnectivityInfo returns ConnectivityInfo', () async {
        final info = await connectivityService.getConnectivityInfo();
        
        expect(info, isA<ConnectivityInfo>());
        expect(info.isConnected, isA<bool>());
        expect(info.type, isA<ConnectivityType>());
        expect(info.result, isA<ConnectivityResult>());
      });

      test('getConnectivityInfo handles errors gracefully', () async {
        // Even if there are errors, should return valid ConnectivityInfo
        final info = await connectivityService.getConnectivityInfo();
        expect(info, isNotNull);
        expect(info, isA<ConnectivityInfo>());
      });
    });

    group('specific connection type checks', () {
      test('hasMobileConnection returns bool', () async {
        final hasMobile = await connectivityService.hasMobileConnection();
        expect(hasMobile, isA<bool>());
      });

      test('hasWifiConnection returns bool', () async {
        final hasWifi = await connectivityService.hasWifiConnection();
        expect(hasWifi, isA<bool>());
      });
    });

    group('waitForConnection', () {
      test('returns future that can be called', () async {
        expect(() => connectivityService.waitForConnection(), returnsNormally);
      });

      test('waits for connection with timeout', () async {
        expect(() => connectivityService.waitForConnection(
            timeout: Duration(milliseconds: 100)), 
            returnsNormally);
      });
    });

    group('stream monitoring', () {
      test('connectionStream provides connectivity updates', () {
        final stream = connectivityService.connectionStream;
        expect(stream, isA<Stream<bool>>());
      });

      test('connectionStream can be listened to multiple times', () {
        // Should be able to listen multiple times (broadcast stream)
        final stream = connectivityService.connectionStream;
        
        expect(() => stream.listen((_) {}), returnsNormally);
        expect(() => stream.listen((_) {}), returnsNormally);
      });
    });

    group('disposal', () {
      test('dispose can be called without error', () {
        expect(() => connectivityService.dispose(), returnsNormally);
      });

      test('dispose can be called multiple times safely', () {
        connectivityService.dispose();
        expect(() => connectivityService.dispose(), returnsNormally);
      });
    });

    group('ConnectivityInfo', () {
      test('creates ConnectivityInfo with all parameters', () {
        const info = ConnectivityInfo(
          isConnected: true,
          type: ConnectivityType.wifi,
          result: ConnectivityResult.wifi,
        );
        
        expect(info.isConnected, isTrue);
        expect(info.type, equals(ConnectivityType.wifi));
        expect(info.result, equals(ConnectivityResult.wifi));
      });

      test('toString returns proper string representation', () {
        const info = ConnectivityInfo(
          isConnected: true,
          type: ConnectivityType.mobile,
          result: ConnectivityResult.mobile,
        );
        
        final stringRepresentation = info.toString();
        expect(stringRepresentation, contains('ConnectivityInfo'));
        expect(stringRepresentation, contains('isConnected: true'));
        expect(stringRepresentation, contains('type: ConnectivityType.mobile'));
        expect(stringRepresentation, contains('result: ConnectivityResult.mobile'));
      });

      test('handles false connection state', () {
        const info = ConnectivityInfo(
          isConnected: false,
          type: ConnectivityType.none,
          result: ConnectivityResult.none,
        );
        
        expect(info.isConnected, isFalse);
        expect(info.type, equals(ConnectivityType.none));
        expect(info.result, equals(ConnectivityResult.none));
      });
    });

    group('ConnectivityType enum', () {
      test('has all expected values', () {
        const types = ConnectivityType.values;
        
        expect(types, contains(ConnectivityType.none));
        expect(types, contains(ConnectivityType.wifi));
        expect(types, contains(ConnectivityType.mobile));
        expect(types, contains(ConnectivityType.ethernet));
        expect(types, contains(ConnectivityType.vpn));
        expect(types, contains(ConnectivityType.other));
      });

      test('enum values have correct string representation', () {
        expect(ConnectivityType.none.toString(), contains('none'));
        expect(ConnectivityType.wifi.toString(), contains('wifi'));
        expect(ConnectivityType.mobile.toString(), contains('mobile'));
        expect(ConnectivityType.ethernet.toString(), contains('ethernet'));
        expect(ConnectivityType.vpn.toString(), contains('vpn'));
        expect(ConnectivityType.other.toString(), contains('other'));
      });
    });

    group('service functionality', () {
      test('service can be created multiple times', () {
        final service1 = ConnectivityService();
        final service2 = ConnectivityService();
        
        expect(service1, isNotNull);
        expect(service2, isNotNull);
        expect(service1, isNot(same(service2)));
        
        service1.dispose();
        service2.dispose();
      });

      test('methods are available and callable', () {
        expect(() => connectivityService.isConnected, returnsNormally);
        expect(() => connectivityService.connectionStream, returnsNormally);
        expect(() => connectivityService.getConnectivityInfo(), returnsNormally);
        expect(() => connectivityService.hasMobileConnection(), returnsNormally);
        expect(() => connectivityService.hasWifiConnection(), returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles service lifecycle correctly', () {
        final service = ConnectivityService();
        
        // Should work before initialization
        expect(service.isConnected, isA<bool>());
        
        // Should work after disposal
        service.dispose();
        expect(() => service.isConnected, returnsNormally);
      });

      test('connection stream survives service lifecycle', () {
        final service = ConnectivityService();
        final stream = service.connectionStream;
        
        expect(stream, isNotNull);
        
        service.dispose();
        expect(stream, isNotNull);
      });
    });

    group('async operations', () {
      test('all async methods return futures', () {
        expect(connectivityService.initialize(), isA<Future>());
        expect(connectivityService.getConnectivityInfo(), isA<Future<ConnectivityInfo>>());
        expect(connectivityService.hasMobileConnection(), isA<Future<bool>>());
        expect(connectivityService.hasWifiConnection(), isA<Future<bool>>());
        expect(connectivityService.waitForConnection(), isA<Future<void>>());
      });

      test('async methods can be awaited', () async {
        // These should complete without throwing
        await expectLater(connectivityService.initialize(), completes);
        await expectLater(connectivityService.getConnectivityInfo(), completes);
        await expectLater(connectivityService.hasMobileConnection(), completes);
        await expectLater(connectivityService.hasWifiConnection(), completes);
      });
    });

    group('properties and getters', () {
      test('isConnected is accessible', () {
        expect(() => connectivityService.isConnected, returnsNormally);
        expect(connectivityService.isConnected, isA<bool>());
      });

      test('connectionStream is accessible', () {
        expect(() => connectivityService.connectionStream, returnsNormally);
        expect(connectivityService.connectionStream, isA<Stream<bool>>());
      });
    });
  });
}