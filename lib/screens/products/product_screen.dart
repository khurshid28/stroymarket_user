import 'package:fluttertoast/fluttertoast.dart';
import 'package:stroymarket/manager/5_product_manager.dart';
import 'package:stroymarket/manager/8_shop_manager.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';
import 'package:stroymarket/widgets/common/custom_dropdown.dart';

import '../../bloc/product/product_bloc.dart';
import '../../bloc/product/product_state.dart';
import '../../bloc/shopbyProduct/shopbyProduct_bloc.dart';
import '../../bloc/shopbyProduct/shopbyProduct_state.dart';
import '../../export_files.dart';
import '../home/components/header_section.dart';
import '../home/components/more_and_cheap_section.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  String? name;
  String? product_id;
  ProductScreen({super.key, required this.name, required this.product_id});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKey1 = GlobalKey();
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

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

  List<Map> products = [
    {"name": '4 ta tishlik Kalit', "price": "400 000 so'm"},
    {"name": 'Qulf uchun kalit', "price": "90 000 so'm"},
    {"name": 'Darvoza kaliti', "price": "250 000 so'm"},
    {"name": '4 ta tishlik Kalit', "price": "400 000 so'm"},
  ];

  String dropdownValue = 'Turlari';
  List<String> items = [
    'Turlari',
    'Oq - 3kg - metal idishli',
    'Qizil - 4kg - yog\'och idishli',
    'Yashil - 3kg - plastik idishli',
    'Sariq - 7kg - shisha idishli',
  ];
  int itemCount = 1;

  @override
  void initState() {
    ProductManager.getById(context, ProductId: widget.product_id ?? "");
    ShopManager.getByProductId(context, productId: widget.product_id ?? "");
    super.initState();
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
      body: SafeArea(child: ProductScreenBody()),
    );
  }

  ProductScreenBody<Widget>() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductSuccessState) {
            if (state.data == null) {
              return SizedBox(
                height: 400.h,
                child: Center(
                  child: SizedBox(
                    width: 365.w,
                    child: Text(
                      "Mahsulot mavjud emas",
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 220.h,
                  width: 1.sw,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: state.data["image"] != null ?  Endpoints.domain +
                        state.data["image"].toString() +
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
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
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
                        state.data["desc"].toString(),
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is ProductWaitingState) {
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

        Divider(thickness: 0.2),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                "Tovar mavjud do'\konlar",
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
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
        SizedBox(height: 16.h),
        BlocBuilder<ShopByProductBloc, ShopByProductState>(
            builder: (context, state) {
          if (state is ShopByProductSuccessState) {
            if (state.data.length == 0) {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: SizedBox(
                    width: 365.w,
                    child: Text(
                      "Do\'kon mavjud emas",
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
            return ShopByProductScreenBody(state.data ?? []);
          } else if (state is ShopByProductWaitingState) {
            return SizedBox(
              height: 200.h,
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

  Widget ShopByProductScreenBody(List data) {
    return SizedBox(
      width: 1.sw,
      height: 200.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/marketScreen', arguments: {
                "id": data[index]["id"],
                "name": data[index]["name"],
              });
            },
            child: Container(
              margin: EdgeInsets.all(10.w),
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: Endpoints.domain +
                              "${data[index]["image"]}" +
                              "?key=" +
                              Endpoints.authKey,
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
                              "${data[index]["name"]}",
                              style: TextStyle(
                                color: AppConstant.darkColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              // "${data[index]["count"]>0 ? data[index]["count"].toString()+" Sotilgan":""}",
                              data[index]["address"].toString(),
                              style: TextStyle(
                                color: const Color(0xFF999999),
                                fontSize: 10.sp,
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
    );
  }
}
