import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:stroymarket/core/extensions/str.dart';
import 'package:stroymarket/manager/8_shop_manager.dart';

import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/shop/shop_state.dart';
import '../../export_files.dart';

// ignore: must_be_immutable
class MarketScreen extends StatefulWidget {
  String? id;
  String? name;
  MarketScreen({super.key, required this.id, required this.name});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKey1 = GlobalKey();
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

 
  @override
  void initState() {
    super.initState();
    ShopManager.getById(context, ShopId: widget.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey,
        widget.name ?? "",
        () {
          Navigator.of(context).pop();
        },
        'assets/icons/chevron-left.png',
      ),
      body: SafeArea(
          child:
          
           BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
        if (state is ShopSuccessState) {
          if (state.data == null) {
            return Center(
              child: SizedBox(
                width: 365.w,
                child: Text(
                  "Do'\kon mavjud emas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          }
          return marketScreenBody(state.data, state.admin, state.products);
        } else if (state is ShopWaitingState) {
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppConstant.primaryColor,
                strokeWidth: 6.w,
                strokeAlign: 2,
                strokeCap: StrokeCap.round,
                backgroundColor: AppConstant.primaryColor.withOpacity(0.2),
              ),
              SizedBox(
                height: 48.h,
              ),
              SizedBox(
                width: 365.w,
                child: Text(
                  "Ma\'lumot yuklanmoqda...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ));
        } else {
          return SizedBox();
        }
      })
      ),
   
    );
  }

  marketScreenBody<Widget>(data, admin, products) {
    print(data);
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
              SizedBox(
          height: 220.h,
          width: 1.sw,
          child: Stack(
            children: [
              SizedBox(
                height: 220.h,
                width: 1.sw,
                child: CachedNetworkImage(
                   imageUrl: data["image"] != null ?  Endpoints.domain +
                        data["image"].toString() +
                        "?key=${Endpoints.authKey}"   :  AppConstant.defaultImage,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppConstant.greyColor.withOpacity(0.6),
                    highlightColor: Colors.white70,
                    child: Container(
                      color: AppConstant.greyColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                  bottom: 20.w,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () async {
                     
    try {
      final coords = Coords(double.tryParse(data["location"]["lat"].toString()) ?? 0,double.tryParse(data["location"]["lon"].toString()) ?? 0);
      final title = data["name"] ?? "";
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Wrap(
                  children: [
                   
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                         clipBehavior: Clip.none,
                        ),
                      ),
                      
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  
                    },
                    child: Padding(
                      padding: EdgeInsets.all(6.0.w),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.w, color: AppConstant.primaryColor),
                            shape: BoxShape.circle),
                        child: Image.asset(
                          width: 18.w,
                          height: 18.w,
                          'assets/images/go_location.png',
                          color: AppConstant.primaryColor,
                          // scale: 3.sp,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
     
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/map-pin.png',
                          scale: 3.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          data["address"] ?? "",
                          style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/smartphone.png',
                          scale: 3.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                        admin?["phone"] != null ?   '+${admin["phone"]}' : "",
                          style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.car_detailed),
                        SizedBox(width: 10.w),
                        ...[
                      if(data["yandex_delivery"] == true)    Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'YANDEX',
                                      style: TextStyle(
                                        color: AppConstant.darkColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.check_mark,
                                      color: AppConstant.primaryColor,
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                )
                        ,

                          if(data["fixed_delivery"] == true)    Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'FIXED',
                                      style: TextStyle(
                                        color: AppConstant.darkColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.check_mark,
                                      color: AppConstant.primaryColor,
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                       

                         if(data["market_delivery"] == true)    Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'MARKET_DELIVERY',
                                      style: TextStyle(
                                        color: AppConstant.darkColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.check_mark,
                                      color: AppConstant.primaryColor,
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                )
                       
                        
                        ]
                      ],
                    ),
                  ),
                 
                 
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.money_dollar),
                        SizedBox(width: 10.w),
                        Text(
                        data["delivery_amount"] !=null ?   '${data["delivery_amount"]}'.toMoney() + " so'\m" :"",
                          style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(thickness: 0.2),
                ],
              ),
            ),
            GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/shopProductScreen', arguments: {
                      "name": products[index]["name"],
                      "product_id": products[index]["id"],
                      "desc": products[index]["desc"],
                       "image": products[index]["image"],
                      "shop_id": data["id"],
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppConstant.greyColor),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: Endpoints.domain +
                                    products[index]["image"].toString() +
                                    "?key=${Endpoints.authKey}",
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor:
                                      AppConstant.greyColor.withOpacity(0.6),
                                  highlightColor: Colors.white70,
                                  child: Container(
                                    color: AppConstant.greyColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    products[index]["name"].toString(),
                                    style: TextStyle(
                                      color: AppConstant.darkColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "${products[index]["count"].toString()}+ Sotilgan",
                                    style: TextStyle(
                                      color: const Color(0xFF999999),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

}
