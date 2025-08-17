import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/widgets/otp_field/otp_field.dart';


class EmailChangeDialog extends StatefulWidget {
  final String currentEmail;
  final Function(String) onEmailChanged;

  const EmailChangeDialog({
    super.key,
    required this.currentEmail,
    required this.onEmailChanged,
  });

  @override
  State<EmailChangeDialog> createState() => _EmailChangeDialogState();
}

class _EmailChangeDialogState extends State<EmailChangeDialog> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController newEmailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  
  bool isStep1 = true; // true for email input, false for OTP verification
  bool isLoading = false;
  String? errorMessage;
  String pendingEmail = '';

  @override
  void dispose() {
    newEmailController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: blueColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'change_email'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'change_email_description'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Current Email Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'current_email'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.currentEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (isStep1) ...[
              // Step 1: New Email Input
              Text(
                'new_email'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'enter_new_email'.tr,
                  prefixIcon: Icon(Icons.email_outlined, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueColor, width: 2),
                  ),
                ),
              ),
            ] else ...[
              // Step 2: OTP Verification
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.mark_email_read, color: blueColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'email_verification_code_sent'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blueColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'email_verification_code_sent_to'.tr} $pendingEmail',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                'enter_6_digit_code'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 12),
              
              // OTP Input
              OtpField(
                controllers: otpControllers,
                widthMultiplier: 0.8,
              ),
              
              const SizedBox(height: 16),
              
              // Start Over Button
              TextButton(
                onPressed: () {
                  setState(() {
                    isStep1 = true;
                    pendingEmail = '';
                    errorMessage = null;
                    for (var controller in otpControllers) {
                      controller.clear();
                    }
                  });
                },
                child: Text(
                  'start_over'.tr,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            // Error Message
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  errorMessage!,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : () {
                  if (isStep1) {
                    _sendVerificationCode();
                  } else {
                    _verifyEmailChange();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLoading 
                    ? (isStep1 ? 'sending_verification'.tr : 'changing_email'.tr)
                    : (isStep1 ? 'send_verification_code'.tr : 'change_email'.tr),
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Security Notice
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'security_notice'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'email_change_security_notice'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    final newEmail = newEmailController.text.trim();
    
    print('🔧 EmailChangeDialog: Starting _sendVerificationCode');
    print('🔧 EmailChangeDialog: New email = $newEmail');
    print('🔧 EmailChangeDialog: Current email = ${widget.currentEmail}');
    
    // Validation
    if (newEmail.isEmpty) {
      print('❌ EmailChangeDialog: Email is empty');
      setState(() {
        errorMessage = 'email_required'.tr;
      });
      return;
    }

    if (!GetUtils.isEmail(newEmail)) {
      print('❌ EmailChangeDialog: Invalid email format');
      setState(() {
        errorMessage = 'invalid_email_format'.tr;
      });
      return;
    }

    if (newEmail.toLowerCase() == widget.currentEmail.toLowerCase()) {
      print('❌ EmailChangeDialog: Same email as current');
      setState(() {
        errorMessage = 'same_email_error'.tr;
      });
      return;
    }

    print('✅ EmailChangeDialog: Validation passed, making API call');
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authApiServices = AuthApiServices();
      print('🔧 EmailChangeDialog: Created AuthApiServices instance');
      
      final result = await authApiServices.sendEmailChangeVerificationService(newEmail);
      print('🔧 EmailChangeDialog: API call completed');
      print('🔧 EmailChangeDialog: Result isSuccess = ${result.isSuccess}');
      print('🔧 EmailChangeDialog: Result successResponse = ${result.successResponse}');
      print('🔧 EmailChangeDialog: Result apiError = ${result.apiError}');
      
      if (result.isSuccess) {
        print('✅ EmailChangeDialog: Success! Moving to step 2');
        setState(() {
          isStep1 = false;
          pendingEmail = newEmail;
          isLoading = false;
        });
      } else {
        print('❌ EmailChangeDialog: API returned error');
        print('❌ EmailChangeDialog: Error code = ${result.apiError?.errorResponse?.error?.code}');
        print('❌ EmailChangeDialog: Error message = ${result.apiError?.errorResponse?.error?.message}');
        print('❌ EmailChangeDialog: Full error response = ${result.apiError?.errorResponse}');
        
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage = _getErrorMessage(errorCode);
        print('❌ EmailChangeDialog: Translated error message = $errorMessage');
        
        setState(() {
          this.errorMessage = errorMessage;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('❌ EmailChangeDialog: Exception caught: $e');
      print('❌ EmailChangeDialog: Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'verification_send_failed'.tr;
        isLoading = false;
      });
    }
  }

  void _verifyEmailChange() async {
    final otp = otpControllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      setState(() {
        errorMessage = 'invalid_verification_code'.tr;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authApiServices = AuthApiServices();
      final result = await authApiServices.changeEmailWithVerificationService(otp);
      
      if (result.isSuccess) {
        // Success! Update the email and close dialog
        widget.onEmailChanged(pendingEmail);
        if (mounted) {
          Navigator.of(context).pop();
        }
        
        // Show success message
        Get.snackbar(
          'success'.tr,
          'email_changed_successfully'.tr,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          icon: Icon(Icons.check_circle, color: Colors.green[600]),
        );
      } else {
        setState(() {
          errorMessage = _getErrorMessage(result.apiError?.errorResponse?.error?.code);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'email_change_failed'.tr;
        isLoading = false;
      });
    }
  }

  String _getErrorMessage(String? errorCode) {
    switch (errorCode) {
      case 'INVALID_EMAIL':
        return 'invalid_email_format'.tr;
      case 'SAME_EMAIL':
        return 'same_email_error'.tr;
      case 'EMAIL_ALREADY_EXISTS':
        return 'email_already_exists'.tr;
      case 'EMAIL_SEND_FAILED':
        return 'email_change_send_failed'.tr;
      case 'INVALID_CODE':
        return 'invalid_verification_code'.tr;
      case 'CODE_EXPIRED':
        return 'verification_code_expired'.tr;
      case 'NO_PENDING_EMAIL':
        return 'no_pending_email_change'.tr;
      case 'SERVER_ERROR':
        return 'server_error'.tr;
      default:
        return 'unexpected_error'.tr;
    }
  }
}
