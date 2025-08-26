import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';

class LandAdvancedDetails extends StatefulWidget {
  const LandAdvancedDetails({super.key});

  @override
  State<LandAdvancedDetails> createState() => _LandAdvancedDetailsState();
}

class _LandAdvancedDetailsState extends State<LandAdvancedDetails> {
  late final ListingInputController _listingInputController;

  final TextEditingController zoningController = TextEditingController();
  final TextEditingController roadAccessController = TextEditingController();

  final List<String> zoningOptions = [
    'Residential',
    'Commercial',
    'Agricultural',
    'Industrial',
  ];
  final List<String> roadAccessOptions = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before accessing it
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(ListingInputController());
    }

    zoningController.text = _listingInputController.zoning.value;
    roadAccessController.text = _listingInputController.roadAccess.value;

    zoningController.addListener(() {
      _listingInputController.zoning.value = zoningController.text;
    });
    roadAccessController.addListener(() {
      _listingInputController.roadAccess.value = roadAccessController.text;
    });
  }

  @override
  void dispose() {
    zoningController.dispose();
    roadAccessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Land Basics (Syrian investors check first)
          Text(
            'land_essentials'.tr,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Road Access - CRITICAL for Syrian land value
          BuildInputWithOptions(
            title: 'Road Access',
            controller: roadAccessController,
            options: roadAccessOptions,
          ),
          const SizedBox(height: 16),

          // 2. Zoning - Important for development potential
          BuildInputWithOptions(
            title: 'Zoning',
            controller: zoningController,
            options: zoningOptions,
          ),
        ],
      ),
    );
  }
}
