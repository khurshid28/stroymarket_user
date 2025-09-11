import 'package:stroymarket/screens/location/selectLocation_screen.dart';
import 'package:stroymarket/screens/market/market_Screen.dart';
import 'package:stroymarket/screens/market/market_all_Screen.dart';
import 'package:stroymarket/screens/news/news_Screen.dart';
import 'package:stroymarket/screens/services/serviceAll_screen.dart';
import 'package:stroymarket/screens/services/workers_screen.dart';
import 'package:stroymarket/screens/sms_confirm/sms_screen.dart';

import '../export_files.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/products/product_screen.dart';
import '../screens/services/worker_screen.dart';
import '../screens/splash_screen.dart';

class FullRoutes {
  Route? ongenerateRoute(RouteSettings settings) {
    String? routeName = settings.name;
    dynamic args = settings.arguments;

    switch (routeName) {
      case RouteNames.splashScreen:
        return customPageRoute(
          SplashScreen(),
        );
      case RouteNames.loginScreen:
        return customPageRoute(const LoginScreen());
      case RouteNames.smsScreen:
        return customPageRoute(SmsScreen(
          id: args != null ? args["id"] : null,
        ));

      case RouteNames.homeScreen:
        return customPageRoute(const HomeScreen());
      case RouteNames.marketScreen:
        return customPageRoute(MarketScreen(
          id: args != null ? args["id"] : null,
          name: args != null ? args["name"] : null,
        ));
      case RouteNames.marketAllScreen:
        return customPageRoute(MarketAllScreen());

      case RouteNames.cartScreen:
        return customPageRoute(CartScreen());
      case RouteNames.categoryScreen:
        return customPageRoute(CategoryScreen());

      case RouteNames.servieAllScreen:
        return customPageRoute(ServiceAllScreen());
      case RouteNames.workersScreen:
        return customPageRoute(WorkersScreen(
          data: args != null ? args["data"] : null,
        ));
      case RouteNames.workerScreen:
        return customPageRoute(WorkerScreen(
          id: args != null ? args["id"] : null,
          name: args != null ? args["name"] : null,
        ));
      case RouteNames.selectLocation:
        return customPageRoute(SelectLocationScreen());

      case RouteNames.historyScreen:
        return customPageRoute(const HistoryScreen());
      case RouteNames.settingsScreen:
        return customPageRoute(const SettingsScreen());
      case RouteNames.statusScreen:
        return customPageRoute(StatusScreen(
          id: args != null ? args["id"] : null,
          order_id: args != null ? args["order_id"] : null,
          shop_id: args != null ? args["shop_id"] : null,
          status: args != null ? args["status"] : null,
        ));
      case RouteNames.productsScreen:
        return customPageRoute(ProductsScreen(
          data: args != null ? args["data"] : null,
        ));
      case RouteNames.shopProductScreen:
        return customPageRoute(ShopProductScreen(
          name: args != null ? args["name"] : null,
          product_id: args != null ? args["product_id"] : null,
          shop_id: args != null ? args["shop_id"] : null,
          desc: args != null ? args["desc"] : null,
          image: args != null ? args["image"] : null,
        ));
      case RouteNames.productScreen:
        return customPageRoute(ProductScreen(
          name: args != null ? args["name"] : null,
          product_id: args != null ? args["product_id"] : null,
        ));

      case RouteNames.newsScreen:
        return customPageRoute(NewsScreen());

      case RouteNames.searchScreen:
        return customPageRoute(SearchScreen());

      default:
        return customPageRoute(const NotFoundScreen());
    }
  }

  customPageRoute(Widget child) {
    return MaterialPageRoute(
      builder: (context) => child,
    );
  }
}
