import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stroymarket/export_files.dart';
import 'package:stroymarket/manager/10_services_manager.dart';
import 'package:stroymarket/manager/12_savatcha_manager.dart';
import 'package:stroymarket/manager/3_order_manager.dart';
import 'package:stroymarket/manager/4_category_manager.dart';
import 'package:stroymarket/manager/6_region_manager.dart';
import 'package:stroymarket/manager/7_ads_manager.dart';
import 'package:stroymarket/screens/home/components/ads_scetion.dart';
import 'package:stroymarket/screens/home/components/category_section.dart';
import 'package:stroymarket/screens/home/components/header_section.dart';
import 'package:stroymarket/screens/home/components/more_and_cheap_section.dart';
import 'package:stroymarket/screens/home/components/region_filter.dart';
import 'package:stroymarket/screens/home/components/services_section.dart';
import 'package:stroymarket/screens/home/components/shop_section.dart';
import 'package:stroymarket/widgets/common/custom_bottomsheet.dart';
import 'package:stroymarket/widgets/common/custom_drawer.dart';

import '../../bloc/savatcha/savatcha_bloc.dart';
import '../../manager/8_shop_manager.dart';
import '../../services/storage/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> images = [
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/white-disposable-lighter-rXgg90zA820',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/white-disposable-lighter-rXgg90zA820',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
  ];

  List<String> ads = [
    'https://source.unsplash.com/user/tamanna_rumee/text-lpGm415q9JA',
    'https://source.unsplash.com/user/tamanna_rumee/text-hGLc8L-EcCM',
    'https://source.unsplash.com/user/tamanna_rumee/text-Wt33T42JNCM',
    'https://source.unsplash.com/user/tamanna_rumee/red-and-white-love-print-gift-box-Ew5pLCfW0zw',
    'https://source.unsplash.com/user/tamanna_rumee/red-and-white-love-print-textile-R4viFLEqOWU',
  ];

  List<String> titles = [
    'Kalit',
    "Bolg'a",
    'Zajigalka',
    "Bolg'a",
    'Kalit',
    'Kalit',
    "Bolg'a",
    'Zajigalka',
    "Bolg'a",
    'Kalit',
  ];

  @override
  void initState() {
    super.initState();
    OrderManager.getAll(context);
    CategoryManager.getAll(context);
    ShopManager.getAll(context);
    AdsManager.getAll(context);
     ServicesManager.getAll(context);
    List savatchaItem = StorageService().read(StorageService.savatcha) ?? [];
    // SavatchaManager.changeValue(context, data: savatchaItem);
        context.read<SavatchaBloc>().changeValue(
                               savatchaItem);
  }

  @override
  Widget build(BuildContext ctx) {
    return RefreshIndicator(
      displacement: 60.h,
      backgroundColor: AppConstant.primaryColor,
      color: Colors.white,
      strokeWidth: 2.h,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        setState(() {});
        OrderManager.getAll(context);
        CategoryManager.getAll(context);
        ShopManager.getAll(context);
        AdsManager.getAll(context);
        List savatchaItem =
            StorageService().read(StorageService.savatcha) ?? [];
         context.read<SavatchaBloc>().changeValue(
                               savatchaItem);
      },
      child: Scaffold(
        key: scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.black26,
        appBar: CustomAppBar(scaffoldKey, 'Asosiy', () {
          scaffoldKey.currentState!.openDrawer();
          
        }, 'assets/icons/menu.png', savatcha: true),
        drawer: CustomDrawer(scaffoldKey: scaffoldKey),
        floatingActionButton: customFloatingButton(),
        body: SafeArea(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pushNamed(
                    '/searchScreen',
                  );
                },
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppConstant.greyColor),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        color: AppConstant.darkColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Mahsulot izlang',
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AdsSection(ads: ads),
              SizedBox(height: 16.h),
              CategorySection(
               
                header: HeaderSections(
                  title: 'Kategoriyalar',
                  onTap: () {
                    Navigator.of(ctx).pushNamed(
                      '/categoryScreen',
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              ShopSection(
                header: HeaderSections(
                  title: 'Do\'konlar',
                  onTap: () {
                    Navigator.of(ctx).pushNamed(
                      '/marketAllScreen',
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

               ServiceSection(
                header: HeaderSections(
                  title: 'Xizmatlar',
                  onTap: () {
                    Navigator.of(ctx).pushNamed(
                      '/serviceAllScreen',

                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              MoreAndCheapSection(
                images: images,
                titles: titles,
                header: HeaderSections(
                  title: "Eng ko'p sotilgan",
                  onTap: () {
                    // Navigator.of(ctx).pushNamed(
                    //   '/productsScreen',
                    // );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              // MoreAndCheapSection(
              //   images: images,
              //   titles: titles,
              //   header: HeaderSections(
              //     title: "Eng Arzon",
              //     onTap: () {
              //       Navigator.of(context).pushNamed(
              //         '/productsScreen',
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  customFloatingButton<Widget>() {
    return FloatingActionButton.small(
      onPressed: () {
        RegionManager.getAll(context);
        customBottomsheet(
          context,
          Container(
            height: 350.h,
            child: regionFilter(),
          ),
        );
      },
      backgroundColor: AppConstant.primaryColor,
      child: Image.asset(
        'assets/icons/map-pin.png',
        scale: 3.sp,
        color: Colors.white,
      ),
    );
  }
}
