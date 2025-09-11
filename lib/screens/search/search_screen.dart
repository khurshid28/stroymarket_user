import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stroymarket/bloc/productAll/productAll_state.dart';
import 'package:stroymarket/manager/5_product_manager.dart';

import '../../bloc/productAll/productAll_bloc.dart';
import '../../export_files.dart';
import '../../widgets/common/custom_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController controller = TextEditingController();
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    ProductManager.getAll(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey,
        'Izlash',
        () {
          Navigator.of(context).pop();
        },
        'assets/icons/chevron-left.png',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomTextField(
                icon: Icon(CupertinoIcons.search),
                text: 'Mahsulot izlang',
                controller: controller,
                // textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                onChanged: (v) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 8.h),
            BlocBuilder<ProductAllBloc, ProductAllState>(
                builder: (context, state) {
              if (state is ProductAllSuccessState) {
                final data =((state.data ?? [])
                    .where((element) => element["name"]
                        .toString()
                        .toLowerCase()
                        .contains(controller.text.toString().toLowerCase()))
                    .toList());
                if (data.length == 0) {
                  return SizedBox(
                    height: 450.h,
                    
                    child: Center(
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
                  );
                }


                
                return productsScreenBody(data);
              } else if (state is ProductAllWaitingState) {
                return SizedBox(
                    height: 450.h,
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
                      ),
                    ));
              } else {
                return SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget productsScreenBody(List data) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/productScreen',
                  arguments: {
                "product_id" : data[index]["id"],
                "name" : data[index]["name"],

              }
            );
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
                        fit: BoxFit.cover,
                        imageUrl: data[index]["image"] != null ?  Endpoints.domain +
                        data[index]["image"].toString() +
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
                            data[index]["name"],
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "${data[index]["count"]}+ Sotilgan",
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
    );
  }
}
