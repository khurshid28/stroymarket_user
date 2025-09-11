import 'package:carousel_slider/carousel_slider.dart' ;

import '../../../bloc/ads/ads_bloc.dart';
import '../../../bloc/ads/ads_state.dart';
import '../../../export_files.dart';

// ignore: must_be_immutable
class AdsSection extends StatefulWidget {
  AdsSection({Key? key, required this.ads}) : super(key: key);
  List ads;

  @override
  State<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  int activeIndex = 0;
  final carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(builder: (context, state) {
      if (state is AdsSuccessState) {
        if (state.data.length == 0) {
          return Center(
            child: SizedBox(
              height: 265.h,
              child: Text(
                "Reklama mavjud emas",
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

        return CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: state.data.length,
          options: CarouselOptions(
            height: 200.h,
            aspectRatio: 18 / 8,
            viewportFraction: 0.9,
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) => SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200.h,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    fit: BoxFit.cover,
                    imageUrl: state.data[index]["image"] != null ?  Endpoints.domain +
                        state.data[index]["image"].toString() +
                        "?key=${Endpoints.authKey}"   :  AppConstant.defaultImage,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppConstant.greyColor.withOpacity(0.6),
                      highlightColor: Colors.white70,
                      child: Container(
                        color: AppConstant.greyColor,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      print(error);
                      return const Icon(Icons.error);
                    },
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 320.w,
                        child: Text(
                          state.data[index]["title"] ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 320.w,
                        child: Text(
                          state.data[index]["subtitle"]?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      } else if (state is AdsWaitingState) {
        return SizedBox(
          height: 265.h,
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
    });
  }
}
