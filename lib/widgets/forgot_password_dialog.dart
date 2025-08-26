import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/input_field/input_field.dart';
import 'package:samsar/widgets/otp_field/otp_field.dart';
import 'package:samsar/utils/error_message_mapper.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final AuthApiServices _authApiServices = AuthApiServices();
  final PageController _pageController = PageController();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Form keys
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  // State
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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
        width: width * 0.9,
        height: height * 0.7,
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
                    "forgot_password".tr,
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
                children: [_buildEmailStep(), _buildOtpAndPasswordStep()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "enter_email_for_reset".tr,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            Text(
              "email".tr,
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
              labelText: "example_email".tr,
              controller: _emailController,
              isPassword: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "please_provide_email".tr;
                }
                if (!value.contains("@")) {
                  return "please_provide_valid_email".tr;
                }
                return null;
              },
            ),

            const Spacer(),

            AppButton(
              widthSize: 1.0,
              heightSize: 0.07,
              buttonColor: blueColor,
              text: _isLoading ? "sending".tr : "send_reset_code".tr,
              textColor: whiteColor,
              onPressed: _isLoading ? null : _sendResetCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpAndPasswordStep() {
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
                "enter_verification_code_and_new_password".tr,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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

              OtpField(widthMultiplier: 0.9, controllers: _otpControllers),

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
                  return null;
                },
              ),

              const SizedBox(height: 15),

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

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      widthSize: 1.0,
                      heightSize: 0.07,
                      buttonColor: Colors.grey,
                      text: "back".tr,
                      textColor: whiteColor,
                      onPressed: _isLoading
                          ? null
                          : () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              // Go back to email step
                            },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      widthSize: 1.0,
                      heightSize: 0.07,
                      buttonColor: blueColor,
                      text: _isLoading ? "resetting".tr : "reset_password".tr,
                      textColor: whiteColor,
                      onPressed: _isLoading ? null : _resetPassword,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetCode() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authApiServices.forgotPasswordService(
        _emailController.text.trim(),
      );

      if (response.isSuccess) {
        Get.snackbar(
          "success".tr,
          "reset_code_sent".tr,
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );

        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Handle different error types with user-friendly messages
        String errorMessage = "failed_to_send_reset_code".tr;

        if (response.apiError?.message != null) {
          final message = response.apiError!.message;

          // Check for rate limiting
          if (message.contains("Rate limit exceeded")) {
            final retryTime = ErrorMessageMapper.extractRetryTime(message);
            errorMessage = ErrorMessageMapper.getErrorMessage(
              'RATE_LIMIT_EXCEEDED',
              retryAfter: retryTime,
            );
          } else {
            // Try to extract error code from response or use message directly
            errorMessage =
                ErrorMessageMapper.getErrorMessage(null) + ": $message";
          }
        }

        Get.snackbar(
          "error".tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: whiteColor,
          duration: const Duration(
            seconds: 5,
          ), // Longer duration for rate limit messages
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

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    String otpCode = _otpControllers
        .map((controller) => controller.text)
        .join();
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
      final response = await _authApiServices.resetPasswordService(
        email: _emailController.text.trim(),
        verificationCode: otpCode,
        newPassword: _newPasswordController.text,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "success".tr,
          "password_reset_successful".tr,
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );

        Navigator.of(context).pop();
      } else {
        Get.snackbar(
          "error".tr,
          response.apiError?.message ?? "failed_to_reset_password".tr,
          backgroundColor: Colors.red,
          colorText: whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "unexpected_error".tr,
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
