import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/core/common/elevated_button_widget.dart';
import 'package:talab/core/common/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talab/features/auth/presentation/state/auth_state.dart';
import 'package:talab/features/auth/presentation/viewmodel/auth_viewmodel.dart';

import '../../../../config/router/app_route.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
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

  List<String> genders = ['Male', 'Female', 'Rainbow'];
  String gender = 'Male';
  List<String> accountTypes = ['Employee', 'Employer'];
  String accountType = 'Employee';
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
    Navigator.pushNamed(context, AppRoute.loginregisterRoute);
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
            Navigator.pushNamed(context, AppRoute.loginregisterRoute);
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
              children: [
                Column(
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sf-bold',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create account and enjoy all services.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'sf-regular',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: mykey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labeledTextField("Select Account Type"),
                          DropdownButtonFormField(
                            key: const Key('accountTypefieldKey'),
                            value: accountType,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: "Select accountType",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: "sf-medium",
                                fontSize: 20,
                              ),
                            ),
                            items: accountTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        color: AppColorConstant.black,
                                        fontFamily: "sf-medium",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              accountType = value! ?? '';
                            },
                          ),
                          const SizedBox(height: 20.0012),
                          labeledTextField("Fullname"),
                          textFieldWidget(
                            'Full Name',
                            fullname,
                          ),
                          const SizedBox(height: 20),
                          labeledTextField("Username"),
                          textFieldWidget(
                            'Username',
                            username,
                          ),
                          const SizedBox(height: 20.001),
                          labeledTextField("Password"),
                          textFieldWidget(
                            'Password',
                            password,
                          ),
                          const SizedBox(height: 20.0011),
                          labeledTextField("Select Gender"),
                          DropdownButtonFormField(
                            key: const Key('registerGenderFieldKey'),
                            value: gender,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Select Gender",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "sf-medium",
                                  fontSize: 20,
                                )),
                            items: genders
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              gender = value! ?? '';
                            },
                          ),
                          const SizedBox(height: 20.0012),
                          labeledTextField("Date of Birth"),
                          Text(
                            'Date of Birth: ${dob.day}/${dob.month}/${dob.year}',
                            style: const TextStyle(
                              color: AppColorConstant.black,
                              fontFamily: "sf-medium",
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              key: const Key('registerDobFieldKey'),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: dob,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2050),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    dob = newDate;
                                  });
                                }
                              },
                              child: const Text('Change Date',
                                  style: TextStyle(
                                    color: AppColorConstant.black,
                                    fontFamily: "sf-medium",
                                    fontSize: 20,
                                  )),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColorConstant.black,
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.002),
                          labeledTextField("Phone Number"),
                          textFieldWidget(
                            'Phone',
                            phone,
                            // key: const Key('registerPhoneFieldKey'),
                          ),
                          const SizedBox(height: 20.003),
                          labeledTextField("Email Address"),
                          textFieldWidget(
                            'Email Address',
                            email,
                            // key: const Key('registerEmailFieldKey'),
                          ),
                          const SizedBox(height: 20.004),
                          labeledTextField("Address"),
                          textFieldWidget(
                            'Address',
                            address,
                            // key: const Key(
                            //     'registerAddressFieldKey'),
                          ),
                          const SizedBox(height: 20.005),
                          labeledTextField("Document Number"),
                          textFieldWidget(
                            'Document Number',
                            documentIdNumber,
                            // key: const Key(
                            //     'registerDocumentNumberFieldKey'),
                          ),
                          const SizedBox(height: 20.006),
                          InkWell(
                            key: const Key('registerDocumentFieldKey'),
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.grey[300],
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _browseImage(ref, ImageSource.camera);
                                          Navigator.pop(context);
                                          // Upload image it is not null
                                        },
                                        icon: const Icon(Icons.camera),
                                        label: const Text('Camera'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _browseImage(
                                              ref, ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.image),
                                        label: const Text('Gallery'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/uploaddocs.jpg'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.008),
                          elevatedButtonWidget(
                            'Register',
                            () async {
                              Navigator.pushNamed(
                                  context, AppRoute.sucesssignup);
                              if (mykey.currentState!.validate()) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .registerStudent(
                                        context: context,
                                        username: username.text,
                                        fullname: fullname.text,
                                        password: password.text,
                                        gender: gender,
                                        dob: dob,
                                        address: address.text,
                                        email: email.text,
                                        phone: phone.text,
                                        documentImage:
                                            authState.imageName ?? "",
                                        documentIdNumber: documentIdNumber.text,
                                        accountType: accountType,
                                        walletId: '');
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
                                    ' Sign in',
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
                          const SizedBox(height: 20.008),
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
