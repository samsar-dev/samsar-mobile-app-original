import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  Future<void> _launchEmail(String email, String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}',
    );

    try {
      // Try to launch with external application first
      bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // Fallback: try with platform default
        launched = await launchUrl(emailUri);
      }
      
      if (!launched) {
        _showEmailFallback(email, subject);
      }
    } catch (e) {
      _showEmailFallback(email, subject);
    }
  }

  void _showEmailFallback(String email, String subject) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email_outlined,
                size: 50,
                color: blueColor,
              ),
              const SizedBox(height: 15),
              Text(
                'contact_us'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'email_app_not_found'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'email_label'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SelectableText(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blueColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'subject_label'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SelectableText(
                      subject,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'close'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'contact_support'.tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blueColor, blueColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 60,
                      color: whiteColor,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'we_are_here_to_help'.tr,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'get_in_touch_message'.tr,
                      style: TextStyle(
                        color: whiteColor.withOpacity(0.9),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Contact Options
              Text(
                'contact_options'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),

              const SizedBox(height: 20),

              // General Contact
              _buildContactCard(
                icon: Icons.email_outlined,
                title: 'general_contact'.tr,
                subtitle: 'general_contact_desc'.tr,
                email: 'contact@samsardeals.com',
                onTap: () => _launchEmail(
                  'contact@samsardeals.com',
                  'General Inquiry - Samsar App',
                ),
              ),

              const SizedBox(height: 15),

              // Technical Support
              _buildContactCard(
                icon: Icons.support_outlined,
                title: 'technical_support'.tr,
                subtitle: 'technical_support_desc'.tr,
                email: 'support@samsardeals.com',
                onTap: () => _launchEmail(
                  'support@samsardeals.com',
                  'Technical Support - Samsar App',
                ),
              ),

              const SizedBox(height: 30),

              // Additional Information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: blueColor),
                        const SizedBox(width: 10),
                        Text(
                          'response_time'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${'general_inquiries_24h'.tr}\n'
                      '${'technical_support_12h'.tr}\n'
                      '${'urgent_issues_4h'.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tips Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                        const SizedBox(width: 10),
                        Text(
                          'tips_for_better_support'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${'include_device_model'.tr}\n'
                      '${'describe_step_by_step'.tr}\n'
                      '${'attach_screenshots'.tr}\n'
                      '${'mention_account_email'.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String email,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: blueColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
