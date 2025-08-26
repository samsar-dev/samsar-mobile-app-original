import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/real_estate_listing/advance_listing_options_real_estate.dart';
import 'package:samsar/views/listing_features/create_listing/vehicle_listing/advance_listing_options.dart';

// ignore: must_be_immutable
class AddPictures extends StatefulWidget {
  bool isVehicles;
  AddPictures({super.key, this.isVehicles = true});

  @override
  State<AddPictures> createState() => _AddPicturesState();
}

class _AddPicturesState extends State<AddPictures> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  final ListingInputController _listingInputController =
      Get.find<ListingInputController>();

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 20) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('maximum_20_images_allowed'.tr)));
      return;
    }

    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        final remaining = 20 - _images.length;
        _images.addAll(pickedImages.take(remaining));
      });
    }
    Navigator.of(context).pop(); // Close the bottom sheet
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'add_pictures'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('select_from_gallery'.tr),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('take_a_photo'.tr),
                onTap: () async {
                  if (_images.length >= 20) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('maximum_20_images_allowed'.tr)),
                    );
                    return;
                  }

                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    setState(() {
                      _images.add(photo);
                    });
                  }
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_images.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Image.asset("lib/assets/add_image_mascot.png"),
                )
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _images.length < 20 ? _images.length + 1 : 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      if (index == _images.length && _images.length < 20) {
                        return GestureDetector(
                          onTap: _showImageSourceSelector,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_images[index].path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                "Note: Add minimum 2 pictures and maximum 20",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),

              // Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Select Pictures Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showImageSourceSelector,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text(
                          "Select Pictures",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Spacing between buttons
                    if (_images.length >= 2) const SizedBox(width: 16),

                    // Conditionally show Next Button
                    if (_images.length >= 2)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final List<String> imagePaths = _images
                                .map((img) => img.path)
                                .toList();
                            print(
                              'AddPictures: Setting image paths: $imagePaths',
                            ); // Debug print
                            _listingInputController.setImages(imagePaths);

                            widget.isVehicles
                                ? Get.to(
                                    AdvanceListingOptions(
                                      isVehicle: widget.isVehicles,
                                    ),
                                  )
                                : Get.to(AdvanceListingOptionsRealEstate());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
