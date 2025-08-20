import 'dart:convert';
import 'package:samsar/models/listing/vehicle_model.dart' as car_listing;
import 'package:samsar/models/listing/real_estate_model.dart' as real_estate_listing;
import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';
import 'package:samsar/models/listing/create_listing/create_vehicle_listing.dart';
import 'package:samsar/models/listing/create_listing/create_real_estate_listing.dart';
import 'package:http_parser/http_parser.dart';         
import 'package:mime/mime.dart';                     
import 'package:path/path.dart';
import 'package:get/get.dart' as GetX;
import 'package:samsar/controllers/listing/listing_input_controller.dart';  


class CreateListingService {
  final _dio = Dio();

  // Commercial Vehicle Service for VANS, BUSES, TRACTORS
  Future<ApiResponse<CreateCarListing>> createCommercialVehicleService(
    String accessToken,
    CommercialVehicleModel commercialDetails,
  ) async {
    try {
      // Prepare multipart form data
      print("=== SENDING COMMERCIAL VEHICLE DATA ===");
      print("mainCategory: ${commercialDetails.mainCategory}");
      print("subCategory: ${commercialDetails.subCategory}");
      print("vehicleSubtype: ${commercialDetails.vehicleSubtype}");
      print("title: ${commercialDetails.title}");
      print("description: ${commercialDetails.description}");
      print("price: ${commercialDetails.price}");
      print("location: ${commercialDetails.location}");
      print("condition: ${commercialDetails.condition}");
      print("vehicles details: ${commercialDetails.details.toJson()}");
      
      final formData = FormData.fromMap({
        'title': commercialDetails.title,
        'description': commercialDetails.description,
        'price': commercialDetails.price.toString(),
        'mainCategory': commercialDetails.mainCategory,
        'subCategory': commercialDetails.subCategory,
        'location': commercialDetails.location,
        'latitude': commercialDetails.latitude,
        'longitude': commercialDetails.longitude,
        'condition': commercialDetails.condition,
        'listingAction': _mapListingAction(commercialDetails.listingAction),
        // Send these fields separately instead of JSON - match backend field names
        'make': commercialDetails.details.make,
        'model': commercialDetails.details.model,
        'year': commercialDetails.details.year.toString(),
        'sellerType': _mapSellerType(commercialDetails.sellerType),
        'bodyType': commercialDetails.details.bodyType,
        'fuelType': _mapFuelType(commercialDetails.details.fuelType?.toString()),
        'transmission': _mapTransmissionType(commercialDetails.details.transmissionType?.toString()), // Changed from transmissionType
        'exteriorColor': commercialDetails.details.color, // Changed from color
        'engineSize': commercialDetails.details.engineSize?.toString() ?? '',
        'mileage': commercialDetails.details.mileage?.toString() ?? '',
        'accidental': commercialDetails.details.accidentFree == true ? 'no' : 'yes',
        'registrationExpiry': commercialDetails.details.registrationExpiry ?? '',
        // Keep other fields as JSON in details
        'details': jsonEncode({
          'vehicles': {
            'vehicleType': commercialDetails.subCategory.toUpperCase(),
            'vehicleSubtype': commercialDetails.details.vehicleSubtype,
            'mileage': commercialDetails.details.mileage?.toString(),
            'previousOwners': commercialDetails.details.previousOwners,
            'engineSize': commercialDetails.details.engineSize,
            'engineNumber': commercialDetails.details.engineNumber,
            'registrationStatus': commercialDetails.details.registrationStatus,
            'registrationExpiry': commercialDetails.details.registrationExpiry,
            'serviceHistory': commercialDetails.details.serviceHistory,
            'warranty': commercialDetails.details.warranty,
            'accidentFree': commercialDetails.details.accidentFree,
            'customsCleared': commercialDetails.details.customsCleared,
            'features': commercialDetails.details.features,
            'payloadCapacity': commercialDetails.details.payloadCapacity,
            'cargoVolume': commercialDetails.details.cargoVolume,
            'seatingCapacity': commercialDetails.details.seatingCapacity,
            'axles': commercialDetails.details.axles,
            'gvw': commercialDetails.details.gvw,
            'airConditioning': commercialDetails.details.airConditioning,
            'powerSteering': commercialDetails.details.powerSteering,
          }
        }),
        'listingImage': await Future.wait(
          commercialDetails.listingImage.map((filePath) async {
            final mimeType = lookupMimeType(filePath) ?? 'image/jpeg';
            return await MultipartFile.fromFile(
              filePath,
              contentType: MediaType.parse(mimeType),
              filename: basename(filePath),
            );
          }),
        ),
      });

      final response = await _dio.post(
        createListingRoute,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("=== COMMERCIAL VEHICLE API CALL COMPLETED ===");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("=== SUCCESS: Commercial vehicle listing created successfully ===");
        
        Map<String, dynamic> responseMap;
        if (response.data is String) {
          try {
            responseMap = json.decode(response.data);
          } catch (e) {
            print("=== ERROR: Failed to parse string response as JSON ===");
            return ApiResponse.failure(ApiError(
              fastifyErrorResponse: null, 
              errorResponse: null
            ));
          }
        } else if (response.data is Map<String, dynamic>) {
          responseMap = response.data;
        } else {
          print("=== ERROR: Unexpected response data type ===");
          return ApiResponse.failure(ApiError(
            fastifyErrorResponse: null, 
            errorResponse: null
          ));
        }
        
        final model = CreateCarListing.fromJson(responseMap);
        return ApiResponse.success(model);
      } else {
        print("=== ERROR: Commercial vehicle listing creation failed ===");
        return ApiResponse.failure(ApiError(
          fastifyErrorResponse: null, 
          errorResponse: null
        ));
      }
    } catch (e) {
      print("=== EXCEPTION in createCommercialVehicleService ===");
      print("Exception: $e");
      return ApiResponse.failure(ApiError(
        fastifyErrorResponse: null, 
        errorResponse: null
      ));
    }
  }

  Future<ApiResponse<CreateRealEstateListing>> createRealEstateListingService(
    String accessToken,
    real_estate_listing.RealEstateModel realEstateDetails,
  ) async {
    try {
      final formData = FormData.fromMap({
        'title': realEstateDetails.title,
        'description': realEstateDetails.description,
        'price': realEstateDetails.price.toString(),
        'mainCategory': realEstateDetails.mainCategory,
        'subCategory': realEstateDetails.subCategory,
        'location': realEstateDetails.location,
        'latitude': realEstateDetails.latitude,
        'longitude': realEstateDetails.longitude,
        'condition': realEstateDetails.condition,
        'listingAction': realEstateDetails.listingAction,
        // Send these fields separately instead of JSON
        'sellerType': realEstateDetails.sellerType,
        'area': realEstateDetails.details.totalArea?.toString(),
        'bathrooms': realEstateDetails.details.bathrooms?.toString(),
        'bedrooms': realEstateDetails.details.bedrooms?.toString(),
        // Keep other fields as JSON in details
        'details': jsonEncode({
          'realEstate': {
            ...realEstateDetails.details.toJson(),
            // Remove the fields that are now sent separately
          }..removeWhere((key, value) => ['totalArea', 'bathrooms', 'bedrooms'].contains(key)),
        }),
        'listingImage': await Future.wait(
          realEstateDetails.listingImage.map((filePath) async {
            final mimeType = lookupMimeType(filePath) ?? 'image/jpeg';
            return await MultipartFile.fromFile(
              filePath,
              contentType: MediaType.parse(mimeType),
              filename: basename(filePath),
            );
          }),
        ),
      });

      final response = await _dio.post(
        createListingRoute,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = CreateRealEstateListing.fromJson(response.data);
        return ApiResponse.success(model);
      } else {
         final apiError = ApiError.fromJson(response.data);
        return ApiResponse.failure(apiError);
      }
    } on DioException catch (e) {
        final apiError = e.response?.data != null ? ApiError.fromJson(e.response!.data) : ApiError();
        return ApiResponse.failure(apiError);
    } catch (e) {
      return ApiResponse.failure(ApiError());
    }
  }

  Future<ApiResponse<CreateCarListing>> createCarListingService(
    String accessToken,
    car_listing.VehicleModel carModel,
  ) async {
    try {
      print("\n📡 === CREATE LISTING SERVICE START ===");
      print("🔐 Access Token: ${accessToken.isNotEmpty ? 'Present (${accessToken.length} chars)' : 'Missing'}");
      
      print("\n📋 RECEIVED CAR MODEL:");
      print("  Type: ${carModel.runtimeType}");
      print("  Title: '${carModel.title}'");
      print("  Description: '${carModel.description}'");
      print("  Price: ${carModel.price}");
      print("  Main Category: '${carModel.mainCategory}'");
      print("  Sub Category: '${carModel.subCategory}'");
      print("  Location: '${carModel.location}'");
      print("  Latitude: ${carModel.latitude}");
      print("  Longitude: ${carModel.longitude}");
      print("  Condition: '${carModel.condition}'");
      print("  Listing Action: '${carModel.listingAction}'");
      print("  Seller Type: '${carModel.sellerType}'");
      print("  Images count: ${carModel.listingImage.length}");
      
      print("\n🔍 DETAILS ANALYSIS:");
      print("  Details type: ${carModel.details.runtimeType}");
      print("  Details.json type: ${carModel.details.json.runtimeType}");
      print("  Details.json keys: ${carModel.details.json.keys.toList()}");
      print("  Full details content: ${carModel.details.json}");
      
      print("\n🔧 EXTRACTING VEHICLE FIELDS FROM NESTED STRUCTURE:");
      final vehicleData = carModel.details.json['vehicles'] as Map<String, dynamic>?;
      if (vehicleData != null) {
        print("  ✅ Vehicle data found in nested structure");
        print("  Raw make: '${vehicleData['make']}'");
        print("  Raw model: '${vehicleData['model']}'");
        print("  Raw year: '${vehicleData['year']}'");
        print("  Raw mileage: '${vehicleData['mileage']}'");
        print("  Raw horsepower: '${vehicleData['horsepower']}'");
        print("  Raw fuelType: '${vehicleData['fuelType']}'");
        print("  Raw transmission: '${vehicleData['transmission']}'");
        print("  Raw bodyType: '${vehicleData['bodyType']}'");
        print("  Raw exteriorColor: '${vehicleData['exteriorColor']}'");
        print("  Raw accidentFree: '${vehicleData['accidentFree']}'");
        print("  Raw doors: '${vehicleData['doors']}'");
        print("  Raw seatingCapacity: '${vehicleData['seatingCapacity']}'");
        print("  Raw interiorColor: '${vehicleData['interiorColor']}'");
        
        print("\n🔄 MAPPED VALUES:");
        print("  Mapped fuelType: '${_mapFuelType(vehicleData['fuelType'])}'");
        print("  Mapped transmission: '${_mapTransmissionType(vehicleData['transmission'])}'");
        print("  Mapped sellerType: '${_mapSellerType(carModel.sellerType)}'");
        print("  Mapped listingAction: '${_mapListingAction(carModel.listingAction)}'");
      } else {
        print("  ❌ No vehicle data found in nested structure!");
        print("  Available keys: ${carModel.details.json.keys.toList()}");
      }

      print("\n🏗️ BUILDING FORM DATA:");
      // Extract vehicle fields directly from nested structure and add to root level
      
      final Map<String, dynamic> formFields = {
        'title': carModel.title,
        'description': carModel.description,
        'price': carModel.price.toString(),
        'mainCategory': carModel.mainCategory,
        'subCategory': carModel.subCategory,
        'location': carModel.location,
        'latitude': carModel.latitude,
        'longitude': carModel.longitude,
        'condition': carModel.condition,
        'listingAction': _mapListingAction(carModel.listingAction),
        'sellerType': _mapSellerType(carModel.sellerType),
      };
      
      // Add ALL vehicle fields from nested structure OR fallback to controller values
      if (vehicleData != null) {
        print("\n🔧 ADDING VEHICLE FIELDS TO FORM:");
        // Always add fields if they exist, let backend handle null/empty values
        _addFieldIfExists(formFields, 'make', vehicleData['make']);
        _addFieldIfExists(formFields, 'model', vehicleData['model']);
        _addFieldIfExists(formFields, 'year', vehicleData['year']);
        _addFieldIfExists(formFields, 'bodyType', vehicleData['bodyType']);
        _addFieldIfExists(formFields, 'exteriorColor', vehicleData['exteriorColor']);
        _addFieldIfExists(formFields, 'interiorColor', vehicleData['interiorColor']);
        _addFieldIfExists(formFields, 'engineSize', vehicleData['engineSize']);
        _addFieldIfExists(formFields, 'mileage', vehicleData['mileage']);
        _addFieldIfExists(formFields, 'horsepower', vehicleData['horsepower']);
        _addFieldIfExists(formFields, 'doors', vehicleData['doors']);
        _addFieldIfExists(formFields, 'seatingCapacity', vehicleData['seatingCapacity']);
        _addFieldIfExists(formFields, 'registrationExpiry', vehicleData['registrationExpiry']);
        
        // Handle mapped fields
        if (vehicleData['fuelType'] != null) {
          formFields['fuelType'] = _mapFuelType(vehicleData['fuelType']);
          print("  ✅ Added fuelType: ${formFields['fuelType']}");
        }
        if (vehicleData['transmission'] != null) {
          formFields['transmission'] = _mapTransmissionType(vehicleData['transmission']);
          print("  ✅ Added transmission: ${formFields['transmission']}");
        }
        if (vehicleData['accidentFree'] != null) {
          formFields['accidental'] = vehicleData['accidentFree'] == true ? 'no' : 'yes';
          print("  ✅ Added accidental: ${formFields['accidental']}");
        }
      } else {
        print("\n❌ NO VEHICLE DATA FOUND - TRYING DIRECT EXTRACTION:");
        // Fallback: try to get fields directly from the main details object
        final mainDetails = carModel.details.json;
        print("  Main details keys: ${mainDetails.keys.toList()}");
        print("  Full details content: $mainDetails");
        
        // Try to extract from controller directly as fallback
        print("\n🔄 FALLBACK: EXTRACTING FROM CONTROLLER:");
        final controller = GetX.Get.find<ListingInputController>();
        
        _addFieldIfExists(formFields, 'make', controller.make.value);
        _addFieldIfExists(formFields, 'model', controller.model.value);
        _addFieldIfExists(formFields, 'year', controller.year.value);
        _addFieldIfExists(formFields, 'bodyType', controller.bodyType.value);
        _addFieldIfExists(formFields, 'exteriorColor', controller.exteriorColor.value);
        _addFieldIfExists(formFields, 'interiorColor', controller.interiorColor.value);
        _addFieldIfExists(formFields, 'engineSize', controller.engineSize.value);
        _addFieldIfExists(formFields, 'mileage', controller.mileage.value);
        _addFieldIfExists(formFields, 'horsepower', controller.horsepower.value);
        _addFieldIfExists(formFields, 'doors', controller.doors.value);
        _addFieldIfExists(formFields, 'seatingCapacity', controller.seatingCapacity.value);
        
        // Handle mapped fields from controller
        if (controller.fuelType.value.isNotEmpty) {
          formFields['fuelType'] = _mapFuelType(controller.fuelType.value);
          print("  ✅ Added fuelType from controller: ${formFields['fuelType']}");
        }
        if (controller.transmissionType.value.isNotEmpty) {
          formFields['transmission'] = _mapTransmissionType(controller.transmissionType.value);
          print("  ✅ Added transmission from controller: ${formFields['transmission']}");
        }
        if (controller.accidental.value.isNotEmpty) {
          formFields['accidental'] = controller.accidental.value == "No" ? 'no' : 'yes';
          print("  ✅ Added accidental from controller: ${formFields['accidental']}");
        }
      }
      
      print("\n🚀 FINAL FORM FIELDS TO SEND:");
      formFields.forEach((key, value) {
        print("  '$key': '$value'");
      });
      print("  Total form fields: ${formFields.length}");

      print("\n📦 CREATING MULTIPART FORM DATA:");
      final formData = FormData.fromMap({
        ...formFields,
        // Keep only features and non-main fields in details JSON
        'details': jsonEncode({
          'vehicles': {
            'vehicleType': carModel.subCategory.toUpperCase(),
            // Keep features and advanced fields that don't have dedicated database columns
            'previousOwners': carModel.details.json['vehicles']?['previousOwners'],
            'registrationStatus': carModel.details.json['vehicles']?['registrationStatus'],
            'serviceHistory': carModel.details.json['vehicles']?['serviceHistory'],
            'warranty': carModel.details.json['vehicles']?['warranty'],
            'customsCleared': carModel.details.json['vehicles']?['customsCleared'],
            'airbags': carModel.details.json['vehicles']?['airbags'],
            'abs': carModel.details.json['vehicles']?['abs'],
            'tractionControl': carModel.details.json['vehicles']?['tractionControl'],
            'laneAssist': carModel.details.json['vehicles']?['laneAssist'],
            'features': carModel.details.json['vehicles']?['features'],
            'driveType': carModel.details.json['vehicles']?['driveType'],
            'wheelSize': carModel.details.json['vehicles']?['wheelSize'],
            'wheelType': carModel.details.json['vehicles']?['wheelType'],
            'fuelEfficiency': carModel.details.json['vehicles']?['fuelEfficiency'],
            'emissionClass': carModel.details.json['vehicles']?['emissionClass'],
            'parkingSensor': carModel.details.json['vehicles']?['parkingSensor'],
            'parkingBreak': carModel.details.json['vehicles']?['parkingBreak'],
          }
        }),
        'listingImage': await Future.wait(
          carModel.listingImage.map((filePath) async {
            final mimeType = lookupMimeType(filePath) ?? 'image/jpeg';
            print("  📸 Adding image: ${basename(filePath)} (${mimeType})");
            return await MultipartFile.fromFile(
              filePath,
              contentType: MediaType.parse(mimeType),
              filename: basename(filePath),
            );
          }),
        ),
      });
      
      print("  ✅ FormData created with ${formData.fields.length} fields and ${formData.files.length} files");

      final response = await _dio.post(
        createListingRoute,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("\n📡 === API CALL COMPLETED ===");
      print("📊 Response status: ${response.statusCode}");
      print("📊 Response headers: ${response.headers}");
      print("📊 Response data type: ${response.data.runtimeType}");
      print("📊 Response data: ${response.data}");
      
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap.containsKey('data')) {
          final dataMap = responseMap['data'] as Map<String, dynamic>?;
          if (dataMap != null && dataMap.containsKey('details')) {
            print("\n🔍 BACKEND SAVED DETAILS:");
            print("  Backend details: ${dataMap['details']}");
            if (dataMap['details'] is Map<String, dynamic>) {
              final detailsMap = dataMap['details'] as Map<String, dynamic>;
              if (detailsMap.containsKey('vehicles')) {
                print("  Backend vehicles data: ${detailsMap['vehicles']}");
              }
            }
          }
        }
      }

      if (response.statusCode == 201) {
        print("\n✅ === SUCCESS: Listing created successfully ===");
        print("🎉 Success response: ${response.data}");

        // Handle case where response.data might be a String instead of Map
        Map<String, dynamic> responseMap;
        if (response.data is String) {
          try {
            responseMap = json.decode(response.data);
            print("Successfully parsed string response as JSON: $responseMap");
          } catch (e) {
            print("=== ERROR: Failed to parse string response as JSON ===");
            print("Error: $e");
            print("Error type: ${e.runtimeType}");
            print("Raw response data: ${response.data}");
            return ApiResponse.failure(ApiError(
              fastifyErrorResponse: null, 
              errorResponse: null
            ));
          }
        } else if (response.data is Map<String, dynamic>) {
          responseMap = response.data;
          print("Response is already Map<String, dynamic>: $responseMap");
        } else {
          print("=== ERROR: Unexpected response data type ===");
          print("Error response: ${response.data}");
          print("Error response type: ${response.data.runtimeType}");
          return ApiResponse.failure(ApiError(
            fastifyErrorResponse: null, 
            errorResponse: null
          ));
        }
        
        final model = CreateCarListing.fromJson(responseMap);
        return ApiResponse.success(model);
      } else {
        print("=== ERROR: API returned status ${response.statusCode} ===");
        print("Error Response: ${response.data}");
        print("Error Response Type: ${response.data.runtimeType}");
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {
      print("=== DIO EXCEPTION ===");
      print("DioException occurred: ${dioError.message}");
      print("DioException type: ${dioError.type}");
      print("DioException response: ${dioError.response}");
      print("DioException status code: ${dioError.response?.statusCode}");
      print("DioException response data: ${dioError.response?.data}");
      print("DioException request URL: ${dioError.requestOptions.path}");
      print("DioException request method: ${dioError.requestOptions.method}");
      
      if (dioError.response != null && dioError.response?.data != null) {
        print("Processing error response from server...");
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      print("DioException has no response data, returning generic error");
      return ApiResponse.failure(ApiError(fastifyErrorResponse: null, errorResponse: null));
    } catch (e) {
      print("\n❌ === ERROR CREATING CAR LISTING ===");
      print("🚨 Error type: ${e.runtimeType}");
      print("🚨 Error message: $e");
      if (e is DioException) {
        print("🚨 Dio error type: ${e.type}");
        print("🚨 Dio response: ${e.response?.data}");
        print("🚨 Dio status code: ${e.response?.statusCode}");
      }
      return ApiResponse.failure(ApiError(fastifyErrorResponse: null, errorResponse: null));
    }
  }

  // Helper method to map listing action
  String _mapListingAction(String? listingAction) {
    if (listingAction == null) return 'SALE';
    
    switch (listingAction.toUpperCase()) {
      case 'FOR_SALE':
        return 'SALE';
      case 'FOR_RENT':
        return 'RENT';
      case 'SEARCHING':
      case 'WANTED':
        return 'SEARCHING';
      default:
        return 'SALE';
    }
  }

  // Helper method to map seller type
  String _mapSellerType(String? sellerType) {
    if (sellerType == null) return 'INDIVIDUAL';
    
    switch (sellerType.toLowerCase()) {
      case 'owner':
      case 'individual':
        return 'INDIVIDUAL';
      case 'broker':
      case 'dealer':
        return 'DEALER';
      case 'business':
      case 'business_owner':
      case 'businessowner':
        return 'BUSINESS';
      default:
        return 'INDIVIDUAL';
    }
  }

  // Helper method to map transmission type
  String _mapTransmissionType(String? transmissionType) {
    if (transmissionType == null) return 'MANUAL';
    
    switch (transmissionType.toLowerCase()) {
      case 'automatic':
      case 'أوتوماتيك':
        return 'AUTOMATIC';
      case 'manual':
      case 'يدوي':
        return 'MANUAL';
      case 'continuouslyvariable':
      case 'continuously_variable':
      case 'cvt':
        return 'AUTOMATIC_MANUAL'; // Map CVT to valid enum
      case 'automaticmanual':
      case 'automatic_manual':
        return 'AUTOMATIC_MANUAL';
      default:
        return 'MANUAL';
    }
  }

  // Helper method to map fuel type
  String _mapFuelType(String? fuelType) {
    if (fuelType == null) return 'GASOLINE';
    
    switch (fuelType.toLowerCase()) {
      case 'gasoline':
      case 'petrol':
      case 'بنزين':
        return 'GASOLINE';
      case 'diesel':
      case 'ديزل':
        return 'DIESEL';
      case 'electric':
      case 'كهربائي':
        return 'ELECTRIC';
      case 'hybrid':
      case 'هجين':
        return 'HYBRID';
      case 'lpg':
        return 'LPG';
      case 'cng':
        return 'CNG';
      default:
        return 'GASOLINE';
    }
  }

  // Helper method to add field only if it exists and is not empty
  void _addFieldIfExists(Map<String, dynamic> formFields, String key, dynamic value) {
    if (value != null && value.toString().isNotEmpty && value.toString() != '0') {
      formFields[key] = value.toString();
      print("    ✅ Added $key: '${value.toString()}'");
    } else {
      print("    ❌ Skipped $key: '$value' (null/empty/zero)");
    }
  }

}

class Details {
  final String vehicleType;
  final String make;
  final String model;
  final String year;
  final int mileage;
  final int previousOwners;
  final int horsepower;

  final String transmissionType;
  final String fuelType;
  final String color;
  final String registrationStatus;
  final String registrationExpiry;
  final List<String> serviceHistory;
  final String warranty;
  final bool accidentFree;
  final bool customsCleared;
  final int airbags;
  final bool abs;
  final bool tractionControl;
  final bool laneAssist;
  final List<String> features;
  final String driveType;
  final String bodyType;
  final String wheelSize;
  final String wheelType;
  final String fuelEfficiency;
  final String emissionClass;
  final String parkingSensor;
  final String parkingBreak;

  Details({
    required this.vehicleType,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.previousOwners,
    required this.horsepower,

    required this.transmissionType,
    required this.fuelType,
    required this.color,
    required this.registrationStatus,
    required this.registrationExpiry,
    required this.serviceHistory,
    required this.warranty,
    required this.accidentFree,
    required this.customsCleared,
    required this.airbags,
    required this.abs,
    required this.tractionControl,
    required this.laneAssist,
    required this.features,
    required this.driveType,
    required this.bodyType,
    required this.wheelSize,
    required this.wheelType,
    required this.fuelEfficiency,
    required this.emissionClass,
    required this.parkingSensor,
    required this.parkingBreak,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      vehicleType: json['vehicleType'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      mileage: json['mileage'],
      previousOwners: json['previousOwners'],
      horsepower: json['horsepower'],

      transmissionType: json['transmissionType'],
      fuelType: json['fuelType'],
      color: json['color'],
      registrationStatus: json['registrationStatus'],
      registrationExpiry: json['registrationExpiry'],
      serviceHistory: List<String>.from(json['serviceHistory'] ?? []),
      warranty: json['warranty'],
      accidentFree: json['accidentFree'],
      customsCleared: json['customsCleared'],
      airbags: json['airbags'],
      abs: json['abs'],
      tractionControl: json['tractionControl'],
      laneAssist: json['laneAssist'],
      features: List<String>.from(json['features'] ?? []),
      driveType: json['driveType'],
      bodyType: json['bodyType'],
      wheelSize: json['wheelSize'],
      wheelType: json['wheelType'],
      fuelEfficiency: json['fuelEfficiency'],
      emissionClass: json['emissionClass'],
      parkingSensor: json['parkingSensor'],
      parkingBreak: json['parkingBreak'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
      'previousOwners': previousOwners,
      'horsepower': horsepower,

      'transmissionType': transmissionType.toString().toUpperCase(),
      'fuelType': fuelType.toString().toUpperCase(),
      'color': color,
      'registrationStatus': registrationStatus,
      'registrationExpiry': registrationExpiry,
      'serviceHistory': serviceHistory,
      'warranty': warranty,
      'accidentFree': accidentFree,
      'customsCleared': customsCleared,
      'airbags': airbags,
      'abs': abs,
      'tractionControl': tractionControl,
      'laneAssist': laneAssist,
      'features': features,
      'driveType': driveType,
      'bodyType': bodyType,
      'wheelSize': wheelSize,
      'wheelType': wheelType,
      'fuelEfficiency': fuelEfficiency,
      'emissionClass': emissionClass,
      'parkingSensor': parkingSensor,
      'parkingBreak': parkingBreak,
    };
  }

  @override
  String toString() {
    return 'Details(vehicleType: $vehicleType, make: $make, model: $model, year: $year, mileage: $mileage, previousOwners: $previousOwners, horsepower: $horsepower, transmissionType: $transmissionType, fuelType: $fuelType, color: $color, registrationStatus: $registrationStatus, registrationExpiry: $registrationExpiry, serviceHistory: $serviceHistory, warranty: $warranty, accidentFree: $accidentFree, customsCleared: $customsCleared, airbags: $airbags, abs: $abs, tractionControl: $tractionControl, laneAssist: $laneAssist, features: $features, driveType: $driveType, bodyType: $bodyType, wheelSize: $wheelSize, wheelType: $wheelType, fuelEfficiency: $fuelEfficiency, emissionClass: $emissionClass, parkingSensor: $parkingSensor, parkingBreak: $parkingBreak)';
  }
}

// Commercial Vehicle Model for VANS, BUSES, TRACTORS
class CommercialVehicleModel {
  final String title;
  final String description;
  final double price;
  final String mainCategory;
  final String subCategory;
  final String vehicleSubtype; // VANS, BUSES, TRACTORS
  final String location;
  final double latitude;
  final double longitude;
  final String condition;
  final String listingAction;
  final String sellerType;
  final List<String> listingImage;
  final CommercialDetails details;

  CommercialVehicleModel({
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.vehicleSubtype,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.condition,
    required this.listingAction,
    required this.sellerType,
    required this.listingImage,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'vehicleSubtype': vehicleSubtype,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'condition': condition,
      'listingAction': listingAction,
      'sellerType': sellerType,
      'listingImage': listingImage,
      'details': details.toJson(),
    };
  }

  @override
  String toString() {
    return 'CommercialVehicleModel(title: $title, description: $description, price: $price, mainCategory: $mainCategory, subCategory: $subCategory, vehicleSubtype: $vehicleSubtype, location: $location, latitude: $latitude, longitude: $longitude, condition: $condition, listingAction: $listingAction, listingImage: $listingImage, details: $details)';
  }
}

// Commercial Vehicle Details for VANS, BUSES, TRACTORS
class CommercialDetails {
  final String vehicleType;
  final String vehicleSubtype; // VANS, BUSES, TRACTORS
  final String make;
  final String model;
  final int year;
  final double? mileage;
  final int? previousOwners;
  final double? engineSize;
  final String? engineNumber;
 
  final String? transmissionType;
  final String? fuelType;
  final String? color;
  final String? registrationStatus;
  final String? registrationExpiry;
  final List<String>? serviceHistory;
  final String? warranty;
  final bool? accidentFree;
  final bool? customsCleared;
  final List<String>? features;
  
  // Commercial-specific fields
  final double? payloadCapacity;
  final double? cargoVolume;
  final int? seatingCapacity;
  final int? axles;
  final double? gvw; // Gross Vehicle Weight
  final bool? airConditioning;
  final bool? powerSteering;
  final String? bodyType;

  CommercialDetails({
    required this.vehicleType,
    required this.vehicleSubtype,
    required this.make,
    required this.model,
    required this.year,
    this.mileage,
    this.previousOwners,
    this.engineSize,
    this.engineNumber,
    this.transmissionType,
    this.fuelType,
    this.color,
    this.registrationStatus,
    this.registrationExpiry,
    this.serviceHistory,
    this.warranty,
    this.accidentFree,
    this.customsCleared,
    this.features,
    this.payloadCapacity,
    this.cargoVolume,
    this.seatingCapacity,
    this.axles,
    this.gvw,
    this.airConditioning,
    this.powerSteering,
    this.bodyType,
  });

  factory CommercialDetails.fromJson(Map<String, dynamic> json) {
    return CommercialDetails(
      vehicleType: json['vehicleType'],
      vehicleSubtype: json['vehicleSubtype'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      mileage: json['mileage']?.toDouble(),
      previousOwners: json['previousOwners'],
      engineSize: json['engineSize']?.toDouble(),
      engineNumber: json['engineNumber'],
 
      transmissionType: json['transmissionType'],
      fuelType: json['fuelType'],
      color: json['color'],
      registrationStatus: json['registrationStatus'],
      registrationExpiry: json['registrationExpiry'],
      serviceHistory: json['serviceHistory'] != null 
          ? List<String>.from(json['serviceHistory']) 
          : null,
      warranty: json['warranty'],
      accidentFree: json['accidentFree'],
      customsCleared: json['customsCleared'],
      features: json['features'] != null 
          ? List<String>.from(json['features']) 
          : null,
      payloadCapacity: json['payloadCapacity']?.toDouble(),
      cargoVolume: json['cargoVolume']?.toDouble(),
      seatingCapacity: json['seatingCapacity'],
      axles: json['axles'],
      gvw: json['gvw']?.toDouble(),
      airConditioning: json['airConditioning'],
      powerSteering: json['powerSteering'],
      bodyType: json['bodyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'vehicleSubtype': vehicleSubtype,
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
      'previousOwners': previousOwners,
      'engineSize': engineSize,
      'engineNumber': engineNumber,
 
      'transmissionType': transmissionType?.toString().toUpperCase(),
      'fuelType': fuelType?.toString().toUpperCase(),
      'color': color,
      'registrationStatus': registrationStatus,
      'registrationExpiry': registrationExpiry,
      'serviceHistory': serviceHistory,
      'warranty': warranty,
      'accidentFree': accidentFree,
      'customsCleared': customsCleared,
      'features': features,
      'payloadCapacity': payloadCapacity,
      'cargoVolume': cargoVolume,
      'seatingCapacity': seatingCapacity,
      'axles': axles,
      'gvw': gvw,
      'airConditioning': airConditioning,
      'powerSteering': powerSteering,
      'bodyType': bodyType,
    };
  }

  @override
  String toString() {
    return 'CommercialDetails(vehicleType: $vehicleType, vehicleSubtype: $vehicleSubtype, make: $make, model: $model, year: $year, mileage: $mileage, previousOwners: $previousOwners, engineSize: $engineSize, engineNumber: $engineNumber, transmissionType: $transmissionType, fuelType: $fuelType, color: $color, registrationStatus: $registrationStatus, registrationExpiry: $registrationExpiry, serviceHistory: $serviceHistory, warranty: $warranty, accidentFree: $accidentFree, customsCleared: $customsCleared, features: $features, payloadCapacity: $payloadCapacity, cargoVolume: $cargoVolume, seatingCapacity: $seatingCapacity, axles: $axles, gvw: $gvw, airConditioning: $airConditioning, powerSteering: $powerSteering, bodyType: $bodyType)';
  }
}
