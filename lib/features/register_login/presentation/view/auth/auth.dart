import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/register_login/presentation/view/auth/phoneauth_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../../confg/cacheHelper.dart';
import '../../../../home/presentation/view/home.dart';
import '../../view_model/managers/provider/internet_provider.dart';
import '../../view_model/managers/provider/music_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool checkedValue = false;
  bool register = true;
  List textfieldsStrings = [
    "", //firstName
    "", //lastName
    "", //email
    "", //password
    "", //confirmPassword
  ];

  final _firstnamekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  var firstnameRegisterController = TextEditingController();
  var emailRegisterController = TextEditingController();
  var passwordRegisterController = TextEditingController();
  var confirmRegisterController = TextEditingController();

  var emailLoginController = TextEditingController();
  var passwordLoginController = TextEditingController();
  var googleController = RoundedLoadingButtonController();
  var phoneController = RoundedLoadingButtonController();

  Future handleGoogleSignIn() async {
    final sp = context.read<MusicProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {                      

    await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {                       

        // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists

              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        CacheHelper.savedData(key: "token", value: true);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Home()));

                      })));
            } else {                     

            // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {                      
              googleController.success();
              CacheHelper.savedData(key: "token", value: true);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Home()));
                      })));
            }
          });
        }
      });
    }
  }

  void openSnackbar(context, snackMessage, color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text(
          snackMessage,
          style: const TextStyle(fontSize: 14),
        )));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
            color: Color(0xdf141f2d),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: Align(
                          child: Image(
                              image: AssetImage('assets/images/logo.png')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: Align(
                          child: register
                              ? Text(
                                  'Create an Account',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Welcome Back',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                      ),
                      register
                          ? buildTextField(
                              firstnameRegisterController,
                              "First Name",
                              Icons.person_outlined,
                              false,
                              size,
                              (valuename) {
                                if (valuename.length <= 3) {
                                  buildSnackError(
                                    'Invalid name',
                                    context,
                                    size,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              _firstnamekey,
                              0,
                            )
                          : Container(),
                      register
                          ? Form(
                              child: buildTextField(
                                emailRegisterController,
                                "Email",
                                Icons.email_outlined,
                                false,
                                size,
                                (valuemail) {
                                  if (valuemail.length < 5) {
                                    buildSnackError(
                                      'Invalid email',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                      .hasMatch(valuemail)) {
                                    buildSnackError(
                                      'Invalid email',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _emailKey,
                                2,
                              ),
                            )
                          : Form(
                              child: buildTextField(
                                emailLoginController,
                                "Email",
                                Icons.email_outlined,
                                false,
                                size,
                                (valuemail) {
                                  if (valuemail.length < 5) {
                                    buildSnackError(
                                      'Invalid email',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                      .hasMatch(valuemail)) {
                                    buildSnackError(
                                      'Invalid email',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _emailKey,
                                2,
                              ),
                            ),
                      register
                          ? Form(
                              child: buildTextField(
                                passwordRegisterController,
                                "Passsword",
                                Icons.lock_outline,
                                true,
                                size,
                                (valuepassword) {
                                  if (valuepassword.length < 6) {
                                    buildSnackError(
                                      'Invalid password',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _passwordKey,
                                3,
                              ),
                            )
                          : Form(
                              child: buildTextField(
                                passwordLoginController,
                                "Passsword",
                                Icons.lock_outline,
                                true,
                                size,
                                (valuepassword) {
                                  if (valuepassword.length < 6) {
                                    buildSnackError(
                                      'Invalid password',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _passwordKey,
                                3,
                              ),
                            ),
                      Form(
                        child: register
                            ? buildTextField(
                                confirmRegisterController,
                                "Confirm Passsword",
                                Icons.lock_outline,
                                true,
                                size,
                                (valuepassword) {
                                  if (valuepassword != textfieldsStrings[3]) {
                                    buildSnackError(
                                      'Passwords must match',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _confirmPasswordKey,
                                4,
                              )
                            : Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: register
                            ? Column(
                                children: [
                                  CheckboxListTile(
                                    title: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "By creating an account, you agree to our ",
                                            style: TextStyle(
                                              color: ColorsApp.whiteColor,
                                              fontSize: size.height * 0.015,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: InkWell(
                                              onTap: () {
                                                // ignore: avoid_print
                                                print('Conditions of Use');
                                              },
                                              child: Text(
                                                "Conditions of Use",
                                                style: TextStyle(
                                                  color: ColorsApp.whiteColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: size.height * 0.015,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: " and ",
                                            style: TextStyle(
                                              color: ColorsApp.whiteColor,
                                              fontSize: size.height * 0.015,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: InkWell(
                                              onTap: () {
                                                // ignore: avoid_print
                                                print('Privacy Notice');
                                              },
                                              child: Text(
                                                "Privacy Notice",
                                                style: TextStyle(
                                                  color: ColorsApp.whiteColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: size.height * 0.015,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    activeColor: ColorsApp.orangeColor,
                                    value: checkedValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        checkedValue = newValue!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  Row(
                                    children: [],
                                  ),
                                ],
                              )
                            : Row(
                                children: [],
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: RoundedLoadingButton(
                                onPressed: () {
                                  handleGoogleSignIn();
                                },
                                controller: googleController,
                                successColor: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.80,
                                elevation: 0,
                                borderRadius: 25,
                                color: ColorsApp.orangeColor,
                                child: Wrap(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.google,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RoundedLoadingButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneAuthScreen()));

                                  phoneController.reset();
                                },
                                controller: phoneController,
                                successColor: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.80,
                                elevation: 0,
                                borderRadius: 25,
                                color: Colors.orange,
                                child: Wrap(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.phone,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Sign in with Phone",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: register
                            ? EdgeInsets.only(top: size.height * 0.025)
                            : EdgeInsets.only(top: size.height * 0.085),
                        child: ButtonWidget(
                          text: register ? "Register" : "Login",
                          backColor: [
                            Colors.orange.withOpacity(0.6),
                            Colors.orange.withOpacity(0.9),
                          ],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (register) {
                              //validation for register
                              if (_firstnamekey.currentState!.validate()) {
                                if (_emailKey.currentState!.validate()) {
                                  if (_passwordKey.currentState!.validate()) {
                                    if (_confirmPasswordKey.currentState!
                                        .validate()) {
                                      if (checkedValue == false) {
                                        buildSnackError(
                                            'Accept our Privacy Policy and Term Of Use',
                                            context,
                                            size);
                                      } else {
                                        print('register');
                                        Provider.of<MusicProvider>(context,
                                                listen: false)
                                            .userRegister(
                                                name:
                                                    firstnameRegisterController
                                                        .text,
                                                email: emailRegisterController
                                                    .text,
                                                password:
                                                    passwordRegisterController
                                                        .text,
                                                context: context);
                                      }
                                    }
                                  }
                                }
                              }
                            } else {
                              //validation for login
                              if (_emailKey.currentState!.validate()) {
                                if (_passwordKey.currentState!.validate()) {
                                  print('login');
                                  Provider.of<MusicProvider>(context,
                                          listen: false)
                                      .userLogin(
                                          email: emailLoginController.text,
                                          password:
                                              passwordLoginController.text,
                                          context: context);
                                }
                              }
                            }
                          },
                        ),
                      ),
                      register
                          ? AnimatedPadding(
                              duration: const Duration(milliseconds: 500),
                              padding: EdgeInsets.only(
                                top: register
                                    ? size.height * 0.025
                                    : size.height * 0.15,
                              ),
                              child: Row(
                                //TODO: replace text logo with your logo
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: GoogleFonts.poppins(
                                      color: ColorsApp.whiteColor,
                                      fontSize: size.height * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '+',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff3b22a1),
                                      fontSize: size.height * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : AnimatedPadding(
                              duration: const Duration(milliseconds: 500),
                              padding: EdgeInsets.only(
                                top: register
                                    ? size.height * 0.025
                                    : size.height * 0.15,
                              ),
                              child: Row(
                                //TODO: replace text logo with your logo
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'REGISTER',
                                    style: GoogleFonts.poppins(
                                      color: ColorsApp.whiteColor,
                                      fontSize: size.height * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '+',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff3b22a1),
                                      fontSize: size.height * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: register
                                    ? "Already have an account? "
                                    : "Don’t have an account yet? ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.018,
                                ),
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () => setState(() {
                                    if (register) {
                                      register = false;
                                    } else {
                                      register = true;
                                    }
                                  }),
                                  child: register
                                      ? Text(
                                          "Login",
                                          style: TextStyle(
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: <Color>[
                                                  Color(0xffEEA4CE),
                                                  Color(0xffC58BF2),
                                                ],
                                              ).createShader(
                                                const Rect.fromLTWH(
                                                  0.0,
                                                  0.0,
                                                  200.0,
                                                  70.0,
                                                ),
                                              ),
                                            fontSize: size.height * 0.018,
                                          ),
                                        )
                                      : Text(
                                          "Register",
                                          style: TextStyle(
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: <Color>[
                                                  Color(0xffEEA4CE),
                                                  Color(0xffC58BF2),
                                                ],
                                              ).createShader(
                                                const Rect.fromLTWH(
                                                    0.0, 0.0, 200.0, 70.0),
                                              ),
                                            // color: const Color(0xffC58BF2),
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                ),
                              ),
                            ],
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

  bool pwVisible = false;

  Widget buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    Key key,
    int stringToEdit,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.05,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                textfieldsStrings[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.012,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pwVisible = !pwVisible;
                          });
                        },
                        child: pwVisible
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Color(0xff7B6F72),
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Color(0xff7B6F72),
                              ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final List<Color> backColor;

  final List<Color> textColor;
  final GestureTapCallback onPressed;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.backColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Shader textGradient = LinearGradient(
      colors: <Color>[textColor[0], textColor[1]],
    ).createShader(
      const Rect.fromLTWH(
        0.0,
        0.0,
        200.0,
        70.0,
      ),
    );
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.07,
      width: size.width * 0.9,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              stops: const [0.4, 2],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: backColor,
            ),
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                foreground: Paint()..shader = textGradient,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
