import 'dart:math';

import 'package:stroymarket/manager/8_shop_manager.dart';

import '../../bloc/shopAll/shopAll_bloc.dart';
import '../../bloc/shopAll/shopAll_state.dart';
import '../../export_files.dart';
import '../../manager/5_product_manager.dart';

// ignore: must_be_immutable
class MarketAllScreen extends StatefulWidget {
  MarketAllScreen({super.key});

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
  State<MarketAllScreen> createState() => _MarketAllScreenState();
}

class _MarketAllScreenState extends State<MarketAllScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    ShopManager.getAll(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(scaffoldKey, "Do\'konlar", () {
        Navigator.of(context).pop();
      }, 'assets/icons/chevron-left.png', savatcha: true),
      body: BlocBuilder<ShopAllBloc, ShopAllState>(builder: (context, state) {
        if (state is ShopAllSuccessState) {
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
          return MarketAllScreenBody(state.data ?? []);
        } else if (state is ShopAllWaitingState) {
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

  MarketAllScreenBody<Widget>(List data) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/marketScreen', arguments: {
              "id": data[index]["id"].toString(),
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
                        imageUrl: data[index]["image"] != null
                            ? Endpoints.domain +
                                data[index]["image"].toString() +
                                "?key=${Endpoints.authKey}"
                            : AppConstant.defaultImage,
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
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data[index]["name"] ?? "",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            // "${data[index]["count"]>0 ? data[index]["count"].toString()+" Sotilgan":""}",
                            data[index]["address"] ?? "",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
    );
  }
}
