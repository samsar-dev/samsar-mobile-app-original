import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/otp_field/otp_field.dart';
import 'package:samsar/utils/error_message_mapper.dart';

class PasswordChangeView extends StatefulWidget {
  const PasswordChangeView({super.key});

  @override
  State<PasswordChangeView> createState() => _PasswordChangeViewState();
}

class _PasswordChangeViewState extends State<PasswordChangeView> {
  final AuthApiServices _authApiServices = AuthApiServices();
  
  // Controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  
  // State
  bool isStep1 = true;
  bool _isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
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
          'change_password'.tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
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
                  isStep1 ? 'enter_current_and_new_password'.tr : 'verify_password_change'.tr,
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
                    ? 'password_change_description'.tr
                    : 'verification_code_sent_to_email'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.04),

                if (isStep1) ...[
                  // Step 1: Password Input
                  _buildPasswordField(
                    'current_password'.tr,
                    'enter_current_password'.tr,
                    _currentPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_provide_current_password'.tr;
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  _buildPasswordField(
                    'new_password'.tr,
                    'enter_new_password'.tr,
                    _newPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_provide_password'.tr;
                      }
                      if (value.length < 6) {
                        return 'password_min_6_chars'.tr;
                      }
                      if (value == _currentPasswordController.text) {
                        return 'new_password_must_be_different'.tr;
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  _buildPasswordField(
                    'confirm_password'.tr,
                    'confirm_new_password'.tr,
                    _confirmPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_confirm_password'.tr;
                      }
                      if (value != _newPasswordController.text) {
                        return 'passwords_do_not_match'.tr;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  // Step 2: OTP Verification
                  Text(
                    'enter_6_digit_otp'.tr,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: blackColor
                    ),
                  ),
                  const SizedBox(height: 20),
                  OtpField(
                    widthMultiplier: 0.9,
                    controllers: _otpControllers,
                  ),
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
                        Icon(Icons.error_outline, color: Colors.red[600], size: 20),
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

                // Action Buttons
                if (isStep1) ...[
                  AppButton(
                    widthSize: 1.0,
                    heightSize: 0.07,
                    text: _isLoading ? 'sending'.tr : 'send_verification_code'.tr,
                    textColor: whiteColor,
                    buttonColor: blueColor,
                    onPressed: _isLoading ? null : _sendVerificationCode,
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          widthSize: 1.0,
                          heightSize: 0.07,
                          text: 'back'.tr,
                          textColor: whiteColor,
                          buttonColor: Colors.grey,
                          onPressed: _isLoading ? null : () {
                            setState(() {
                              isStep1 = true;
                              errorMessage = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          widthSize: 1.0,
                          heightSize: 0.07,
                          text: _isLoading ? 'changing'.tr : 'change_password'.tr,
                          textColor: whiteColor,
                          buttonColor: blueColor,
                          onPressed: _isLoading ? null : _changePassword,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  ResendCodeSection(
                    onResend: _sendVerificationCode,
                  ),
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
                          'password_change_security_notice'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: blueColor,
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
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.lock_outline, color: blueColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: blueColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _sendVerificationCode() async {
    // Validate passwords
    if (_currentPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'please_provide_current_password'.tr;
      });
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'please_provide_password'.tr;
      });
      return;
    }

    if (_newPasswordController.text.length < 6) {
      setState(() {
        errorMessage = 'password_min_6_chars'.tr;
      });
      return;
    }

    if (_newPasswordController.text == _currentPasswordController.text) {
      setState(() {
        errorMessage = 'new_password_must_be_different'.tr;
      });
      return;
    }

    if (_confirmPasswordController.text != _newPasswordController.text) {
      setState(() {
        errorMessage = 'passwords_do_not_match'.tr;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _authApiServices.sendPasswordChangeVerificationService(
        currentPassword: _currentPasswordController.text,
      );
      
      if (response.isSuccess) {
        setState(() {
          isStep1 = false;
          _isLoading = false;
        });
        
        Get.snackbar(
          'success'.tr,
          'verification_code_sent'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'failed_to_send_verification_code'.tr;
        
        if (response.apiError?.message != null) {
          final message = response.apiError!.message;
          
          if (message.contains("Rate limit exceeded") || message.contains("Too many requests")) {
            final retryTime = ErrorMessageMapper.extractRetryTime(message);
            errorMsg = ErrorMessageMapper.getErrorMessage('RATE_LIMIT_EXCEEDED', retryAfter: retryTime);
          } else if (message.contains("Invalid password") || message.contains("Current password is incorrect")) {
            errorMsg = ErrorMessageMapper.getErrorMessage('INVALID_PASSWORD');
          } else if (message.contains("User email not found")) {
            errorMsg = ErrorMessageMapper.getErrorMessage('USER_NOT_FOUND');
          } else {
            errorMsg = ErrorMessageMapper.getErrorMessage(null) + ": $message";
          }
        }
        
        setState(() {
          errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = ErrorMessageMapper.getErrorMessage(null);
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    String otpCode = _otpControllers.map((controller) => controller.text).join();
    if (otpCode.length != 6) {
      setState(() {
        errorMessage = 'please_enter_valid_code'.tr;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _authApiServices.changePasswordService(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        verificationCode: otpCode,
      );
      
      if (response.isSuccess) {
        Get.back();
        
        Get.snackbar(
          'success'.tr,
          'password_changed_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'failed_to_change_password'.tr;
        
        if (response.apiError?.message != null) {
          final message = response.apiError!.message;
          
          if (message.contains("Rate limit exceeded")) {
            final retryTime = ErrorMessageMapper.extractRetryTime(message);
            errorMsg = ErrorMessageMapper.getErrorMessage('RATE_LIMIT_EXCEEDED', retryAfter: retryTime);
          } else if (message.contains("Invalid verification code")) {
            errorMsg = ErrorMessageMapper.getErrorMessage('INVALID_CODE');
          } else if (message.contains("Current password is incorrect")) {
            errorMsg = ErrorMessageMapper.getErrorMessage('INVALID_PASSWORD');
          } else if (message.contains("You must be logged in")) {
            errorMsg = ErrorMessageMapper.getErrorMessage('UNAUTHORIZED');
          } else {
            errorMsg = ErrorMessageMapper.getErrorMessage(null) + ": $message";
          }
        }
        
        setState(() {
          errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = ErrorMessageMapper.getErrorMessage(null);
        _isLoading = false;
      });
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
      if(_remainingSeconds > 0) {
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
