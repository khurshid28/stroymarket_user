import '../export_files.dart';
import '../services/storage/storage_service.dart';

// ignore_for_file: use_build_context_synchronously
// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  String? locale;
  SplashScreen({super.key, this.locale});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      // if (widget.locale == "uz") {
      //   await context.setLocale(const Locale("uz", "UZ"));
      // } else {
      //   await context.setLocale(const Locale("ru", "RU"));
      // }

      if ((await InternetConnectionChecker.instance.hasConnection)) {
        if ((await StorageService().read(StorageService.token)) == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.loginScreen, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.homeScreen, (r) => false);
        }
        if (_timer != null) {
          _timer!.cancel();
        }
      }

      _timer ??= Timer.periodic(const Duration(seconds: 5), (t) async {
        if ((await InternetConnectionChecker.instance.hasConnection)) {
          if ((await StorageService().read(StorageService.token)) == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.loginScreen, (r) => false);
          } else {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.homeScreen, (r) => false);
            }
          }
          if (_timer != null) {
            _timer!.cancel();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Image.asset(
          "assets/images/stroymarket.png",
          width: 220.w,
          // color: AppConstant.primaryColor,
        ),
      ),
    );
  }
}
