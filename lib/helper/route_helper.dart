
import 'package:charts_application/pages/home/home_page.dart';
import 'package:charts_application/pages/sign_pages/sign_in_page.dart';
import 'package:charts_application/pages/sign_pages/sign_up_page.dart';
import 'package:get/get.dart';


class RouteHelper 
{

  static const String signIn = "/sign_in_page";
  static const String signUp = "/sign_up_page";
  static const String home = "/home_page";

static const String medicalCenterDetails = "/medical_center_details_page";


  static String getHome()=>home;
   
  static String getSignIn()=>signIn;
  static String getSignUp()=>signUp;

  static List<GetPage> routes = 
  [       
          GetPage(name: home, page: ()=>const HomePage() ,transition: Transition.zoom),
          GetPage(name:signIn, page: ()=>const SigninPage(),transition: Transition.rightToLeftWithFade,    transitionDuration: const Duration(milliseconds: 400),),
          GetPage(name:signUp, page: ()=> const SignupPage(),transition: Transition.leftToRightWithFade   , transitionDuration: const Duration(milliseconds: 400),),
           
          
          
  ];
}