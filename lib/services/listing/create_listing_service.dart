import 'dart:convert';
import 'package:samsar/models/listing/vehicle_model.dart' as car_listing;
import 'package:samsar/models/listing/real_estate_model.dart'
    as real_estate_listing;
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
        'fuelType': _mapFuelType(
          commercialDetails.details.fuelType?.toString(),
        ),
        'transmission': _mapTransmissionType(
          commercialDetails.details.transmissionType?.toString(),
        ), // Changed from transmissionType
        'exteriorColor': commercialDetails.details.color, // Changed from color
        'engineSize': commercialDetails.details.engineSize?.toString() ?? '',
        'mileage': commercialDetails.details.mileage?.toString() ?? '',
        'accidental': commercialDetails.details.accidentFree == true
            ? 'no'
            : 'yes',
        'registrationExpiry':
            commercialDetails.details.registrationExpiry ?? '',
        // Keep other fields as JSON in details
        'details': jsonEncode({
          'vehicles': {
            // vehicleType removed - it's already saved as subCategory
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
          },
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


      if (response.statusCode == 201 || response.statusCode == 200) {

        Map<String, dynamic> responseMap;
        if (response.data is String) {
          try {
            responseMap = json.decode(response.data);
          } catch (e) {
            return ApiResponse.failure(
              ApiError(fastifyErrorResponse: null, errorResponse: null),
            );
          }
        } else if (response.data is Map<String, dynamic>) {
          responseMap = response.data;
        } else {
          return ApiResponse.failure(
            ApiError(fastifyErrorResponse: null, errorResponse: null),
          );
        }

        final model = CreateCarListing.fromJson(responseMap);
        return ApiResponse.success(model);
      } else {
        return ApiResponse.failure(
          ApiError(fastifyErrorResponse: null, errorResponse: null),
        );
      }
    } catch (e) {
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
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
        'condition': realEstateDetails.condition,  // Save exact value without mapping
        'listingAction': realEstateDetails.listingAction,
        // Send these fields separately instead of JSON - match backend column names
        'sellerType': realEstateDetails.sellerType,
        'totalArea': realEstateDetails.details.totalArea?.toString(),
        'bathrooms': realEstateDetails.details.bathrooms?.toString(),
        'bedrooms': realEstateDetails.details.bedrooms?.toString(),
        'totalRooms': realEstateDetails.details.totalRooms?.toString(),
        // Only essential fields as separate columns
        'yearBuilt': realEstateDetails.details.yearBuilt?.toString(),
        'furnishing': realEstateDetails.details.furnishing,
        'floor': realEstateDetails.details.floor?.toString() ?? '',
        'totalFloors': realEstateDetails.details.totalFloors?.toString() ?? '',
        // Only include fields that have actual values (not empty/default)
        'details': jsonEncode({
          'realEstate': {
            if (realEstateDetails.details.propertyType.isNotEmpty)
              'propertyType': realEstateDetails.details.propertyType,
            if (realEstateDetails.details.parking?.isNotEmpty == true)
              'parking': realEstateDetails.details.parking,
            if (realEstateDetails.details.facing?.isNotEmpty == true)
              'facing': realEstateDetails.details.facing,
            if (realEstateDetails.details.balconies != null && realEstateDetails.details.balconies! > 0)
              'balconies': realEstateDetails.details.balconies,
            if (realEstateDetails.details.plotSize != null && realEstateDetails.details.plotSize! > 0)
              'plotSize': realEstateDetails.details.plotSize,
            if (realEstateDetails.details.garden?.isNotEmpty == true)
              'garden': realEstateDetails.details.garden,
            if (realEstateDetails.details.pool?.isNotEmpty == true)
              'pool': realEstateDetails.details.pool,
            if (realEstateDetails.details.officeType?.isNotEmpty == true)
              'officeType': realEstateDetails.details.officeType,
            if (realEstateDetails.details.zoning?.isNotEmpty == true)
              'zoning': realEstateDetails.details.zoning,
            if (realEstateDetails.details.roadAccess?.isNotEmpty == true)
              'roadAccess': realEstateDetails.details.roadAccess,
            if (realEstateDetails.details.buildingAge != null && realEstateDetails.details.buildingAge! > 0)
              'buildingAge': realEstateDetails.details.buildingAge,
            if (realEstateDetails.details.orientation?.isNotEmpty == true)
              'orientation': realEstateDetails.details.orientation,
            if (realEstateDetails.details.view?.isNotEmpty == true)
              'view': realEstateDetails.details.view,
            if (realEstateDetails.details.features != null && realEstateDetails.details.features!.isNotEmpty)
              'features': realEstateDetails.details.features,
          },
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
      final apiError = e.response?.data != null
          ? ApiError.fromJson(e.response!.data)
          : ApiError();
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



      final vehicleData =
          carModel.details.json['vehicles'] as Map<String, dynamic>?;
      if (vehicleData != null) {
        // doors and seatingCapacity moved to JSON details only

      } else {
      }

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
        // Always add fields if they exist, let backend handle null/empty values
        _addFieldIfExists(formFields, 'make', vehicleData['make']);
        _addFieldIfExists(formFields, 'model', vehicleData['model']);
        _addFieldIfExists(formFields, 'year', vehicleData['year']);
        _addFieldIfExists(formFields, 'bodyType', vehicleData['bodyType']);
        _addFieldIfExists(
          formFields,
          'exteriorColor',
          vehicleData['exteriorColor'],
        );
        _addFieldIfExists(formFields, 'engineSize', vehicleData['engineSize']);
        _addFieldIfExists(formFields, 'mileage', vehicleData['mileage']);
        _addFieldIfExists(formFields, 'horsepower', vehicleData['horsepower']);
        // doors and seatingCapacity moved to JSON details only
        _addFieldIfExists(
          formFields,
          'registrationExpiry',
          vehicleData['registrationExpiry'],
        );
        _addFieldIfExists(formFields, 'importStatus', vehicleData['importStatus']);

        // Handle mapped fields
        if (vehicleData['fuelType'] != null) {
          formFields['fuelType'] = _mapFuelType(vehicleData['fuelType']);
        }
        if (vehicleData['transmission'] != null) {
          formFields['transmission'] = _mapTransmissionType(
            vehicleData['transmission'],
          );
        }
        if (vehicleData['accidentFree'] != null) {
          formFields['accidental'] = vehicleData['accidentFree'] == true
              ? 'no'
              : 'yes';
        }
      } else {
        // Fallback: try to get fields directly from the main details object
        final mainDetails = carModel.details.json;

        // Try to extract from controller directly as fallback
        final controller = GetX.Get.find<ListingInputController>();

        _addFieldIfExists(formFields, 'make', controller.make.value);
        _addFieldIfExists(formFields, 'model', controller.model.value);
        _addFieldIfExists(formFields, 'year', controller.year.value);
        _addFieldIfExists(formFields, 'bodyType', controller.bodyType.value);
        _addFieldIfExists(
          formFields,
          'exteriorColor',
          controller.exteriorColor.value,
        );
        _addFieldIfExists(
          formFields,
          'engineSize',
          controller.engineSize.value,
        );
        _addFieldIfExists(formFields, 'mileage', controller.mileage.value);
        _addFieldIfExists(
          formFields,
          'horsepower',
          controller.horsepower.value,
        );
        _addFieldIfExists(formFields, 'importStatus', controller.importStatus.value);
        // doors and seatingCapacity moved to JSON details only

        // Handle mapped fields from controller
        if (controller.fuelType.value.isNotEmpty) {
          formFields['fuelType'] = _mapFuelType(controller.fuelType.value);
        }
        if (controller.transmissionType.value.isNotEmpty) {
          formFields['transmission'] = _mapTransmissionType(
            controller.transmissionType.value,
          );
        }
        if (controller.accidental.value.isNotEmpty) {
          formFields['accidental'] = controller.accidental.value == "No"
              ? 'no'
              : 'yes';
        }
      }

      formFields.forEach((key, value) {
      });

      final formData = FormData.fromMap({
        ...formFields,
        // Keep only features and non-main fields in details JSON - only include non-null/non-empty values
        'details': jsonEncode({
          'vehicles': {
            // vehicleType removed - it's already saved as subCategory
            // Only include fields that have actual values
            if (carModel.details.json['vehicles']?['previousOwners'] != null)
              'previousOwners': carModel.details.json['vehicles']['previousOwners'],
            if (carModel.details.json['vehicles']?['importStatus'] != null &&
                carModel.details.json['vehicles']['importStatus'].toString().isNotEmpty)
              'importStatus': carModel.details.json['vehicles']['importStatus'],
            if (carModel.details.json['vehicles']?['serviceHistory'] != null &&
                (carModel.details.json['vehicles']['serviceHistory'] as List?)?.isNotEmpty == true)
              'serviceHistory': carModel.details.json['vehicles']['serviceHistory'],
            if (carModel.details.json['vehicles']?['warranty'] != null &&
                carModel.details.json['vehicles']['warranty'].toString().isNotEmpty)
              'warranty': carModel.details.json['vehicles']['warranty'],
            if (carModel.details.json['vehicles']?['customsCleared'] == true)
              'customsCleared': carModel.details.json['vehicles']['customsCleared'],
            if (carModel.details.json['vehicles']?['airbags'] != null &&
                carModel.details.json['vehicles']['airbags'] > 0)
              'airbags': carModel.details.json['vehicles']['airbags'],
            if (carModel.details.json['vehicles']?['abs'] == true)
              'abs': carModel.details.json['vehicles']['abs'],
            if (carModel.details.json['vehicles']?['tractionControl'] == true)
              'tractionControl': carModel.details.json['vehicles']['tractionControl'],
            if (carModel.details.json['vehicles']?['laneAssist'] == true)
              'laneAssist': carModel.details.json['vehicles']['laneAssist'],
            if (carModel.details.json['vehicles']?['features'] != null &&
                (carModel.details.json['vehicles']['features'] as List?)?.isNotEmpty == true)
              'features': carModel.details.json['vehicles']['features'],
            if (carModel.details.json['vehicles']?['driveType'] != null &&
                carModel.details.json['vehicles']['driveType'].toString().isNotEmpty)
              'driveType': carModel.details.json['vehicles']['driveType'],
            if (carModel.details.json['vehicles']?['wheelSize'] != null &&
                carModel.details.json['vehicles']['wheelSize'].toString().isNotEmpty)
              'wheelSize': carModel.details.json['vehicles']['wheelSize'],
            if (carModel.details.json['vehicles']?['wheelType'] != null &&
                carModel.details.json['vehicles']['wheelType'].toString().isNotEmpty)
              'wheelType': carModel.details.json['vehicles']['wheelType'],
            if (carModel.details.json['vehicles']?['fuelEfficiency'] != null &&
                carModel.details.json['vehicles']['fuelEfficiency'].toString().isNotEmpty)
              'fuelEfficiency': carModel.details.json['vehicles']['fuelEfficiency'],
            if (carModel.details.json['vehicles']?['emissionClass'] != null &&
                carModel.details.json['vehicles']['emissionClass'].toString().isNotEmpty)
              'emissionClass': carModel.details.json['vehicles']['emissionClass'],
            if (carModel.details.json['vehicles']?['parkingSensor'] != null &&
                carModel.details.json['vehicles']['parkingSensor'].toString().isNotEmpty &&
                carModel.details.json['vehicles']['parkingSensor'].toString() != 'No')
              'parkingSensor': carModel.details.json['vehicles']['parkingSensor'],
            if (carModel.details.json['vehicles']?['parkingBreak'] != null &&
                carModel.details.json['vehicles']['parkingBreak'].toString().isNotEmpty)
              'parkingBreak': carModel.details.json['vehicles']['parkingBreak'],
          }..removeWhere((key, value) => value == null),
        }),
        'listingImage': await Future.wait(
          carModel.listingImage.map((filePath) async {
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


      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap.containsKey('data')) {
          final dataMap = responseMap['data'] as Map<String, dynamic>?;
          if (dataMap != null && dataMap.containsKey('details')) {
            if (dataMap['details'] is Map<String, dynamic>) {
              final detailsMap = dataMap['details'] as Map<String, dynamic>;
              if (detailsMap.containsKey('vehicles')) {
              }
            }
          }
        }
      }

      if (response.statusCode == 201) {

        // Handle case where response.data might be a String instead of Map
        Map<String, dynamic> responseMap;
        if (response.data is String) {
          try {
            responseMap = json.decode(response.data);
          } catch (e) {
            return ApiResponse.failure(
              ApiError(fastifyErrorResponse: null, errorResponse: null),
            );
          }
        } else if (response.data is Map<String, dynamic>) {
          responseMap = response.data;
        } else {
          return ApiResponse.failure(
            ApiError(fastifyErrorResponse: null, errorResponse: null),
          );
        }

        final model = CreateCarListing.fromJson(responseMap);
        return ApiResponse.success(model);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    } catch (e) {
      if (e is DioException) {
      }
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
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
    if (sellerType == null) return 'BROKER';

    switch (sellerType.toLowerCase()) {
      case 'owner':
        return 'OWNER';
      case 'broker':
      case 'business':
      case 'business_owner':
      case 'businessowner':
      case 'business_firm':
        return 'BUSINESS';
      default:
        return 'BROKER';
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
      default:
        return 'MANUAL';
    }
  }

  // Helper method to map fuel type
  String _mapFuelType(String? fuelType) {
    if (fuelType == null) return 'GASOLINE';

    switch (fuelType.toLowerCase()) {
      case 'benzin':
      case 'بنزين':
        return 'BENZIN';
      case 'diesel':
      case 'مازوت':
        return 'DIESEL';
      case 'electric':
      case 'كهرباء':
        return 'ELECTRIC';
      case 'hybrid':
      case 'هجين':
        return 'HYBRID';
      case 'gasoline':
      case 'غازولين':
        return 'GASOLINE';
      case 'other':
      case 'أخرى':
        return 'OTHER';
      default:
        return 'OTHER';
    }
  }



  // Helper method to add field only if it exists and is not empty
  void _addFieldIfExists(
    Map<String, dynamic> formFields,
    String key,
    dynamic value,
  ) {
    if (value != null &&
        value.toString().isNotEmpty &&
        value.toString() != '0') {
      formFields[key] = value.toString();
    } else {
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
