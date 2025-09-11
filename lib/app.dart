import 'package:stroymarket/bloc/1_send_sms/send_sms_bloc.dart';
import 'package:stroymarket/bloc/2_verify/verify_bloc.dart';
import 'package:stroymarket/bloc/ads/ads_bloc.dart';
import 'package:stroymarket/bloc/categoryAll/categoryAll_bloc.dart';
import 'package:stroymarket/bloc/news/news_bloc.dart';
import 'package:stroymarket/bloc/order/order_bloc.dart';
import 'package:stroymarket/bloc/orderAll/orderAll_bloc.dart';
import 'package:stroymarket/bloc/orderCreate/orderCreate_bloc.dart';
import 'package:stroymarket/bloc/product/product_bloc.dart';
import 'package:stroymarket/bloc/productAll/productAll_bloc.dart';
import 'package:stroymarket/bloc/productbyCategory/productbyCategory_bloc.dart';
import 'package:stroymarket/bloc/regionAll/regionAll_bloc.dart';
import 'package:stroymarket/bloc/regionSelected/regionSelected_bloc.dart';
import 'package:stroymarket/bloc/savatcha/savatcha_bloc.dart';
import 'package:stroymarket/bloc/serviceAll/serviceAll_bloc.dart';
import 'package:stroymarket/bloc/shopProduct/shopProduct_bloc.dart';
import 'package:stroymarket/bloc/worker/worker_bloc.dart';
import 'package:stroymarket/bloc/workerbyService/workerbyService_bloc.dart';

import 'bloc/shop/shop_bloc.dart';
import 'bloc/shopAll/shopAll_bloc.dart';
import 'bloc/shopbyProduct/shopbyProduct_bloc.dart';
import 'export_files.dart';
import 'package:easy_localization/easy_localization.dart';


class stroymarket extends StatelessWidget {
  const stroymarket({super.key});

  @override
  Widget build(BuildContext ctx) {

   return BlocProvider(
    create: (_) => SavatchaBloc(),
    // lazy: false,
    child:     EasyLocalization(
      supportedLocales: const [
        Locale('uz', 'UZ'),
        Locale('ru', 'RU'),
      ],
      path: 'assets/languages',
      fallbackLocale: const Locale('ru', 'RU'),
      child: ScreenUtilInit(
        designSize: const Size(390.0, 845.0),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: providers,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: RouteNames.splashScreen,
              onGenerateRoute: FullRoutes().ongenerateRoute,
              builder: MaterialAppCustomBuilder.builder,
              theme: ThemeData(
                fontFamily: 'Inter',
                useMaterial3: true,
                colorScheme: const ColorScheme.light(),
                primaryColor: AppConstant.primaryColor,
                textTheme:
                    Typography.englishLike2021.apply(fontSizeFactor: 1.sp),
              ),
            ),
          );
        },
      ),
    )
 ,
  );
  }
}

List<BlocProvider> providers = [

  //  BlocProvider<SavatchaBloc>(
  //   create: (BuildContext c) => SavatchaBloc(),
  //   lazy: false,
  // ),
  BlocProvider<SendSmsBloc>(
    create: (BuildContext context) => SendSmsBloc(),
    lazy: false,
  ),
  BlocProvider<VerifyBloc>(
    create: (BuildContext context) => VerifyBloc(),
    lazy: false,
  ),
  BlocProvider<AdsBloc>(
    create: (BuildContext context) => AdsBloc(),
    lazy: false,
  ),
  BlocProvider<NewsBloc>(
    create: (BuildContext context) => NewsBloc(),
    lazy: false,
  ),
  BlocProvider<OrderAllBloc>(
    create: (BuildContext context) => OrderAllBloc(),
    lazy: false,
  ),
  BlocProvider<OrderBloc>(
    create: (BuildContext context) => OrderBloc(),
    lazy: false,
  ),
   BlocProvider<OrderCreateBloc>(
    create: (BuildContext context) => OrderCreateBloc(),
    lazy: false,
  ),
  BlocProvider<CategoryAllBloc>(
    create: (BuildContext context) => CategoryAllBloc(),
    lazy: false,
  ),
  BlocProvider<ShopAllBloc>(
    create: (BuildContext context) => ShopAllBloc(),
    lazy: false,
  ),
    BlocProvider<ShopBloc>(
    create: (BuildContext context) => ShopBloc(),
    lazy: false,
  ),

  BlocProvider<ProductAllBloc>(
    create: (BuildContext context) => ProductAllBloc(),
    lazy: false,
  ),
  BlocProvider<ProductBloc>(
    create: (BuildContext context) => ProductBloc(),
    lazy: false,
  ),
    BlocProvider<ProductByCategoryBloc>(
    create: (BuildContext context) => ProductByCategoryBloc(),
    lazy: false,
  ),


    BlocProvider<RegionAllBloc>(
    create: (BuildContext context) => RegionAllBloc(),
    lazy: false,
  ),
   BlocProvider<RegionSelectedBloc>(
    create: (BuildContext context) => RegionSelectedBloc(),
    lazy: false,
  ),


   BlocProvider<ServiceAllBloc>(
    create: (BuildContext context) => ServiceAllBloc(),
    lazy: false,
  ),

     BlocProvider<WorkerByServiceBloc>(
    create: (BuildContext context) => WorkerByServiceBloc(),
    lazy: false,
  ),

     BlocProvider<WorkerBloc>(
    create: (BuildContext context) => WorkerBloc(),
    lazy: false,
  ),



     BlocProvider<ShopProductBloc>(
    create: (BuildContext context) => ShopProductBloc(),
    lazy: false,
  ),

   BlocProvider<ShopByProductBloc>(
    create: (BuildContext context) => ShopByProductBloc(),
    lazy: false,
  ),
 

];
