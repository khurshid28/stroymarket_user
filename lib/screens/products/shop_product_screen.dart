import 'package:fluttertoast/fluttertoast.dart';
import 'package:stroymarket/core/extensions/str.dart';
import 'package:stroymarket/manager/11_shop_product_manager.dart';
import 'package:stroymarket/manager/8_shop_manager.dart';
import 'package:stroymarket/services/storage/storage_service.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';
import 'package:stroymarket/widgets/common/custom_dropdown.dart';

import '../../bloc/savatcha/savatcha_bloc.dart';
import '../../bloc/shopProduct/shopProduct_state.dart';
import '../../bloc/shopProduct/shopProduct_bloc.dart';
import '../../export_files.dart';
import '../../manager/12_savatcha_manager.dart';

// ignore: must_be_immutable
class ShopProductScreen extends StatefulWidget {
  String? name;
  String? product_id;
  String? shop_id;
  String? desc;
  String? image;

  ShopProductScreen(
      {super.key,
      required this.name,
      required this.product_id,
      required this.shop_id,
      required this.desc,
      required this.image});

  @override
  State<ShopProductScreen> createState() => _ShopProductScreenState();
}

class _ShopProductScreenState extends State<ShopProductScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKey1 = GlobalKey();
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  int itemCount = 1;
  int selectTypeIndex = 0;

  @override
  void initState() {
    ShopProductManager.getAll(context,
        productId: widget.product_id ?? " ", shopId: widget.shop_id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
      key: scaffoldKey,
      appBar: new CustomAppBar(scaffoldKey, widget.name ?? "- - -", () {
        Navigator.of(context).pop();
      }, 'assets/icons/chevron-left.png', savatcha: true),
      body: BlocBuilder<ShopProductBloc, ShopProductState>(
          builder: (context, state) {
        if (state is ShopProductSuccessState) {
          if (state.data.length == 0) {
            return Center(
              child: SizedBox(
                width: 365.w,
                child: Text(
                  "Do'kon mavjud emas",
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
          return SafeArea(
              child: ShopProductScreenBody(state.data, state.tavsiyalar));
        } else if (state is ShopProductWaitingState) {
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
      }),
    );
  }

  Future addProductToSavatcha(itemData) async {
    List savatchaData = StorageService().read(StorageService.savatcha) ?? [];
    if (savatchaData.length > 0) {
      if (savatchaData[0]["shop_id"].toString() !=
          itemData["shop_id"].toString()) {
        return false;
      }
    }
    savatchaData.add({
      "id": itemData["id"],
      "name": itemData["name"],
      "product_name": itemData["product_name"],
      "image": itemData["image"],
      "price": itemData["price"],
      "count": itemData["count"],
      "shop_id": itemData["shop_id"],
      "product_id" : itemData["product_id"],
    });
    // await SavatchaManager.changeValue(context, data: savatchaData);
      context.read<SavatchaBloc>().changeValue(
                               savatchaData);
    
    await StorageService().write(StorageService.savatcha, savatchaData);
    setState(() {});
    return true;
  }

  ShopProductScreenBody<Widget>(data, tavsiyalar) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        SizedBox(
          height: 220.h,
          width: 1.sw,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:widget.image !=null ?  Endpoints.domain +
                "${widget.image}" +
                "?key=" +
                Endpoints.authKey :AppConstant.defaultImage,
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
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      'Stroymarket',
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
              Text(
                widget.desc ?? "",
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Turini tanlang',
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
              customDropdown(data[selectTypeIndex]["name"].toString(),
                  (data as List).map((e) => e["name"].toString()).toList(),
                  (v) {
                selectTypeIndex = (data as List)
                    .map((e) => e["name"].toString())
                    .toList()
                    .indexOf(v ?? "");
                if (selectTypeIndex == -1) {
                  selectTypeIndex = 0;
                }
                setState(() {});
              }),
             SizedBox(height: 16.h),
                Text(
               data[selectTypeIndex]["count"] > 0 ?  'Bu turdagi mahsulot ${data[selectTypeIndex]["count"]} ta mavjud' : "Bu turdagi mahsulot tugagan",
                style: TextStyle(
                  color: data[selectTypeIndex]["count"] > 0 ?  AppConstant.primaryColor : Color.fromARGB(255, 253, 104, 104),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
             
              SizedBox(height: 32.h),
              Row(
                children: [
                  customContainer(
                    25,
                    Image.asset(
                      'assets/icons/minus.png',
                      scale: 3.sp,
                    ),
                    () {
                      setState(() {
                        if (itemCount > 1) {
                          itemCount--;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5.w),
                  customContainer(
                    30,
                    Text(
                      itemCount.toString(),
                      style: TextStyle(
                        color: AppConstant.primaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    () {},
                  ),
                  SizedBox(width: 5.w),
                  customContainer(
                    25,
                    Image.asset(
                      'assets/icons/plus.png',
                      scale: 3.sp,
                    ),
                    () {
                      setState(() {
                        itemCount++;
                      });
                    },
                  ),
                  Spacer(),
                  Text(
                    (itemCount * data[selectTypeIndex]["price"])
                            .toString()
                            .toMoney() +
                        " so'm",
                    style: TextStyle(
                      color: AppConstant.darkColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              CustomButton(
                onPressed: () async {
                  if (data[selectTypeIndex]["count"] >= itemCount ) {
                    if (await addProductToSavatcha({
                    "id": data[selectTypeIndex]["id"],
                    "name": data[selectTypeIndex]["name"],
                    "product_name": widget.name ?? "",
                    "image": (widget.image ?? ""),
                    "price": data[selectTypeIndex]["price"],
                    "count": itemCount,
                    "shop_id": (widget.shop_id ?? ""),
                    "product_id" : (widget.product_id ?? ""),
                  }
                  )) {
                    itemCount= 1;

                    setState(() {});
                    // ShopProductManager.refresh(context,
                    //  productId: widget.product_id ?? " ", shopId: widget.shop_id ?? "");

                    Fluttertoast.showToast(
                      msg: "Mahsulot qo'shildi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );

                  } else {
                    Fluttertoast.showToast(
                      msg: "Boshqa do'kondan mahsulot qo'shib bo'lmaydi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );
                  }
                  } else {
                      Fluttertoast.showToast(
                      msg: "Mahsulot yetarli emas",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppConstant.darkColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.sp,
                    );
                  }

               
                },
                text: "Savatchaga qo'shish",
                width: 1.sw,
                color: data[selectTypeIndex]["count"] >= itemCount ?   AppConstant.primaryColor  : AppConstant.greyColor,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        // MoreAndCheapSection(
        //   images: images,
        //   titles: titles,
        //   header: HeaderSections(
        //     title: "Siz uchun tavsiyalar",
        //     onTap: () {
        //       Navigator.of(context).pushNamed(
        //         '/productsScreen',
        //       );
        //     },
        //   ),
        // ),

        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text(
                    "Siz uchun tavsiyalar",
                    style: TextStyle(
                      color: AppConstant.darkColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                itemCount: tavsiyalar.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/shopProductScreen',
                          arguments: {
                            "name": tavsiyalar[index]["name"],
                            "product_id": tavsiyalar[index]["id"],
                            "shop_id": widget.shop_id,
                            "image": widget.image,
                            "desc": widget.desc,
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16.w),
                      width: 150.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppConstant.greyColor),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.shade300,
                        //     blurRadius: 5,
                        //     spreadRadius: 3,
                        //     offset: const Offset(0, 3),
                        //   ),
                        // ],
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
                                      "${tavsiyalar[index]["image"]}" +
                                      "?key=" +
                                      Endpoints.authKey,
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
                                      tavsiyalar[index]["name"].toString(),
                                      style: TextStyle(
                                        color: AppConstant.darkColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "${tavsiyalar[index]["count"]}+ Sotilgan",
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
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  customContainer(double width, Widget child, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width.w,
        height: width.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
