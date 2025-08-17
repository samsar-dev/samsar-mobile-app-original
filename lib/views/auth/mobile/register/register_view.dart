import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/views/auth/mobile/code_verification/code_verification_view.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/input_field/input_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: blueColor,

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.2,
                  color: blueColor,
                  child: Center(
                    child: Hero(
                      tag: "auth_title",
                      child: Text("Samsar", style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.085
                      ),),
                    ),
                  ),
                ),
                    
                SizedBox(height: screenHeight * 0.03,),

                registerCard(context, screenHeight, screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerCard(BuildContext context, double screenHeight, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.95,

      child: Card(
        color: whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.08,
              child: Center(
                child: Text("signup".tr, style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.08
                ),),
              ),
            ),

            inputCard("name".tr, "enter_your_name".tr, _nameController, false, context, (value) {
              if (value == null || value.isEmpty) {
                return "please_provide_name".tr;
              }
              return null;
            }),
            SizedBox(height: screenHeight * 0.01,),
            inputCard("email".tr, "enter_your_email".tr, _emailController, false, context, (value) {
              if (value == null || value.isEmpty) {
                return "please_provide_email".tr;
              }
              if (!GetUtils.isEmail(value)) {
                return "please_provide_valid_email".tr;
              }
              return null;
            }),
            SizedBox(height: screenHeight * 0.01,),
            inputCard("username".tr, "enter_your_username".tr, _usernameController, false, context, (value) {
              if (value == null || value.isEmpty) {
                return "please_provide_username".tr;
              }
              if (value.length < 3) {
                return "username_min_3_chars".tr;
              }
              return null;
            }),
            SizedBox(height: screenHeight * 0.01,),
            inputCard("password".tr, "enter_your_password".tr, _passwordController, true, context, (value) {
              if (value == null || value.isEmpty) {
                return "please_provide_valid_password".tr;
              }
              if (value.length < 6) {
                return "password_min_8_chars".tr;
              }
              return null;
            }),
            SizedBox(height: screenHeight * 0.01,),
            inputCard("confirm_password".tr, "enter_same_password".tr, _confirmPasswordController, true, context, (value) {
              if (value == null || value.isEmpty) {
                return "please_confirm_password".tr;
              }
              if (value != _passwordController.text) {
                return "passwords_do_not_match".tr;
              }
              return null;
            }),
            SizedBox(height: screenHeight * 0.01,),

            SizedBox(height: screenHeight * 0.004,),

              Obx(() {
                final AuthController authController = Get.find<AuthController>();
                return AppButton(
                  widthSize: 0.55,
                  heightSize: 0.06,
                  buttonColor: blueColor,
                  text: authController.registerLoading.value ? "registering".tr : "register".tr,
                  textColor: whiteColor,
                  onPressed: authController.registerLoading.value ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      // Check if passwords match
                      if (_passwordController.text != _confirmPasswordController.text) {
                        Get.snackbar(
                          "error".tr,
                          "passwords_do_not_match".tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      
                      // Call register function
                      await authController.register(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        userName: _usernameController.text.trim(),
                        password: _passwordController.text,
                      );
                      
                      // If registration is successful, navigate to verification
                      if (!authController.registerLoading.value) {
                        Get.to(
                          () => CodeVerificationView(email: _emailController.text.trim()),
                          transition: Transition.leftToRight,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    }
                  },
                );
              }),

              SizedBox(height: screenHeight * 0.008,),

               TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "already_have_account".tr,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget inputCard(String title, String labelText, TextEditingController controller, bool isPassword, BuildContext context, String? Function(String?)? validator) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Text(title, style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),),
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.005,),

        InputField(
          widthPercentage: 0.8,
          heightPercentage: 0.075,
          labelText: labelText,
          controller: controller,
          isPassword: isPassword,
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'please_enter_field'.trParams({'field': title.toLowerCase()});
            }
            if (title.toLowerCase() == 'email'.tr.toLowerCase()) {
              if (!GetUtils.isEmail(value)) {
                return 'please_enter_valid_email'.tr;
              }
            }
            if (title.toLowerCase() == 'password'.tr.toLowerCase()) {
              if (value.length < 6) {
                return 'password_min_length'.tr;
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}