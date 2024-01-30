import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';

import '../../config/theme/app_color_constant.dart';
import '../auth/presentation/viewmodel/auth_viewmodel.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  void openEditDialog({
    required TextEditingController controller,
    required String userId,
    required String title,
    required String hintText,
    required String type,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16.0,
              color: AppColorConstant.black,
            ),
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                // Save the changes and update the user's about information.
                if (type == 'fullname') {
                  await ref
                      .read(authViewModelProvider.notifier)
                      .updateUserProfile(
                        user: ref
                            .watch(authViewModelProvider)
                            .loggedUser!
                            .copyWith(
                              fullname: controller.text,
                            ),
                      );
                } else if (type == 'phone') {
                  await ref
                      .read(authViewModelProvider.notifier)
                      .updateUserProfile(
                        user: ref
                            .watch(authViewModelProvider)
                            .loggedUser!
                            .copyWith(
                              phone: controller.text,
                            ),
                      );
                } else if (type == 'address') {
                  await ref
                      .read(authViewModelProvider.notifier)
                      .updateUserProfile(
                        user: ref
                            .watch(authViewModelProvider)
                            .loggedUser!
                            .copyWith(
                              address: controller.text,
                            ),
                      );
                }

                // await ref
                //     .read(userProfileViewModelProvider.notifier)
                //     .updateUserProfile(
                //       userId: userId,
                //       userEntity: userProfileState.loggedUser.copyWith(
                //         description: aboutController.text,
                //       ),
                //     );
                // nav.pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authVM = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColorConstant.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // a circular avatar for profile picture
                CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Image.network(
                        'https://thumbs.dreamstime.com/z/no-user-profile-picture-hand-drawn-illustration-53840492.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )),

                SizedBox(
                  height: 20,
                ),
                Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.grey,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: AppColorConstant.white,
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.lock_outline,
                        color: AppColorConstant.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Change your Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColorConstant.black,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            openEditDialog(
                              controller: passwordController,
                              userId: authState.loggedUser!.id,
                              title: 'Change your password',
                              hintText: 'Enter your password',
                              type: 'password',
                            );
                          },
                          icon: Icon(Icons.skip_next))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // a text widget for the user's name
                Text("Fullname",
                    style: TextStyle(
                      fontFamily: "sf-semibold",
                      fontSize: 14,
                      color: AppColorConstant.black,
                    )),

                SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorConstant.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.person,
                        color: AppColorConstant.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        authState.loggedUser?.fullname ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColorConstant.black,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            openEditDialog(
                              controller: fullnameController,
                              userId: authState.loggedUser!.id,
                              title: 'Edit Fullname',
                              hintText: 'Enter your fullname...',
                              type: 'fullname',
                            );
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                // a text widget for the user's email
                Text("Address",
                    style: TextStyle(
                      fontFamily: "sf-semibold",
                      fontSize: 14,
                      color: AppColorConstant.black,
                    )),

                SizedBox(
                  height: 12,
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorConstant.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.location_city,
                        color: AppColorConstant.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        authState.loggedUser?.address ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColorConstant.black,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            openEditDialog(
                              controller: addressController,
                              userId: authState.loggedUser!.id,
                              title: 'Edit Address',
                              hintText: 'Enter your address...',
                              type: 'address',
                            );
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                // a text widget for the user's phone number

                Text("Number",
                    style: TextStyle(
                      fontFamily: "sf-semibold",
                      fontSize: 14,
                      color: AppColorConstant.black,
                    )),

                SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorConstant.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.phone,
                        color: AppColorConstant.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        authState.loggedUser?.phone ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColorConstant.black,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            openEditDialog(
                              controller: phoneController,
                              userId: authState.loggedUser!.id,
                              title: 'Edit Phone Number',
                              hintText: 'Enter your phone number...',
                              type: 'phone',
                            );
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Enable FingerPrint Login',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColorConstant.black,
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: authState.allowLoginWithBiometric,
                        onChanged: (value) async {
                          await ref
                              .watch(userSharedPrefsProvider)
                              .setBiometrics(
                                value,
                              );
                          if (value) {
                            final ogToken = await ref
                                .watch(userSharedPrefsProvider)
                                .getBiometrics();
                            ogToken.fold((l) => null, (r) async {
                              await ref
                                  .watch(userSharedPrefsProvider)
                                  .setBiometrics(r);
                            });
                          }
                          ref
                              .watch(authViewModelProvider.notifier)
                              .allowLoginWithBiometric(
                                value: value,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    bool? confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout Confirmation'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref
                          .read(authViewModelProvider.notifier)
                          .logout(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.yellow[300],
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColorConstant.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    bool? confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Deactivate Confirmation'),
                        content: Text('Are you sure you want to deactivate?'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      ref
                          .read(authViewModelProvider.notifier)
                          .deleteUserProfile(
                            userID:
                                ref.read(authViewModelProvider).loggedUser!.id,
                          );
                      await ref
                          .read(authViewModelProvider.notifier)
                          .logout(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red[400],
                      // border: Border.all(
                      //   color: Colors.red,
                      // ),
                    ),
                    child: Text(
                      'Deactivate Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
