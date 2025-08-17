import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/models/auth/login_model.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/image_holder/image_holder.dart';
import 'package:samsar/widgets/email_change_dialog.dart';
import 'package:samsar/widgets/change_password_dialog.dart';

class ProfileView extends StatefulWidget {
  final String name;
  final String userName;
  final String email;
  final String mobileNo;
  final String bio;
  final String imageUrl;
  final String street;
  final String city;
  const ProfileView(
    {
      super.key,
      required this.name,
      required this.userName,
      required this.email,
      required this.mobileNo,
      required this.bio,
      required this.imageUrl,
      required this.street,
      required this.city
    }
  );

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController authController = Get.find<AuthController>();

  bool isEditing = false;
  File? profileImage;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController streetController;
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize controllers with current user data from controller
    final user = authController.user.value;
    usernameController = TextEditingController(text: user?.username ?? widget.userName);
    emailController = TextEditingController(text: user?.email ?? widget.email);
    phoneController = TextEditingController(text: user?.phone ?? widget.mobileNo);
    bioController = TextEditingController(text: user?.bio ?? widget.bio);
    streetController = TextEditingController(text: user?.street ?? widget.street);
    cityController = TextEditingController(text: user?.city ?? widget.city);
  }

  void _updateControllersFromUserData() {
    // Update controllers when user data changes
    final user = authController.user.value;
    if (user != null) {
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phone ?? '';
      bioController.text = user.bio ?? '';
      streetController.text = user.street ?? '';
      cityController.text = user.city ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    
    return Obx(() {
      // Update controllers when user data changes
      final user = authController.user.value;
      if (user != null) {
        // Only update if not currently editing to avoid cursor jumping
        if (!isEditing) {
          _updateControllersFromUserData();
        }
      }
      
      return Scaffold(
      backgroundColor: whiteColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          "my_profile".tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [

                SizedBox(height: height * 0.04),
                Hero(
                  tag: "image_bridge",
                  child: ImageHolder(
                    isEditable: true,
                    imageUrl: authController.user.value?.profilePicture ?? widget.imageUrl,
                    onImageSelected: (File selectedImage) {
                      setState(() {
                        profileImage = selectedImage;
                      });
                    },
                  )
                ),

                const SizedBox(height: 12),

               
                Text(
                  widget.name,
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                

                const SizedBox(height: 8),

                Divider(
                  indent: width * 0.18,
                  endIndent: width * 0.18,
                  thickness: 1,
                ),

                const SizedBox(height: 20),

               buildProfileField("username".tr, usernameController),
                
               
               buildEmailField("email".tr, emailController),
               
              
               buildProfileField("phone_no".tr, phoneController),
                
               
               buildProfileField("bio".tr, bioController),
              
                  
              buildProfileField("street".tr, streetController),
                
             
              buildProfileField("city".tr, cityController),
             
              const SizedBox(height: 22),
                AppButton(
                  widthSize: 0.55,
                  heightSize: 0.06,
                  buttonColor: blueColor,
                  text: isEditing ? "save".tr : "edit".tr,
                  textColor: whiteColor,
                  textSize: 22,
                  onPressed: () async {
                    if (isEditing) {
                      // Save the changes
                      final authController = Get.find<AuthController>();
                      await authController.updateProfile(
                        name: widget.name, // Name is not editable in this view
                        username: usernameController.text,
                        bio: bioController.text,
                        street: streetController.text,
                        city: cityController.text,
                        phone: phoneController.text,
                        profileImage: profileImage,
                      );
                      
                      // Update controllers immediately after successful save
                      _updateControllersFromUserData();
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Change Password Button
                AppButton(
                  widthSize: 0.55,
                  heightSize: 0.06,
                  buttonColor: Colors.orange,
                  text: "change_password".tr,
                  textColor: whiteColor,
                  textSize: 20,
                  onPressed: () {
                    _showChangePasswordDialog();
                  },
                )

              ],
            ),
          ),
        ),
      ),
      );
    });
  }

  Widget buildEmailField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              if (!isEditing)
                GestureDetector(
                  onTap: () {
                    _showEmailChangeDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email,
                          color: whiteColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'change_email'.tr,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              controller.text,
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                color: blueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isEditing
                ? TextField(
                    controller: controller,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      controller.text,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showEmailChangeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EmailChangeDialog(
          currentEmail: emailController.text,
          onEmailChanged: (String newEmail) {
            setState(() {
              emailController.text = newEmail;
            });
            // Update the user data in auth controller
            final authController = Get.find<AuthController>();
            if (authController.user.value != null) {
              // Create a new user object with updated email since email is final
              final currentUser = authController.user.value!;
              final updatedUser = User(
                id: currentUser.id,
                email: newEmail,
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
              
              // The UI will be updated when the parent widget rebuilds
              // since the email is passed as a parameter from the parent
            }
          },
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ChangePasswordDialog();
      },
    );
  }
}