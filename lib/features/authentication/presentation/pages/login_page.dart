// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures, avoid_print, duplicate_ignore

import 'dart:developer';

import 'package:aplico/core/UI/router/router.gr.dart';
import 'package:aplico/core/UI/widgets/about_projects.dart';
import 'package:aplico/core/UI/widgets/kits.dart';
import 'package:aplico/features/authentication/presentation/widgets/constants.dart';
import 'package:aplico/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/UI/widgets/custom_widgets/custom_widgets.dart';
import '../../../../core/UI/widgets/loading_widget.dart';
import '../../../../core/logical/errors/error_model.dart';
import '../../domain/models/auth_params.dart';
import '../cubit/auth_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // إضافة ScrollController لتمكين التمرير إلى العناصر
  final ScrollController _scrollController = ScrollController();
  final AuthParams paramsLogin = AuthParams.login();
  final AuthParams paramssignUp = AuthParams.signup();
  late ErrorDictionary errorDictionary;
  bool isRegister = true;
  bool showPassword = true;

  // إضافة GlobalKeys للأقسام المختلفة للتمرير إليها
  final GlobalKey aboutProjectKey = GlobalKey();
  final GlobalKey kitKey = GlobalKey();
  final GlobalKey aboutUsKey = GlobalKey();
  final GlobalKey partnersKey = GlobalKey();

  // سيتم استبدال هذه القيم بالصور والنصوص الحقيقية
  final List<String> kitImages = [
    'assets/images/kit1.jpg',
    'assets/images/kit2.jpg',
    'assets/images/kit3.jpg',
    'assets/images/kit4.jpg',
  ];

  final List<Map<String, String>> partners = [
    {'logo': 'assets/logos/partner1.png', 'name': 'شركة الأولى'},
    {'logo': 'assets/logos/partner2.png', 'name': 'شركة الثانية'},
    {'logo': 'assets/logos/partner3.png', 'name': 'شركة الثالثة'},
    {'logo': 'assets/logos/partner4.png', 'name': 'شركة الرابعة'},
    {'logo': 'assets/logos/partner5.png', 'name': 'شركة الخامسة'},
  ];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    errorDictionary = [];
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // دالة للتمرير إلى قسم معين
  void _scrollToSection(GlobalKey key) {
    // إغلاق الدراور أولاً
    Navigator.pop(context);

    // التمرير إلى القسم المطلوب
    Future.delayed(Duration(milliseconds: 300), () {
      final RenderBox renderBox =
          key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      _scrollController.animateTo(
        position.dy - 100, // تعديل المسافة لتناسب وضع الشاشة
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _submit() async {
    errorDictionary.clear();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final cubit = context.read<AuthCubit>();
    if (isRegister)
      // ignore: curly_braces_in_flow_control_structures
      cubit.register(paramssignUp);
    else {
      cubit.loginUser(paramsLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /////////////////////////////////////////////////////////////////////////////////////////////////scafolddddd
      backgroundColor: kDarkColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                if (!isRegister) _submit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    textcolor, //////////////////////////////////////////////////////////////////////////////////
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 18),
                  SizedBox(width: 5),
                  Text('sign in'),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: buildSimplifiedDrawer(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // نموذج تسجيل الدخول
            Padding(padding: const EdgeInsets.all(40), child: getFormWidget()),

            // الأقسام التي كانت في الدراور سابقاً
            buildAboutProjectSection(key: aboutProjectKey),
            buildKitSection(key: kitKey),
            buildAboutUsSection(key: aboutUsKey),
            buildPartnersSection(key: partnersKey),

            // زر الاتصال بنا
            // ElevatedButton(
            //   style: TextButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 20 * 2, vertical: 20),
            //     backgroundColor: Color(0xFF3799FB),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            //   ),
            //   onPressed: () {},
            //   child: Text(
            //     'CONTACT US',
            //     style: TextStyle(color: Color(0xFF000714)),
            //   ),
            // ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // دراور مبسط يحتوي فقط على العناوين الرئيسية
  Widget buildSimplifiedDrawer(BuildContext context) {
    // خطة الألوان الاحترافية
    final Color primaryColor = kDarkColor; // لون أساسي عميق أزرق
    // لون تكميلي أخضر
    final Color backgroundColor = kDarkColor; // خلفية فاتحة

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: primaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    primaryColor.withOpacity(0.8),
                    BlendMode.overlay,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.all(6),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     shape: BoxShape.circle,
                        //   ),
                        //   // child: Image.asset(
                        //   //   //'assets/images/logo.png',
                        //   //   //width: 50,
                        //   //   //height: 50,
                        //   // ),
                        // ),
                        SizedBox(height: 10),
                        Text(
                          'APLIKO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "",
                          style: TextStyle(
                            color: Colors.white70, // اللون الأبيض مع شفافية
                            fontSize:
                                16, // زيادة حجم الخط قليلاً ليبدو أكثر وضوحاً
                            fontWeight:
                                FontWeight
                                    .w500, // جعل الخط متوسط السمك لجعل النص أكثر وضوحاً
                            fontFamily:
                                'Roboto', // استخدام خط "Roboto" أو أي خط احترافي آخر
                            letterSpacing:
                                0.5, // إضافة مسافة صغيرة بين الحروف لجعل النص أسهل في القراءة
                            height: 1.5, // تحسين تباعد الأسطر لتبدو أفضل
                            shadows: [
                              Shadow(
                                // إضافة تأثير الظل ليعطي النص عمقاً
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // العناوين الرئيسية فقط مع أيقونات وأزرار للتنقل
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.white),

                    title: Text(
                      'About Project',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _scrollToSection(aboutProjectKey),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.settings_input_component_sharp,
                      color: Colors.white,
                    ),

                    title: Text(
                      'Kit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _scrollToSection(aboutProjectKey),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.people_outline, color: Colors.white),

                    title: Text(
                      'About Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _scrollToSection(aboutProjectKey),
                  ),
                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.handshake_outlined,
                      color: Colors.white,
                    ),

                    title: Text(
                      ' partners',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _scrollToSection(aboutProjectKey),
                  ),

                  Divider(height: 1),

                  // زر الاتصال بنا
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0 * 2,
                        vertical: 20.0,
                      ),
                      backgroundColor: Color(0xFF3799FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'CONTACT US',
                      style: TextStyle(color: Color(0xFF000714)),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10.0 * 2,
                      left: 10,
                      right: 10,
                    ),
                    color: Color(0xFF2B374F),
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/linkedin.svg'),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/github.svg'),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/twitter.svg'),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/dribble.svg'),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء قسم About Project
  Widget buildAboutProjectSection({Key? key}) {
    return Container(
      key: key,
      padding: EdgeInsets.all(20),
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF001233),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [aboutProject(), SizedBox(height: 15)],
      ),
    );
  }

  // بناء قسم Kit
  Widget buildKitSection({Key? key}) {
    return Container(
      key: key,
      padding: EdgeInsets.all(20),
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF001233),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kit(),
          SizedBox(height: 15),
        ], ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ),
    );
  }

  // بناء قسم About Us
  Widget buildAboutUsSection({Key? key}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Who We Are',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'The main vector of our young company’s development is the implementation of Internet of Things (IoT) technologies in industrial production and smart systems.',
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.6),
          ),
          SizedBox(height: 12),
          Text(
            'Our global goal is to create integrated systems, robotic complexes, and smart solutions that enable seamless interaction between devices and users.',
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.6),
          ),
          SizedBox(height: 12),
          Text(
            '• We are a technology startup.\n'
            '• Winners of the grant “Student Startup. 5th wave”.\n'
            '• Residents of the Kazan IT Park.\n'
            '• Received support from the Innovation Promotion Fund.\n'
            '• Developed an online platform for the Internet of Things.\n'
            '• And we’re just getting started — next up: robotic systems!',
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
          ),
        ],
      ),
    );
  }

  // بناء قسم Partners
  Widget buildPartnersSection({Key? key}) {
    return Container(
      key: key,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Our Partners',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: kSecondaryColor),
            height: 150,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 120,
                viewportFraction: 0.4,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items:
                  partners.map((partner) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 120,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4CAF50).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    color: Color(0xFF4CAF50),
                                    size: 30,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  partner['name']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212121),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFormWidget() {
    return Form(
      ///////////////////////////////////////////////////////////////////////////////////////////////////////formmmmmmmmmmmmmmmmmm
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            'Log in or sign up',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White title
            ),
          ),
          SizedBox(height: 16),
          // النص التوضيحي
          Text(
            'Check out more easily and access your tickets on any device with your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
            ), // Soft gray text
          ),
          SizedBox(height: 32),
          if (isRegister) ///////////////////////////////////////////////////////////////////////1111111111111111111111111111111111111111111111111111111111
            TextFormField(
              controller: firstNameController, // 👈 أضفه هنا
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////text form field password
              onSaved:
                  (firstname) =>
                      paramssignUp.firstname =
                          firstname, /////////////////////////////////////////////////////////////////////////////////////////////////parmmmmmmmmmmmmmmmmmmmmmmmmmms password

              cursorColor: Colors.white,
              cursorWidth: 0.5,
              decoration: InputDecoration(
                labelText: 'First Name',

                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ), // White label
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF007BFF),
                  ), // Blue border on focusd
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 253, 253),
                  ), // Light gray border
                ),
              ),
              obscureText: false,

              style: TextStyle(color: Colors.white), // White text in the input
            ),
          SizedBox(height: 15),
          if (isRegister)
            TextFormField(
              controller: lastNameController,

              //////////////////////////////////////////////////////////////////////////////////text form fieldddddddddddddddddddd
              onSaved: (lastname) => paramssignUp.lastname = lastname,

              cursorColor: Colors.white,
              cursorWidth: 0.5,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ), // White label
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF007BFF),
                  ), // Blue border on focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 253, 253),
                  ), // Light gray border
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              style: TextStyle(color: Colors.white), // White text in the input
            ),
          SizedBox(height: 15),
          TextFormField(
            controller: emailController,

            ////////////////////////////////////////22222222222222222222222222222222222222222222222222222222222
            //////////////////////////////////////////////////////////////////////////////////text form fieldddddddddddddddddddd
            onSaved: (email) {
              if (isRegister)
                paramssignUp.email = email;
              else
                paramsLogin.email = email;
            },
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@')) {
                return 'Invalid Email';
              }
              return null;
            },
            cursorColor: Colors.white,
            cursorWidth: 0.5,
            decoration: InputDecoration(
              labelText: 'Email address',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ), // White label
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF007BFF),
                ), // Blue border on focus
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 253, 253),
                ), // Light gray border
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            style: TextStyle(color: Colors.white), // White text in the input
          ),
          SizedBox(height: 10),

          SizedBox(height: 15),

          // CustomInputField(
          //   outerLabel: 'email',
          //   hint: 'email_address',
          //   isRequired: true,
          //   isEmail: true,
          //   errorDictionaryKey: 'email',
          //   errorDictionary: errorDictionary,
          //   onSaved: (email) => params.email = email,///////////////////////////////////////////////////////////////////////////////////////////////////
          // ),
          Column(
            children: [
              TextFormField(
                controller: passwordController,

                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////text form field password
                onSaved: (pass) {
                  if (isRegister)
                    paramssignUp.password = pass;
                  else
                    paramsLogin.password = pass;
                }, /////////////////////////////////////////////////////////////////////////////////////////////////parmmmmmmmmmmmmmmmmmmmmmmmmmms password
                validator: (value) {
                  if (value == null || value.trim().length <= 8) {
                    return 'Password must be at least 8 characters.';
                  }
                  return null;
                },
                cursorColor: Colors.white,
                cursorWidth: 0.5,
                decoration: InputDecoration(
                  labelText: 'Password',

                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ), // White label
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF007BFF),
                    ), // Blue border on focusd
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 253, 253),
                    ), // Light gray border
                  ),
                ),
                obscureText: true,

                style: TextStyle(
                  color: Colors.white,
                ), // White text in the input
              ),
              //  CustomInputField(
              //     outerLabel: 'password',
              //     hint: 'password',
              //     isObscureText: showPassword,
              //     isRequired: true,
              //     onChanged: (pass) => params.password = pass,
              //   ),
              SizedBox(height: 10),

              // Align(
              //   alignment: AlignmentDirectional.bottomEnd,
              //   child: AnimatedContainer(
              //     duration: 330.duration,
              //     height: isRegister ? 0 : 30,
              //     child: AnimatedOpacity(
              //       duration: 330.duration,
              //       opacity: isRegister ? 0 : 1,
              //       child: MaterialInk(
              //         onTap: () {
              //           context.pushRoute(const ForgetPasswordRoute());
              //         },

              //         child: TextTr(
              //           'forget_password',
              //           style: infoStyle(color: AppColors.white, size: 15),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          // AnimatedField(
          //   isRegister: isRegister,
          //   child: CustomInputField(
          //     enabled: isRegister ? true : false,
          //     outerLabel: 'confirm_password',
          //     hint: 'password',
          //     isObscureText: showPassword,
          //     validator: (val) {
          //       if (!isRegister) return null;
          //       if (val != params.password) return 'passwords_arent_match';
          //       return null;
          //     },
          //   ),
          // ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: () {
                  firstNameController.clear();
                  lastNameController.clear();
                  emailController.clear();
                  passwordController.clear();

                  context.router.replace(const HomeRoute());
                },
                error: (message, dictionary) async {
                  print(
                    "Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrdgdhgdhgdvyjfgghhhhhhhhhhhhhhhhhhh message: ",
                  ); //////////////////////////////////////////////////////////////  // قم بطباعة الرسالة لمراجعتها
                  log(
                    "Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrdgdhgdhgdvyjfgghhhhhhhhhhhhhhhhhhh message: ",
                  ); //////////////////////////////////////////////////////////////  // قم بطباعة الرسالة لمراجعتها

                  if (dictionary != null) errorDictionary.addAll(dictionary);
                  if (message.isNotEmpty) showToast(message: message);
                  _formKey.currentState!.validate();
                },
                orElse: () {},
              );
            },
            builder: (_, state) {
              print('Current auth state: ${state.runtimeType}');
              //////////////////////////////////////////////////////////////////////////////////////////////
              return state.maybeWhen(
                orElse:
                    () => CustomButton(
                      style: buttonStyle(radius: 30, padding: 12),
                      textStyle: TextStyle(fontSize: 13, color: textcolor),
                      onPressed: _submit,
                      label: isRegister ? 'SignUp' : 'Login',
                    ),
                loading: () => const LoadingWidget(),
                error: (message, _) {
                  // ✅ عرض الزر بعد الخطأ
                  return CustomButton(
                    style: buttonStyle(radius: 30, padding: 12),
                    textStyle: TextStyle(fontSize: 13, color: textcolor),
                    onPressed: _submit,
                    label: isRegister ? 'SignUp' : 'Login',
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegister = !isRegister;
                  });
                },
                child: Text(
                  isRegister ? 'already have an account' : ' Create an account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ).padding(top: 20);
  }
}
