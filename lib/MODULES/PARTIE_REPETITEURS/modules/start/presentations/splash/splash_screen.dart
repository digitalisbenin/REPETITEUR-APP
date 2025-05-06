import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:repetiteur_mobile_app_definitive/MODULES/PARTIE_PARENTS/modules/screens/home/home_screen.dart';
import 'package:repetiteur_mobile_app_definitive/MODULES/PARTIE_PARENTS/modules/start/presentations/onBoarding/onboarding_screen.dart';
import 'package:repetiteur_mobile_app_definitive/MODULES/PARTIE_REPETITEURS/modules/screens/home/home_screen.dart';
import 'package:repetiteur_mobile_app_definitive/MODULES/PARTIE_REPETITEURS/modules/start/presentations/splash/widgets/splash_screen_body.dart';
import 'package:repetiteur_mobile_app_definitive/core/MODEL/role/fetch_all_users_role.dart';
import 'package:repetiteur_mobile_app_definitive/core/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirst = false;
String? teacherRoleId;
  String? parentRoleId;
  @override
  void initState() {
    super.initState();
    checkFirstRun();
     fetchRoles();
  }

  Future<void> checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();

    var isFr = prefs.getBool('isFirstRun');
    if (isFr == false) {
      setState(() {
        isFirst = false;
      });
    } else {
      setState(() {
        isFirst = true;
      });
    }
  }
   Future<void> fetchRoles() async {
    final teacherId = await fetchRepetiteurRoleId();
    final parentId = await fetchParentsRoleId();

    setState(() {
      teacherRoleId = teacherId;
      parentRoleId = parentId;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // final teacherRoleId = fetchRepetiteurRoleId();
    // final parentRoleId = fetchParentsRoleId();
    final roleCheck = GetStorage().read('role_id');
    final token = GetStorage().read('token');
  
print("Token récupéré : $token");
print("role id encadreur récupéré : $teacherRoleId");
print("Role id parents récupéré : $parentRoleId");
print("role récupéré : $roleCheck");
 print("🔹 Comparaison : roleCheck ($roleCheck) == parentRoleId ($parentRoleId)");

    SizeConfig().init(context);
    return Scaffold(
      body: SplashScreenBody(
      nextScreen: token == null || token.isEmpty
          ? const OnBoardingScreen() // Redirige vers l'OnBoarding si pas de token
          : roleCheck == parentRoleId
              ? const TeacherHomeScreen()
              : const ParentHomeScreen(),
    ),
      // body: SplashScreenBody(
      //     nextScreen: isFirst
      //         ? const OnBoardingScreen()
      //         : roleCheck == parentRoleId
      //             ? const ParentHomeScreen()
      //             : const TeacherHomeScreen()),
    );
  }
}
