import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle/vehicle_data_model.dart';
import '../widgets/build_input_with_options/build_input_with_options.dart';

class VehicleSelectionWidget extends StatefulWidget {
  final VehicleSubcategory subcategory;
  final String? initialMake;
  final String? initialModel;
  final Function(String? make, String? model)? onSelectionChanged;
  final bool showError;

  const VehicleSelectionWidget({
    Key? key,
    required this.subcategory,
    this.initialMake,
    this.initialModel,
    this.onSelectionChanged,
    this.showError = false,
  }) : super(key: key);

  @override
  State<VehicleSelectionWidget> createState() => _VehicleSelectionWidgetState();
}

class _VehicleSelectionWidgetState extends State<VehicleSelectionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void didUpdateWidget(VehicleSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If subcategory changed, reload data and clear selections
    if (oldWidget.subcategory != widget.subcategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadInitialData();
      });
    }
  }

  void _loadInitialData() {
    try {
      final controller = Provider.of<VehicleController>(context, listen: false);
      
      print('🚗 Loading makes for subcategory: ${widget.subcategory.value}');
      
      // Load makes for the subcategory
      controller.loadMakes(widget.subcategory).then((_) {
        print('✅ Makes loaded: ${controller.makes.length} items');
        // If initial make is provided, select it and load models
        if (widget.initialMake != null && controller.makes.contains(widget.initialMake)) {
          controller.selectMake(widget.initialMake!).then((_) {
            // If initial model is provided, select it
            if (widget.initialModel != null && controller.models.contains(widget.initialModel)) {
              controller.selectModel(widget.initialModel!);
            }
          });
        }
      }).catchError((error) {
        print('❌ Error loading makes: $error');
      });
    } catch (e) {
      print('❌ Error in _loadInitialData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Make Selection
            _buildMakeDropdown(controller),
            
            const SizedBox(height: 16),
            
            // Model Selection
            _buildModelDropdown(controller),
            
            // Error Display
            if (controller.hasError) ...[
              const SizedBox(height: 8),
              _buildErrorWidget(controller),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMakeDropdown(VehicleController controller) {
    // Determine available options based on state
    List<String> options;
    if (controller.isLoadingMakes) {
      options = ["loading_makes".tr];
    } else if (controller.makes.isNotEmpty) {
      options = controller.makes;
    } else {
      options = ["no_makes_available".tr];
    }

    return BuildInputWithOptions(
      title: "make".tr,
      controller: TextEditingController(text: controller.selectedMake ?? ''),
      options: options,
      hasError: widget.showError && controller.selectedMake == null,
      onChanged: controller.isLoadingMakes
          ? null
          : (String? selectedMake) {
              if (selectedMake != null && selectedMake != "loading_makes".tr && selectedMake != "no_makes_available".tr) {
                controller.selectMake(selectedMake);
                widget.onSelectionChanged?.call(selectedMake, null);
              }
            },
    );
  }

  Widget _buildModelDropdown(VehicleController controller) {
    // Determine available options based on state
    List<String> options;
    if (controller.selectedMake == null) {
      options = ["select_make_first".tr];
    } else if (controller.isLoadingModels) {
      options = ["loading_models".tr];
    } else if (controller.models.isNotEmpty) {
      options = controller.models;
    } else {
      options = ["no_models_available".tr];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildInputWithOptions(
          title: "model".tr,
          controller: TextEditingController(text: controller.selectedModel ?? ''),
          options: options,
          hasError: widget.showError && controller.selectedModel == null,
          onChanged: (controller.selectedMake != null && !controller.isLoadingModels)
              ? (String? selectedModel) {
                  if (selectedModel != null && 
                      selectedModel != "select_make_first".tr &&
                      selectedModel != "loading_models".tr && 
                      selectedModel != "no_models_available".tr) {
                    controller.selectModel(selectedModel);
                    widget.onSelectionChanged?.call(controller.selectedMake, selectedModel);
                  }
                }
              : null,
        ),
        if (controller.modelsError != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.error_outline, size: 16, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  controller.modelsError!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: controller.retryLoadModels,
                child: Text('Retry', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildErrorWidget(VehicleController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failed to load vehicle data',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (controller.makesError != null)
                  Text(
                    controller.makesError!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                if (controller.modelsError != null)
                  Text(
                    controller.modelsError!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.makesError != null) {
                controller.retryLoadMakes();
              }
              if (controller.modelsError != null) {
                controller.retryLoadModels();
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
