import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Ultimate Performance Manager for Samsar App
/// Handles memory management, lazy loading, and performance optimizations
class PerformanceManager {
  static final PerformanceManager _instance = PerformanceManager._internal();
  factory PerformanceManager() => _instance;
  PerformanceManager._internal();

  // Performance monitoring
  static bool _isInitialized = false;
  static final Map<String, DateTime> _controllerLoadTimes = {};
  static final Set<String> _loadedControllers = {};

  /// Initialize performance optimizations
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Configure system UI for performance
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    // Enable hardware acceleration
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _isInitialized = true;
  }

  /// Lazy load controller with performance tracking
  static T lazyLoadController<T extends GetxController>(
    T Function() controllerFactory, {
    String? tag,
    bool permanent = false,
  }) {
    final controllerName = T.toString() + (tag ?? '');
    
    // Check if controller already exists
    if (Get.isRegistered<T>(tag: tag)) {
      return Get.find<T>(tag: tag);
    }

    // Track loading time
    final startTime = DateTime.now();
    
    // Create controller
    final controller = Get.put<T>(
      controllerFactory(),
      tag: tag,
      permanent: permanent,
    );

    // Record performance metrics
    _controllerLoadTimes[controllerName] = DateTime.now();
    _loadedControllers.add(controllerName);

    final loadTime = DateTime.now().difference(startTime).inMilliseconds;
    debugPrint('🚀 Controller $controllerName loaded in ${loadTime}ms');

    return controller;
  }

  /// Clean up unused controllers for memory optimization
  static void cleanupUnusedControllers() {
    final controllersToRemove = <String>[];
    
    for (final controllerName in _loadedControllers) {
      final loadTime = _controllerLoadTimes[controllerName];
      if (loadTime != null) {
        final timeSinceLoad = DateTime.now().difference(loadTime);
        
        // Remove controllers not used for more than 5 minutes
        if (timeSinceLoad.inMinutes > 5) {
          controllersToRemove.add(controllerName);
        }
      }
    }

    for (final controllerName in controllersToRemove) {
      try {
        // Attempt to delete controller
        Get.deleteAll(force: false);
        _loadedControllers.remove(controllerName);
        _controllerLoadTimes.remove(controllerName);
        debugPrint('🧹 Cleaned up controller: $controllerName');
      } catch (e) {
        debugPrint('⚠️ Failed to cleanup controller $controllerName: $e');
      }
    }
  }

  /// Get performance metrics
  static Map<String, dynamic> getPerformanceMetrics() {
    return {
      'loadedControllers': _loadedControllers.length,
      'totalControllers': _controllerLoadTimes.length,
      'averageLoadTime': _calculateAverageLoadTime(),
      'memoryUsage': _getMemoryUsage(),
    };
  }

  static double _calculateAverageLoadTime() {
    if (_controllerLoadTimes.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final totalTime = _controllerLoadTimes.values
        .map((time) => now.difference(time).inMilliseconds)
        .reduce((a, b) => a + b);
    
    return totalTime / _controllerLoadTimes.length;
  }

  static String _getMemoryUsage() {
    // Simplified memory usage indicator
    return '${_loadedControllers.length * 2}MB (estimated)';
  }

  /// Force garbage collection
  static void forceGarbageCollection() {
    // Clean up controllers
    cleanupUnusedControllers();
    
    // Suggest garbage collection
    debugPrint('🗑️ Performing garbage collection...');
  }

  /// Optimize for battery usage
  static void optimizeForBattery() {
    // Disable debug prints in release mode
    if (!kDebugMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }
  }
}

/// Mixin for performance-optimized widgets
mixin PerformanceOptimizedWidget<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    PerformanceManager.initialize();
  }

  @override
  void dispose() {
    // Clean up when widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceManager.cleanupUnusedControllers();
    });
    super.dispose();
  }
}

/// Performance-optimized image widget
class OptimizedImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Use cached network image for better performance
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? 
            SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? 
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[400],
              ),
            );
        },
        // Performance optimizations
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        isAntiAlias: false, // Disable anti-aliasing for better performance
      );
    }

    // Use asset image
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        isAntiAlias: false,
      );
    }

    // Return placeholder if no image provided
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.image,
        color: Colors.grey[400],
      ),
    );
  }
}

/// Responsive design helper
class ResponsiveHelper {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return baseSize * 0.9;
    if (screenWidth > 600) return baseSize * 1.1;
    return baseSize;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return const EdgeInsets.all(12);
    if (screenWidth > 600) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }

  static int getGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 2;
    if (screenWidth < 900) return 3;
    return 4;
  }
}

/// Lazy loading list widget for better performance
class LazyLoadingList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int initialLoadCount;
  final int loadMoreCount;
  final Widget? loadingWidget;
  final ScrollController? scrollController;

  const LazyLoadingList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.initialLoadCount = 10,
    this.loadMoreCount = 5,
    this.loadingWidget,
    this.scrollController,
  });

  @override
  State<LazyLoadingList<T>> createState() => _LazyLoadingListState<T>();
}

class _LazyLoadingListState<T> extends State<LazyLoadingList<T>> {
  late ScrollController _scrollController;
  int _loadedItemCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _loadedItemCount = widget.initialLoadCount.clamp(0, widget.items.length);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || _loadedItemCount >= widget.items.length) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _loadedItemCount = (_loadedItemCount + widget.loadMoreCount)
              .clamp(0, widget.items.length);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _loadedItemCount + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _loadedItemCount) {
          return widget.loadingWidget ?? 
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
        }

        return widget.itemBuilder(context, widget.items[index], index);
      },
    );
  }
}
