// ignore_for_file: file_names, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:stroymarket/core/extensions/date_extension.dart';
import 'package:stroymarket/core/extensions/str.dart';

import '../../bloc/order/order_bloc.dart';
import '../../bloc/order/order_state.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/shop/shop_state.dart';
import '../../export_files.dart';
import '../../manager/3_order_manager.dart';
import '../../manager/8_shop_manager.dart';
import '../../services/loading/loading_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusScreen extends StatefulWidget {
  String? id;
  String? order_id;
  String? shop_id;
  String? status;

  StatusScreen({
    super.key,
    required this.order_id,
    required this.id,
    required this.shop_id,
    required this.status,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    OrderManager.getByid(context, id: widget.id ?? "");

    ShopManager.getById(context, ShopId: widget.shop_id ?? "");

    super.initState();
  }

  LoadingService loadingService = LoadingService();
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          scaffoldKey,
          'Buyurtma : ${widget.order_id ?? "- - -"}',
          () {
            Navigator.of(context).pop();
          },
          'assets/icons/chevron-left.png',
        ),
        body: Stack(
          children: [
            SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
                    if (state is ShopSuccessState) {
                      if (state.data == null) {
                        return SizedBox(
                          height: 400.h,
                          child: Center(
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
                          ),
                        );
                      }
                      return marketScreenBody(
                          state.data, state.admin, state.products);
                    } else if (state is ShopWaitingState) {
                      return SizedBox(
                        height: 400.h,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppConstant.primaryColor,
                              strokeWidth: 6.w,
                              strokeAlign: 2,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  AppConstant.primaryColor.withOpacity(0.2),
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
                        )),
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
                  BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
                    if (state is OrderSuccessState) {
                      if (state.data == null) {
                        return SizedBox(
                          height: 400.h,
                          child: Center(
                            child: SizedBox(
                              width: 365.w,
                              child: Text(
                                "Zakas mavjud emas",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return statusScreenBody(state.data ?? []);
                    } else if (state is OrderWaitingState) {
                      return SizedBox(
                        height: 400.h,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppConstant.primaryColor,
                              strokeWidth: 6.w,
                              strokeAlign: 2,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  AppConstant.primaryColor.withOpacity(0.2),
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
                        )),
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                widget.status == "CANCELED"
                    ? "assets/images/error_bg.png"
                    : "assets/images/success_bg.png",
                width: 1.sw,
                fit: BoxFit.fitWidth,
                color: widget.status == "STARTED"
                    ? Color(
                        0XFFFFCF5C,
                      )
                    : (widget.status == "FINISHED"
                        ? Color(
                            0xFF0084F4,
                          )
                        : null),
              ),
            ),
          ],
        ));
  }

  productsText(List products) {
    print(">>>>>>>>>>" + products.toString());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Mahsulotlar",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppConstant.darkColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: products
              .map((e) => SizedBox(
                    width: 1.sw - 32.w,
                    height: 80.h,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: SizedBox(
                          width: 75.w,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: e["image"] != null ?  Endpoints.domain +
                        e["image"].toString() +
                        "?key=${Endpoints.authKey}"   :  AppConstant.defaultImage,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppConstant.greyColor.withOpacity(0.6),
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
                      title: Text(
                        e["shop_product"]["product_item"]["name"].toString() +
                            "," +
                            e["shop_product"]["product_item"]["product"]["name"].toString(),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Soni: ' + (e['count'] ?? "" ).toString() ,
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      trailing: Text(
                        ((e['amount'] ?? 0 ) *(e['count'] ?? 0)).toString().toMoney() +
                            " so'm",
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ))

              //  SizedBox(
              //     width: 240.w,
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Text(
              //           "NOMI: ${e["name"]} ${e["name"]} \nSONI: ${e["count"]} \nNARXI:  " +
              //               "${e["price"]}".toMoney() +
              //               " so'm",
              //           style: TextStyle(
              //             fontSize: 14.sp,
              //             color: AppConstant.darkColor,
              //             fontWeight: FontWeight.w200,
              //           ),
              //           textAlign: TextAlign.start,
              //         ),
              //         if (products.indexOf(e) != products.length - 1)
              //           Divider(thickness: 0.1),
              //       ],
              //     )))

              .toList(),
        ),
      ],
    );
  }

  marketScreenBody<Widget>(data, admin, products) {
    print(data);
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  imageUrl:data["image"] !=null ?  Endpoints.domain +
                      data["image"].toString() +
                      "?key=${Endpoints.authKey}" :AppConstant.defaultImage,
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
                          'assets/icons/home.png',
                          scale: 3.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          data["name"] ?? "",
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
                          'assets/icons/map-pin.png',
                          scale: 3.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          data["address"]?? "",
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
                       admin?["phone"] ?? "",
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
                  Divider(thickness: 0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  statusScreenBody(data) {
    Map deliveryTexts = {
      "MARKET": "Do'kondan olib ketish",
      "YANDEX": "Yandex orqali yetqazish",
      "FIXED": "Standart yetqazish",
    };
    List<String> text = [
      'Sana',
      'Narxi',
      'Xarid Turi',
      'Mahsulotlar',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            4,
            (index) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  // height: 50.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: index != 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                [
                                  ...text,
                                ][index],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppConstant.darkColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 180.w,
                                child: Text(
                                  [
                                    DateTime.tryParse(
                                            "${data["createdt"] ?? ""}")
                                        .toMyFormatStatus(),
                                    "${data["amount"] ?? ""}".toMoney() +
                                        " so'm",
                                    deliveryTexts[
                                        data?["delivery_type"] ?? "MARKET"],
                                    "- - -",
                                  ][index],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppConstant.darkColor,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          )
                        : productsText(data["products"] ?? []),
                  ),
                ),
                Divider(thickness: 0.1),
              ],
            ),
          )),
    );
  }
}
