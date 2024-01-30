import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talab/config/router/app_route.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/core/common/elevated_button_widget.dart';
import 'package:talab/core/common/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talab/features/auth/presentation/state/auth_state.dart';
import 'package:talab/features/auth/presentation/viewmodel/auth_viewmodel.dart';

class LoginRegisterView extends ConsumerStatefulWidget {
  const LoginRegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginRegisterViewState();
}

class _LoginRegisterViewState extends ConsumerState<LoginRegisterView> {
  final mykey = GlobalKey<FormState>();
  TextEditingController fullname =
      TextEditingController(text: 'Bishwash Adhikari');
  DateTime dob = DateTime.now();
  TextEditingController username = TextEditingController(text: 'bishadhi');
  TextEditingController email =
      TextEditingController(text: 'bishwashadhikari1@gmail.com');
  TextEditingController password = TextEditingController(text: 'bishwash123');
  TextEditingController phone = TextEditingController(text: '9840281060');
  TextEditingController address =
      TextEditingController(text: 'Basundhara kathmandu');
  TextEditingController documentIdNumber =
      TextEditingController(text: '2392143812123');
  // List<bool> options = [true, false];
  // List<bool> accountTypes = [true, false];
  // String selectedOption = 'Log In';
  // String selectedAccountType = 'Employer';
  List<String> genders = ['Male', 'Female', 'Rainbow'];
  String gender = 'Male';
  PickedFile? imageFile;
  final ImagePicker? picker = ImagePicker();
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  void getInitialData() async {
    final authState = ref.read(authViewModelProvider.notifier);
    await authState.checkDeviceSupportForBiometrics();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getInitialData());
  }

  File? _img;
  Future _browseImage(WidgetRef ref, ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
        });
        final result =
            await ref.read(authViewModelProvider.notifier).uploadImage(_img!);
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget labeledTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'sf-semibold',
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  void navigateToSignin() {
    Navigator.pushNamed(context, AppRoute.signupPage);
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColorConstant.black,
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.signupPage);
          },
        ),
        backgroundColor: AppColorConstant.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return buildWelcomeScreen(
              "Welcome",
              "assets/images/logo.png",
              AppColorConstant.black,
              Colors.grey,
              Colors.blue,
              context,
              constraints,
              authState);
        },
      ),
    );
  }

  Widget buildWelcomeScreen(
    String title,
    String logoPath,
    Color titleColor,
    Color subTitleColor,
    Color circleColor,
    BuildContext context,
    BoxConstraints constraints,
    AuthState authState,
  ) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/welcomelogo.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sf-bold',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'sf-regular',
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: mykey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labeledTextField("E-mail"),
                          textFieldWidget(
                            'E-mail',
                            email,
                          ),
                          const SizedBox(height: 20),
                          labeledTextField("Password"),
                          textFieldWidget(
                            'Password',
                            password,
                          ),
                          const SizedBox(height: 20.2313),
                          elevatedButtonWidget(
                            'Log In',
                            () async {
                              if (mykey.currentState!.validate()) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .loginStudent(
                                      context,
                                      email.text,
                                      password.text,
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: navigateToSignin,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontFamily: "sf-medium",
                                      color: Color.fromARGB(255, 146, 145, 145),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' Sign up',
                                    style: TextStyle(
                                      fontFamily: "sf-medium",
                                      color: AppColorConstant.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          authState.supportBioMetricState
                              ? IconButton(
                                  onPressed: () async {
                                    ref
                                        .read(authViewModelProvider.notifier)
                                        .authenticateWithBiometrics(
                                          context: context,
                                        );
                                  },
                                  icon: const Icon(Icons.fingerprint),
                                  color: Colors.blue,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
