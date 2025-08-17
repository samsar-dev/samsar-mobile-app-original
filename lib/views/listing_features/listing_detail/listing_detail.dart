import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/chat/chat_controller.dart';
import 'package:samsar/controllers/listing/individual_listing_detail_controller.dart';
import 'package:samsar/helpers/date_format_convert.dart';
import 'package:samsar/services/chat/chat_service.dart';
import 'package:samsar/utils/listing_id_formatter.dart';
import 'package:samsar/views/chats/chat_view.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:samsar/widgets/image_slider/image_slider.dart';

class ListingDetail extends StatefulWidget {
  final String listingId;
  const ListingDetail({super.key, required this.listingId});

  @override
  State<ListingDetail> createState() => _ListingDetailState();
}

class _ListingDetailState extends State<ListingDetail> {


  final IndividualListingDetailController _detailController = Get.put(IndividualListingDetailController());

  @override
  void initState() {
    super.initState();
    _detailController.fetchListingDetail(widget.listingId);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () {

          if(_detailController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(_detailController.listingDetail.value == null) {
            return Center(
              child: Text("No data for listing is available"),
            );
          }

          final listing = _detailController.listingDetail.value!.data;

          final String createdDate = formatDateToDMY(listing?.createdAt.toString() ?? "");

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "listing_picture_${listing?.id ?? 'NA'}",
                  child: ImageSlider(
                    imageUrls: listing!.images,
                    listingId: listing.id ?? "NA"
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Listing ID Display
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: blueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: blueColor, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.tag, color: blueColor, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'ID: ${ListingIdFormatter.getDisplayId(listing.displayId, listing.id ?? "")}',
                              style: TextStyle(
                                color: blueColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        listing.title ?? "NA",
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.055,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        "\$${listing.price}",
                        style: TextStyle(
                          color: blueColor,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      // Seller Type Display
                      if (listing.sellerType != null && listing.sellerType!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: listing.sellerType == 'owner' 
                                ? Colors.green.withOpacity(0.1)
                                : listing.sellerType == 'broker'
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: listing.sellerType == 'owner' 
                                  ? Colors.green
                                  : listing.sellerType == 'broker'
                                      ? Colors.orange
                                      : Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                listing.sellerType == 'owner' 
                                    ? Icons.person
                                    : listing.sellerType == 'broker'
                                        ? Icons.real_estate_agent
                                        : Icons.business,
                                color: listing.sellerType == 'owner' 
                                    ? Colors.green
                                    : listing.sellerType == 'broker'
                                        ? Colors.orange
                                        : Colors.blue,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                listing.sellerType == 'owner' 
                                    ? 'ad_owner'.tr
                                    : listing.sellerType == 'broker'
                                        ? 'broker'.tr
                                        : 'business_firm'.tr,
                                style: TextStyle(
                                  color: listing.sellerType == 'owner' 
                                      ? Colors.green
                                      : listing.sellerType == 'broker'
                                          ? Colors.orange
                                          : Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Icon(Icons.location_pin, color: greyColor, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              listing.location ?? "NA",
                              style: TextStyle(color: greyColor, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 100,
                        child: DetailSectionCard(
                          title: "Description",
                          useTwoColumns: false,
                          items: [
                            IconLabelPair(
                              Icons.description,
                              listing.description ?? "NA",
                            ),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      // Reusable Cards
                      AnimatedInputWrapper(
                        delayMilliseconds: 200,
                        child: DetailSectionCard(
                          title: "Essential Details",
                          items: [
                            IconLabelPair(FontAwesomeIcons.car, listing.details?.vehicles?.make ?? "NA"),
                            IconLabelPair(FontAwesomeIcons.car, listing.details?.vehicles?.model ?? "NA"),
                            IconLabelPair(FontAwesomeIcons.calendar, listing.details?.vehicles?.year.toString() ?? "NA"),
                            IconLabelPair(FontAwesomeIcons.gear, listing.details?.vehicles?.transmissionType ?? "NA"),
                            IconLabelPair(Icons.speed, "${listing.details?.vehicles?.mileage ?? 00} KMPL"),
                            IconLabelPair(Icons.local_gas_station, listing.details?.vehicles?.fuelType ?? "NA"),
                            IconLabelPair(Icons.all_inclusive, listing.details?.vehicles?.driveType ?? "NA"),
                            IconLabelPair(Icons.sports_motorsports, listing.details?.vehicles?.bodyStyle ?? "NA"),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 300,
                        child: DetailSectionCard(
                          title: "Colors",
                          items: [
                            IconLabelPair(
                              Icons.directions_car_filled, 
                              "Exterior color",
                              colorHex: listing.details?.vehicles?.color,
                            ),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 400,
                        child: DetailSectionCard(
                          title: "Performance",
                          items: [
                            IconLabelPair(Icons.flash_on, "${listing.details?.vehicles?.horsepower} HP"),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 500,
                        child: DetailSectionCard(
                          title: "Condition and Ownership",
                          items: [
                            IconLabelPair(Icons.tune, "Condition: ${listing.details?.vehicles?.condition}"),
                            IconLabelPair(Icons.person, "Previous owners: ${listing.details?.vehicles?.previousOwners}"),
                            IconLabelPair(Icons.verified_user, "Warranty: ${listing.details?.vehicles?.warranty} Months"),
                            IconLabelPair(Icons.flight_land, "Imported: ${listing.details?.vehicles?.importStatus}"),
                            IconLabelPair(Icons.gavel, "Custom: ${listing.details?.vehicles?.customsCleared}"),
                          ],
                          useTwoColumns: false,
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 600,
                        child: DetailSectionCard(
                          title: "Airbags & Breaking",
                          items: [
                            IconLabelPair(Icons.directions_car, "Front airbags: ${
                              listing.details?.vehicles?.frontAirbags != null && listing.details?.vehicles?.frontAirbags == true
                              ? "Present" : "Not present"}"),
                            IconLabelPair(Icons.airline_seat_recline_extra, "Side airbags: ${
                              listing.details?.vehicles?.sideAirbags != null && listing.details?.vehicles?.sideAirbags == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.window, "Curtain airbags: ${
                              listing.details?.vehicles?.curtainAirbags != null && listing.details?.vehicles?.curtainAirbags == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.accessibility_new, "Knee airbags: ${
                              listing.details?.vehicles?.kneeAirbags != null && listing.details?.vehicles?.kneeAirbags == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.gpp_maybe, "Automatic Emergency breaking: ${
                              listing.details?.vehicles?.automaticEmergencyBraking != null 
                              && listing.details?.vehicles?.automaticEmergencyBraking == true
                              ? "Present" : "Not present"
                            }"),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 700,
                        child: DetailSectionCard(
                          title: "Assit & Controls",
                          items: [
                            IconLabelPair(Icons.speed, "Cruise control: ${
                              listing.details?.vehicles?.cruiseControl != null && listing.details?.vehicles?.cruiseControl == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.radar, "AdaptiveCruise control: ${
                              listing.details?.vehicles?.adaptiveCruiseControl != null 
                              && listing.details?.vehicles?.adaptiveCruiseControl == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.swap_calls, "Lane departure warning: ${
                              listing.details?.vehicles?.laneDepartureWarning != null 
                              && listing.details?.vehicles?.laneDepartureWarning == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.center_focus_strong, "Lane keep assist: ${
                              listing.details?.vehicles?.laneKeepAssist != null 
                              && listing.details?.vehicles?.laneKeepAssist == true
                              ? "Present" : "Not present"
                            }"),
                            IconLabelPair(Icons.navigation, "Navigation system: ${listing.details?.vehicles?.navigationSystem}"),
                            IconLabelPair(Icons.roofing, listing.details?.vehicles?.roofType ?? "NA"),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 800,
                        child: DetailSectionCard(
                          title: "Additional Info",
                          items: [
                            IconLabelPair(Icons.build, "Service history: ${listing.details?.vehicles?.serviceHistory}"),
                            IconLabelPair(Icons.description, "Service history notes: ${
                              listing.details?.vehicles?.serviceHistoryDetails}"),
                            IconLabelPair(Icons.note_alt_outlined, "Additional notes: ${listing.details?.vehicles?.additionalNotes}"),
                            IconLabelPair(Icons.calendar_month, "Registration expiry: ${listing.details?.vehicles?.registrationExpiry}"),
                          ],
                        ),
                      ),
          
                      SizedBox(height: 16),
          
                      AnimatedInputWrapper(
                        delayMilliseconds: 900,
                        child: sellerInfo(
                          screenHeight,
                           screenWidth,
                           listing.seller?.profilePicture ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGDSuK3gg8gojbS1BjnbA4NLTjMg_hELJbpQ&s",
                           listing.seller?.username ?? "",
                           createdDate
                        ),
                      ),
          
                      SizedBox(height: 18),
          
                      Align(
                        alignment: Alignment.center,
                        child: AppButton(
                          widthSize: 0.75,
                          heightSize: 0.08,
                          buttonColor: blueColor,
                          text: "Contact Seller",
                          textColor: whiteColor,
                          onPressed: () async {
                            final sellerId = listing.seller?.id;
                            if (sellerId == null) {
                              showCustomSnackbar("Seller not found", true);
                              return;
                            }

                            // You can inject ChatController with Get.find or create if not exists
                            final chatController = Get.put(ChatController(chatService: ChatService(Dio())));

                            try {
                              final conversation = await chatController.getOrCreateConversationWithUser(sellerId);

                              if (conversation != null) {
                                chatController.selectConversation(conversation);
                                Get.to(() => ChatView(conversation: conversation));
                              } else {
                                showCustomSnackbar("Failed to start chat with seller", true);
                              }
                            } catch (e) {
                              showCustomSnackbar("Error starting chat: $e", true);
                            }
                          },
                        ),
                      ),
          
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget sellerInfo(double screenHeight, double screenWidth, String sellerImage, String sellerName, String listingDate) {
    return Card(
      color: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seller Information",
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    sellerImage,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    Text(
                      "Listing posted on $listingDate",
                      style: TextStyle(
                        fontSize: 14,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailSectionCard extends StatelessWidget {
  final String title;
  final List<IconLabelPair> items;
  final bool useTwoColumns;

  const DetailSectionCard({
    super.key,
    required this.title,
    required this.items,
    this.useTwoColumns = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    if (useTwoColumns) {
      return List.generate((items.length / 2).ceil(), (index) {
        final first = items[index * 2];
        final second = (index * 2 + 1 < items.length) ? items[index * 2 + 1] : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Expanded(child: _buildIconLabel(first)),
              const SizedBox(width: 16),
              Expanded(child: second != null ? _buildIconLabel(second) : const SizedBox()),
            ],
          ),
        );
      });
    } else {
      return items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildIconLabel(item),
              ))
          .toList();
    }
  }

  Widget _buildIconLabel(IconLabelPair pair) {
    // Check if this is a color field
    final isColorField = pair.label.toLowerCase().contains('color');
    Color? color;
    String displayText = pair.label;

    // If it's a color field and has a color code
    if (isColorField) {
      // Extract color hex from the label text if not provided directly
      final hexCode = pair.colorHex ?? pair.label.split(':').last.trim();
      
      try {
        // Handle hex codes with or without #
        String hex = hexCode.startsWith('#') ? hexCode : '#$hexCode';
        hex = hex.replaceAll('#', '').trim();
        
        // Handle 3-digit hex codes (expand to 6 digits)
        if (hex.length == 3) {
          hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
        }
        
        // Handle 6 or 8 digit hex codes
        if (hex.length == 6 || hex.length == 8) {
          color = Color(int.parse('FF$hex', radix: 16));
          // Update display text to remove the hex code if it was in the label
          if (pair.colorHex == null) {
            displayText = '${pair.label.split(':').first}: ';
          }
        }
      } catch (e) {
        // If parsing fails, just show the text as is
        debugPrint('Error parsing color: $e');
      }
    }

    return Row(
      children: [
        FaIcon(pair.icon, color: blueColor, size: 18),
        const SizedBox(width: 6),
        if (color != null) ...[  
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            displayText,
            style: TextStyle(color: blackColor, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class IconLabelPair {
  final IconData icon;
  final String label;
  final String? colorHex;

  IconLabelPair(this.icon, this.label, {this.colorHex});
}
