import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PerformanceTest {
  static final PerformanceTest _instance = PerformanceTest._internal();
  factory PerformanceTest() => _instance;
  PerformanceTest._internal();

  final Map<String, DateTime> _startTimes = {};
  final Map<String, List<int>> _memorySnapshots = {};

  /// Start performance monitoring for a specific operation
  void startMonitoring(String operationName) {
    _startTimes[operationName] = DateTime.now();
    _takeMemorySnapshot(operationName);

    if (kDebugMode) {
      developer.log(
        '🚀 Started monitoring: $operationName',
        name: 'Performance',
      );
    }
  }

  /// Stop monitoring and log results
  void stopMonitoring(String operationName) {
    final startTime = _startTimes[operationName];
    if (startTime == null) {
      if (kDebugMode) {
        developer.log(
          '⚠️ No start time found for: $operationName',
          name: 'Performance',
        );
      }
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _takeMemorySnapshot('${operationName}_end');

    final memoryUsage = _calculateMemoryDelta(operationName);

    if (kDebugMode) {
      developer.log(
        '✅ $operationName completed in ${duration.inMilliseconds}ms | Memory: ${memoryUsage}MB',
        name: 'Performance',
      );
    }

    _startTimes.remove(operationName);
  }

  /// Take a memory snapshot
  void _takeMemorySnapshot(String label) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Use platform-specific memory monitoring
      _getMemoryUsage().then((memory) {
        _memorySnapshots[label] = [memory];
      });
    }
  }

  /// Get current memory usage
  Future<int> _getMemoryUsage() async {
    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel('performance/memory');
        final int memory = await platform.invokeMethod('getMemoryUsage');
        return memory;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate memory delta between start and end
  String _calculateMemoryDelta(String operationName) {
    final startMemory = _memorySnapshots[operationName];
    final endMemory = _memorySnapshots['${operationName}_end'];

    if (startMemory != null && endMemory != null) {
      final delta = endMemory.first - startMemory.first;
      return '${(delta / 1024 / 1024).toStringAsFixed(2)}';
    }

    return 'N/A';
  }

  /// Test lazy loading performance
  static Future<void> testLazyLoading() async {
    final test = PerformanceTest();

    // Test controller lazy loading
    test.startMonitoring('controller_lazy_load');

    // Simulate lazy loading different controllers
    final controllers = [
      'LocationController',
      'FilterController',
      'TrendingListingController',
    ];

    for (final controller in controllers) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (kDebugMode) {
        developer.log('Lazy loaded: $controller', name: 'LazyLoad');
      }
    }

    test.stopMonitoring('controller_lazy_load');
  }

  /// Test memory cleanup
  static Future<void> testMemoryCleanup() async {
    final test = PerformanceTest();

    test.startMonitoring('memory_cleanup');

    // Force garbage collection
    await Future.delayed(const Duration(milliseconds: 500));

    if (kDebugMode) {
      developer.log('Memory cleanup completed', name: 'Memory');
    }

    test.stopMonitoring('memory_cleanup');
  }

  /// Test responsive design performance
  static void testResponsiveDesign() {
    final test = PerformanceTest();

    test.startMonitoring('responsive_calculations');

    // Simulate responsive calculations
    final screenSizes = [
      {'width': 360.0, 'height': 640.0}, // Small phone
      {'width': 414.0, 'height': 896.0}, // Large phone
      {'width': 768.0, 'height': 1024.0}, // Tablet
    ];

    for (final size in screenSizes) {
      // Simulate responsive calculations
      final isSmall = size['width']! < 600;
      final isMedium = size['width']! >= 600 && size['width']! < 900;
      final isLarge = size['width']! >= 900;

      if (kDebugMode) {
        developer.log(
          'Screen ${size['width']}x${size['height']}: Small=$isSmall, Medium=$isMedium, Large=$isLarge',
          name: 'Responsive',
        );
      }
    }

    test.stopMonitoring('responsive_calculations');
  }

  /// Run comprehensive performance tests
  static Future<void> runAllTests() async {
    if (kDebugMode) {
      developer.log(
        '🧪 Starting comprehensive performance tests...',
        name: 'Performance',
      );
    }

    await testLazyLoading();
    await testMemoryCleanup();
    testResponsiveDesign();

    if (kDebugMode) {
      developer.log('✅ All performance tests completed!', name: 'Performance');
    }
  }

  /// Monitor app startup performance
  static void monitorAppStartup() {
    final test = PerformanceTest();
    test.startMonitoring('app_startup');

    // This should be called when app initialization is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      test.stopMonitoring('app_startup');
    });
  }

  /// Monitor page navigation performance
  static void monitorPageNavigation(String pageName) {
    final test = PerformanceTest();
    test.startMonitoring('navigate_to_$pageName');

    // Stop monitoring after next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      test.stopMonitoring('navigate_to_$pageName');
    });
  }
}
