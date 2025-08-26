import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/otp_field/otp_field.dart';
import 'package:samsar/models/auth/login_model.dart';

class EmailChangeView extends StatefulWidget {
  final String currentEmail;

  const EmailChangeView({super.key, required this.currentEmail});

  @override
  State<EmailChangeView> createState() => _EmailChangeViewState();
}

class _EmailChangeViewState extends State<EmailChangeView> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController newEmailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  bool isStep1 = true;
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        foregroundColor: blueColor,
        title: Text(
          'change_email'.tr,
          style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),

                // Title
                Text(
                  isStep1 ? 'enter_new_email'.tr : 'verify_new_email'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),

                // Description
                Text(
                  isStep1
                      ? 'change_email_description'.tr
                      : 'email_verification_code_sent_to'.trParams({
                          'email': pendingEmail,
                        }),
                  style: TextStyle(
                    color: blackColor,
                    fontSize: screenWidth * 0.04,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Current Email Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
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

                SizedBox(height: screenHeight * 0.04),

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
                  const SizedBox(height: 12),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ] else ...[
                  // Step 2: OTP Verification
                  Text(
                    'enter_6_digit_otp'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OtpField(widthMultiplier: 0.9, controllers: otpControllers),
                ],

                SizedBox(height: screenHeight * 0.04),

                // Error Message
                if (errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Button
                AppButton(
                  widthSize: 1.0,
                  heightSize: 0.07,
                  text: isStep1 ? 'send_verification_code'.tr : 'verify'.tr,
                  textColor: whiteColor,
                  buttonColor: blueColor,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (isStep1) {
                            _sendVerificationCode();
                          } else {
                            _verifyEmailChange();
                          }
                        },
                ),

                if (!isStep1) ...[
                  SizedBox(height: screenHeight * 0.03),
                  ResendCodeSection(onResend: _sendVerificationCode),
                ],

                SizedBox(height: screenHeight * 0.03),

                // Security Notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: blueColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'email_change_security_notice'.tr,
                          style: TextStyle(fontSize: 12, color: blueColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    final newEmail = newEmailController.text.trim();

    if (newEmail.isEmpty) {
      setState(() {
        errorMessage = 'please_enter_new_email'.tr;
      });
      return;
    }

    if (!GetUtils.isEmail(newEmail)) {
      setState(() {
        errorMessage = 'please_enter_valid_email'.tr;
      });
      return;
    }

    if (newEmail == widget.currentEmail) {
      setState(() {
        errorMessage = 'new_email_same_as_current'.tr;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await AuthApiServices()
          .sendEmailChangeVerificationService(newEmail);

      if (response.isSuccess) {
        setState(() {
          isStep1 = false;
          pendingEmail = newEmail;
          isLoading = false;
        });

        Get.snackbar(
          'success'.tr,
          'verification_code_sent'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          errorMessage = _getErrorMessage(response.apiError?.message);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'unexpected_error'.tr;
        isLoading = false;
      });
    }
  }

  void _verifyEmailChange() async {
    final otp = otpControllers
        .map((controller) => controller.text.trim())
        .join();

    if (otp.length != 6) {
      setState(() {
        errorMessage = 'please_enter_valid_code'.tr;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await AuthApiServices()
          .changeEmailWithVerificationService(otp);

      if (response.isSuccess) {
        // Update the user's email in the auth controller
        if (authController.user.value != null) {
          final currentUser = authController.user.value!;
          final updatedUser = User(
            id: currentUser.id,
            email: pendingEmail,
            username: currentUser.username,
            role: currentUser.role,
            createdAt: currentUser.createdAt,
            updatedAt: currentUser.updatedAt,
            phone: currentUser.phone,
            profilePicture: currentUser.profilePicture,
            bio: currentUser.bio,
            name: currentUser.name,
            dateOfBirth: currentUser.dateOfBirth,
            street: currentUser.street,
            city: currentUser.city,
            allowMessaging: currentUser.allowMessaging,
            listingNotifications: currentUser.listingNotifications,
            messageNotifications: currentUser.messageNotifications,
            loginNotifications: currentUser.loginNotifications,
            showEmail: currentUser.showEmail,
            showOnlineStatus: currentUser.showOnlineStatus,
            showPhoneNumber: currentUser.showPhoneNumber,
            privateProfile: currentUser.privateProfile,
          );
          authController.user.value = updatedUser;
        }

        Get.back(result: pendingEmail);

        Get.snackbar(
          'success'.tr,
          'email_changed_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          errorMessage = _getErrorMessage(response.apiError?.message);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'unexpected_error'.tr;
        isLoading = false;
      });
    }
  }

  String _getErrorMessage(String? errorCode) {
    switch (errorCode) {
      case 'EMAIL_ALREADY_EXISTS':
        return 'email_already_exists'.tr;
      case 'INVALID_CODE':
        return 'invalid_code'.tr;
      case 'CODE_EXPIRED':
        return 'code_expired'.tr;
      case 'RATE_LIMITED':
        return 'too_many_attempts'.tr;
      default:
        return 'unexpected_error'.tr;
    }
  }
}

class ResendCodeSection extends StatefulWidget {
  final VoidCallback onResend;

  const ResendCodeSection({super.key, required this.onResend});

  @override
  State<ResendCodeSection> createState() => _ResendCodeSectionState();
}

class _ResendCodeSectionState extends State<ResendCodeSection> {
  static const int _initialSeconds = 60;
  int _remainingSeconds = _initialSeconds;
  late Timer _timer;
  bool _resendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _resendEnabled = false;
    _remainingSeconds = _initialSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _resendEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Center(
        child: _resendEnabled
            ? TextButton(
                onPressed: () {
                  widget.onResend();
                  _startTimer();
                },
                child: Text(
                  'resend_code'.tr,
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              )
            : Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
      ),
    );
  }
}
