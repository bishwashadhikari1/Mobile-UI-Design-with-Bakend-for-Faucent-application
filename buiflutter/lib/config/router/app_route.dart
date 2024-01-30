// import 'package:talab/features/auth/registration/registration_feature.dart';
import 'package:talab/features/auth/presentation/view/auth_view.dart';
import 'package:talab/features/auth/presentation/view/signup_success.dart';
import 'package:talab/features/auth/presentation/viewmodel/signup_page.dart';
import 'package:talab/features/contract/presentation/view/contract_view.dart';
import 'package:talab/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:talab/features/splash/presentation/view/splashscreen.dart';
import 'package:talab/features/wallet/presentation/view/add_money.dart';
import 'package:talab/features/wallet/presentation/view/withdraw_money.dart';
import 'package:talab/features/welcomepage/welcome_page_feature.dart';

class AppRoute {
  AppRoute._();
  static const String welcomePage = '/welcomepage';
  static const String signupPage = '/signuppage';
  static const String loginregisterRoute = '/';
  static const String dashboardRoute = '/dashboard';
  static const String splashScreenRoute = '/splashscreen';
  static const String addMoneyRoute = '/addMoneyRoute';
  static const String withdrawRoute = '/withdrawRoute';
  static const String contractRoute = '/contract';
  static const String sucesssignup = '/sucesssignup';

  static getAppRoutes() {
    return ({
      signupPage: (context) => RegisterPage(),
      sucesssignup: (context) =>  AccountCreatedPage(),
      loginregisterRoute: (context) => const LoginRegisterView(),
      welcomePage: (context) => const WelcomePage(),
      splashScreenRoute: (context) => const TalabSplash(),
      dashboardRoute: (context) => const DashboardView(),
      addMoneyRoute: (context) => const AddMoneyView(),
      '/withdrawRoute': (context) => const WithdrawMoneyView(),
      contractRoute: (context) => const ContractView(),
    });
  }
}
