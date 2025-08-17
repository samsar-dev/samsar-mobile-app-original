import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/input_field/input_field.dart';
import 'package:samsar/widgets/otp_field/otp_field.dart';
import 'package:samsar/utils/error_message_mapper.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final AuthApiServices _authApiServices = AuthApiServices();
  final PageController _pageController = PageController();
  
  // Controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  
  // Form keys
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _verificationFormKey = GlobalKey<FormState>();
  
  // State
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width * 0.95,
        height: height * 0.75,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "change_password".tr,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: whiteColor),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPasswordStep(),
                  _buildVerificationStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _passwordFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "enter_current_and_new_password".tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              
              // Current Password Field
              Text(
                "current_password".tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              
              InputField(
                widthPercentage: 1.0,
                heightPercentage: 0.08,
                labelText: "enter_current_password".tr,
                controller: _currentPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please_provide_current_password".tr;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // New Password Field
              Text(
                "new_password".tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              
              InputField(
                widthPercentage: 1.0,
                heightPercentage: 0.08,
                labelText: "enter_new_password".tr,
                controller: _newPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please_provide_password".tr;
                  }
                  if (value.length < 6) {
                    return "password_min_6_chars".tr;
                  }
                  if (value == _currentPasswordController.text) {
                    return "new_password_must_be_different".tr;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Confirm Password Field
              Text(
                "confirm_password".tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              
              InputField(
                widthPercentage: 1.0,
                heightPercentage: 0.08,
                labelText: "confirm_new_password".tr,
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please_confirm_password".tr;
                  }
                  if (value != _newPasswordController.text) {
                    return "passwords_do_not_match".tr;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              
              AppButton(
                widthSize: 1.0,
                heightSize: 0.07,
                buttonColor: blueColor,
                text: _isLoading ? "sending".tr : "send_verification_code".tr,
                textColor: whiteColor,
                onPressed: _isLoading ? null : _sendVerificationCode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _verificationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "enter_verification_code_to_confirm".tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            
            // OTP Field
            Text(
              "verification_code".tr,
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            
            OtpField(
              widthMultiplier: 0.8,
              controllers: _otpControllers,
            ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: blueColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "verification_code_sent_to_email".tr,
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    widthSize: 1.0,
                    heightSize: 0.07,
                    buttonColor: Colors.grey,
                    text: "back".tr,
                    textColor: whiteColor,
                    onPressed: _isLoading ? null : () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    widthSize: 1.0,
                    heightSize: 0.07,
                    buttonColor: blueColor,
                    text: _isLoading ? "changing".tr : "change_password".tr,
                    textColor: whiteColor,
                    onPressed: _isLoading ? null : _changePassword,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authApiServices.sendPasswordChangeVerificationService(
        currentPassword: _currentPasswordController.text,
      );
      
      if (response.isSuccess) {
        Get.snackbar(
          "success".tr,
          "verification_code_sent".tr,
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );
        
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        String errorMessage = "failed_to_send_verification_code".tr;
        
        if (response.apiError?.message != null) {
          final message = response.apiError!.message;
          
          // Check for rate limiting
          if (message.contains("Rate limit exceeded") || message.contains("Too many requests")) {
            final retryTime = ErrorMessageMapper.extractRetryTime(message);
            errorMessage = ErrorMessageMapper.getErrorMessage('RATE_LIMIT_EXCEEDED', retryAfter: retryTime);
          } else if (message.contains("Invalid password") || message.contains("Current password is incorrect")) {
            errorMessage = ErrorMessageMapper.getErrorMessage('INVALID_PASSWORD');
          } else if (message.contains("User email not found")) {
            errorMessage = ErrorMessageMapper.getErrorMessage('USER_NOT_FOUND');
          } else {
            errorMessage = ErrorMessageMapper.getErrorMessage(null) + ": $message";
          }
        }
        
        Get.snackbar(
          "error".tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: whiteColor,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        ErrorMessageMapper.getErrorMessage(null),
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    String otpCode = _otpControllers.map((controller) => controller.text).join();
    if (otpCode.length != 6) {
      Get.snackbar(
        "error".tr,
        "please_enter_valid_code".tr,
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authApiServices.changePasswordService(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        verificationCode: otpCode,
      );
      
      if (response.isSuccess) {
        Get.snackbar(
          "success".tr,
          "password_changed_successfully".tr,
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );
        
        Navigator.of(context).pop();
      } else {
        String errorMessage = "failed_to_change_password".tr;
        
        if (response.apiError?.message != null) {
          final message = response.apiError!.message;
          
          // Check for specific error types
          if (message.contains("Rate limit exceeded")) {
            final retryTime = ErrorMessageMapper.extractRetryTime(message);
            errorMessage = ErrorMessageMapper.getErrorMessage('RATE_LIMIT_EXCEEDED', retryAfter: retryTime);
          } else if (message.contains("Invalid verification code")) {
            errorMessage = ErrorMessageMapper.getErrorMessage('INVALID_CODE');
          } else if (message.contains("Current password is incorrect")) {
            errorMessage = ErrorMessageMapper.getErrorMessage('INVALID_PASSWORD');
          } else if (message.contains("You must be logged in")) {
            errorMessage = ErrorMessageMapper.getErrorMessage('UNAUTHORIZED');
          } else {
            errorMessage = ErrorMessageMapper.getErrorMessage(null) + ": $message";
          }
        }
        
        Get.snackbar(
          "error".tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: whiteColor,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        ErrorMessageMapper.getErrorMessage(null),
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
