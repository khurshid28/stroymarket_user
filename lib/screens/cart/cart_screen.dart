// ignore_for_file: file_names, prefer_const_constructors


import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:stroymarket/bloc/savatcha/savatcha_bloc.dart';
import 'package:stroymarket/core/extensions/str.dart';
import 'package:stroymarket/manager/3_order_manager.dart';
import 'package:stroymarket/services/storage/storage_service.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';

import '../../bloc/orderCreate/orderCreate_bloc.dart';
import '../../bloc/orderCreate/orderCreate_state.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/shop/shop_state.dart';
import '../../export_files.dart';
import '../../manager/12_savatcha_manager.dart';
import '../../manager/8_shop_manager.dart';
import '../../services/loading/loading_service.dart';
import '../../services/location/location_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List data = [
    {
      "image":
          'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
      "title": "Kalit",
    },
    {
      "image":
          'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
      "title": "Bolg'a",
    },
    {
      "image":
          'https://source.unsplash.com/user/hocza/white-disposable-lighter-rXgg90zA820',
      "title": "Zajigalka",
    },
  ];

  // List texts = [
  //   {
  //     "value": false,
  //     "type": "Standard dostavka",
  //     "price": 30000,
  //   },
  //   {
  //     "value": false,
  //     "type": "Yandex orqali",
  //     "price": 20000,
  //   },
  //   {
  //     "value": false,
  //     "type": "Yandex orqali",
  //     "price": 0,
  //   },
  // ];

  Map typesText = {
    "MARKET": "Do'kondan olib ketish",
    "YANDEX": "Yandex orqali",
    "FIXED": "Standard dostavka",
  };
  String? selectedTypes;
  String? selectedLocationTypes;
  var orderLocation = null;

  LoadingService loadingService = LoadingService();

  List savatchaItem = [];
  @override
  void initState() {
    savatchaItem = StorageService().read(StorageService.savatcha) ?? [];
    if (savatchaItem.isNotEmpty) {
      ShopManager.getById(context, ShopId: savatchaItem[0]["shop_id"] ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(scaffoldKey, 'Savatcha', () {
        Navigator.of(context).pop();
      }, 'assets/icons/chevron-left.png', actions: [
        if (savatchaItem.isNotEmpty)
          GestureDetector(
              onTap: () async {
                await StorageService().remove(StorageService.savatcha);
                Fluttertoast.showToast(
                  msg: "Savatcha tozalandi",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                  textColor: Colors.white,
                  fontSize: 14.sp,
                );
                savatchaItem =
                    StorageService().read(StorageService.savatcha) ?? [];
                // SavatchaManager.changeValue(context, data: savatchaItem);
                   context.read<SavatchaBloc>().changeValue(
                               savatchaItem);
                setState(() {});
              },
              child: Icon(
                CupertinoIcons.delete,
                size: 19,
                weight: 100,
              ))
      ]),
      body: cartScreenBody(savatchaItem),
    );
  }

  cartScreenBody<Widget>(savatchaItem) {
    if (savatchaItem.isEmpty) {
      return Center(
        child: SizedBox(
          width: 365.w,
          child: Text(
            "Savatchada tovar mavjud emas",
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
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
          if (state is ShopSuccessState) {
            if (state.data == null) {
              return SizedBox(
                height: 500.h,
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
            return marketScreenBody(state.data, state.admin, state.products);
          } else if (state is ShopWaitingState) {
            return SizedBox(
              height: 500.h,
              child: Center(
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
              )),
            );
          } else {
            return SizedBox();
          }
        }),
      ],
    );
  }

  marketScreenBody<Widget>(data, admin, products) {
    print(data);
    List shopTypes = (data["types"] as List)
        .where((element) => element["value"] == "true")
        .toList();
    if (shopTypes.isEmpty) {
      selectedTypes = "MARKET";
    }
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
                child: 
                CachedNetworkImage(
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
                        final coords = Coords(
                            double.tryParse(
                                    data["location"]["lat"].toString()) ??
                                0,
                            double.tryParse(
                                    data["location"]["lon"].toString()) ??
                                0);
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
                          data["address"].toString(),
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
                          '+${admin["phone"]}',
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
                  // Divider(thickness: 0.2),
                ],
              ),
            ),
            // GridView.builder(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: products.length,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 3 / 4,
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 8.w),
            //   itemBuilder: (context, index) {
            //     return GestureDetector(
            //       onTap: () {
            //         Navigator.of(context)
            //             .pushNamed('/shopProductScreen', arguments: {
            //           "name": products[index]["name"],
            //           "product_id": products[index]["id"],
            //           "desc": products[index]["desc"],
            //            "image": products[index]["image"],
            //           "shop_id": data["id"],
            //         });
            //       },
            //       child: Container(
            //         margin: EdgeInsets.all(8.w),
            //         width: 150.w,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(color: AppConstant.greyColor),
            //           borderRadius: BorderRadius.circular(10.r),
            //         ),
            //         child: Column(
            //           children: [
            //             Expanded(
            //               flex: 7,
            //               child: SizedBox(
            //                 width: MediaQuery.of(context).size.width,
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(8.r),
            //                     topRight: Radius.circular(8.r),
            //                   ),
            //                   child: CachedNetworkImage(
            //                     fit: BoxFit.fill,
            //                     imageUrl: Endpoints.domain +
            //                         products[index]["image"].toString() +
            //                         "?key=${Endpoints.authKey}",
            //                     placeholder: (context, url) =>
            //                         Shimmer.fromColors(
            //                       baseColor:
            //                           AppConstant.greyColor.withOpacity(0.6),
            //                       highlightColor: Colors.white70,
            //                       child: Container(
            //                         color: AppConstant.greyColor,
            //                       ),
            //                     ),
            //                     errorWidget: (context, url, error) =>
            //                         const Icon(Icons.error),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 3,
            //               child: SizedBox(
            //                 width: double.infinity,
            //                 child: Padding(
            //                   padding: EdgeInsets.only(left: 10.w),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text(
            //                         products[index]["name"].toString(),
            //                         style: TextStyle(
            //                           color: AppConstant.darkColor,
            //                           fontSize: 16.sp,
            //                           fontWeight: FontWeight.w400,
            //                         ),
            //                       ),
            //                       SizedBox(height: 5.h),
            //                       Text(
            //                         "${products[index]["count"].toString()}+ Sotilgan",
            //                         style: TextStyle(
            //                           color: const Color(0xFF999999),
            //                           fontSize: 12.sp,
            //                           fontWeight: FontWeight.w300,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Tovarlar :',
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                itemCount: savatchaItem.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: AppConstant.greyColor,
                    width: 0.5,
                  ))),
                  child: Slidable(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: SizedBox(
                              width: 75.w,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: Endpoints.domain +
                                    savatchaItem[index]['image'].toString() +
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
                          title: Text(
                            savatchaItem[index]['product_name'].toString() +
                                "," +
                                savatchaItem[index]['name'].toString(),
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Soni: ' + savatchaItem[index]['count'].toString(),
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          trailing: Text(
                            (savatchaItem[index]['price'] *
                                        savatchaItem[index]['count'])
                                    .toString()
                                    .toMoney() +
                                " so'm",
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          // flex: 2,
                          spacing: 1,
                          onPressed: (BuildContext? ctx) async {
                            List savatchaData = StorageService()
                                    .read(StorageService.savatcha) ??
                                [];
                            savatchaData.removeAt(index);
                            await context.read<SavatchaBloc>().changeValue(
                               savatchaData);
                            await StorageService()
                                .write(StorageService.savatcha, savatchaData);
                            setState(() {});
                            Fluttertoast.showToast(
                              msg: "Mahsulot o'chirildi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor:
                                  AppConstant.darkColor.withOpacity(0.9),
                              textColor: Colors.white,
                              fontSize: 14.sp,
                            );
                          },
                          backgroundColor: Color(0xFFFF647C),
                          foregroundColor: Colors.white,
                          icon: CupertinoIcons.delete,
                          label: 'O\'chirish',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Dostavka turini tanlang',
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              Column(
                children: List.generate(
                  shopTypes.length,
                  (index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedTypes ==
                                  shopTypes[index]["name"].toString()
                              ? AppConstant.primaryColor
                              : AppConstant.greyColor),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 1.sw,
                    height: 75.h,
                    child: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            activeColor: AppConstant.primaryColor,
                            side: BorderSide(color: AppConstant.greyColor),
                            title: Text(
                              typesText[shopTypes[index]["name"].toString()],
                              // shopTypes[index]["name"].toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: selectedTypes ==
                                shopTypes[index]["name"].toString(),
                            onChanged: (value) {
                              setState(() {
                                selectedTypes =
                                    shopTypes[index]["name"].toString();
                              });
                            },
                          ),
                          // texts[index]["price"] != 0
                          //     ? Padding(
                          //         padding: EdgeInsets.only(left: 73.w),
                          //         child: Text(
                          //           texts[index]["price"].toString() + " so'm",
                          //           style: TextStyle(
                          //             color: AppConstant.darkColor,
                          //             fontSize: 14.sp,
                          //             fontWeight: FontWeight.w200,
                          //           ),
                          //         ),
                          //       )
                          //     : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if(selectedTypes !=null && selectedTypes !="MARKET")

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                                      'Manzilni tanlang',
                                      style: TextStyle(
                      color: AppConstant.darkColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                                      ),
                                    ),
                    ],
                  ),
              SizedBox(height: 16.h),
              Column(
                children: List.generate(
                  2,
                  (index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedLocationTypes ==
                                  ["Turgan manzil", "Boshqa manzil"][index]
                                      .toString()
                              ? AppConstant.primaryColor
                              : AppConstant.greyColor),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 1.sw,
                    height: 75.h,
                    child: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            activeColor: AppConstant.primaryColor,
                            side: BorderSide(color: AppConstant.greyColor),
                            title: Text(
                              ["Turgan manzil", "Boshqa manzil"][index],
                              // shopTypes[index]["name"].toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: selectedLocationTypes ==
                                ["Turgan manzil", "Boshqa manzil"][index]
                                    .toString(),
                            onChanged: (value) async {
                              if (index == 1) {
                                final data = await Navigator.pushNamed(
                                    context, RouteNames.selectLocation);

                                if (data != null) {
                                  print(data);
                                  orderLocation = data;
                                  selectedLocationTypes = [
                                    "Turgan manzil",
                                    "Boshqa manzil"
                                  ][index]
                                      .toString();
                                }
                              } else {
                                Position? myLocation =
                                    await LocationService.getCurrentPoint();
                                if (myLocation != null) {
                                  selectedLocationTypes = [
                                    "Turgan manzil",
                                    "Boshqa manzil"
                                  ][index]
                                      .toString();
                                  orderLocation = {
                                    "lat": myLocation.latitude,
                                    "lon": myLocation.longitude
                                  };
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Lokatsiya aniqlashda xatolik aniqlandi",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        AppConstant.darkColor.withOpacity(0.9),
                                    textColor: Colors.white,
                                    fontSize: 14.sp,
                                  );
                                }
                              }
                              setState(() {});
                            },
                          ),
                          // texts[index]["price"] != 0
                          //     ? Padding(
                          //         padding: EdgeInsets.only(left: 73.w),
                          //         child: Text(
                          //           texts[index]["price"].toString() + " so'm",
                          //           style: TextStyle(
                          //             color: AppConstant.darkColor,
                          //             fontSize: 14.sp,
                          //             fontWeight: FontWeight.w200,
                          //           ),
                          //         ),
                          //       )
                          //     : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
             
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tovarlar ",
                      style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      totalProductsPrice().toString().toMoney() + " so'm",
                      style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              if (selectedTypes != "MARKET" && selectedTypes != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dostavka ",
                        style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        selectedTypes == "FIXED"
                            ? (double.tryParse(data["delivery_amount"]
                                            .toString()) ??
                                        0)
                                    .toInt()
                                    .toString()
                                    .toMoney() +
                                " so'm"
                            : "Yandex",
                        style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Jami ",
                      style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      totalPrice(data["delivery_amount"] ?? 0)
                              .toString()
                              .toMoney() +
                          " so'm",
                      style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                onPressed: () async {
                  if (selectedTypes != null && ((selectedLocationTypes !=null && orderLocation !=null) || selectedTypes =="MARKET")) {
                    await OrderManager.create(context, data: {
                      "shop_id": savatchaItem[0]["shop_id"],
                      "delivery_type": selectedTypes?.toLowerCase(),
                      "amount": totalPrice(data["delivery_amount"] ?? 0),
                      "location": orderLocation,
                      "products": savatchaItem
                    });
                  } else if(selectedTypes ==null){
                    Fluttertoast.showToast(
                      msg: "Iltimos dostavka turini belgilang",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );
                  }else if(selectedTypes !="MARKET"){
                      Fluttertoast.showToast(
                      msg: "Iltimos manzilni belgilang",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );
                  }
                },
                text: 'Tasdiqlash',
                width: 1.sw,
                color: selectedTypes != null && ((selectedLocationTypes !=null && orderLocation !=null) || selectedTypes =="MARKET")
                    ? AppConstant.primaryColor
                    : AppConstant.greyColor,
              ),
              SizedBox(height: 16.h),
              BlocListener<OrderCreateBloc, OrderCreateState>(
                  child: SizedBox(),
                  listener: (context, state) async {
                    if (state is OrderCreateWaitingState) {
                      loadingService.showLoading(context);
                    } else if (state is OrderCreateErrorState) {
                      loadingService.closeLoading(context);

                      Fluttertoast.showToast(
                        msg: state.message ?? "Xatolik Bor",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                        textColor: Colors.white,
                        fontSize: 14.sp,
                      );
                    } else if (state is OrderCreateSuccessState) {
                      loadingService.closeLoading(context);
                      savatchaItem = [];
                      await StorageService().remove(StorageService.savatcha);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                      setState(() {});
                      Fluttertoast.showToast(
                        msg: "Buyurma raqami " +
                            state.data["order_id"].toString()+"\nBuyurtmani tarix bo'limidan kuzatishingiz mumkin ",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        
                        timeInSecForIosWeb: 3,
                        backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                        textColor: Colors.white,
                        fontSize: 14.sp,
                      );
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  int totalProductsPrice() {
    double total = 0;
    for (var i = 0; i < savatchaItem.length; i++) {
      total += savatchaItem[i]["price"] * savatchaItem[i]["count"];
    }
    return total.toInt();
  }

  num totalPrice(amount) {
    return totalProductsPrice() +
        (selectedTypes == "FIXED" ? amount : 0).toInt();
  }
}
