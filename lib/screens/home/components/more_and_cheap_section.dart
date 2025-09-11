import 'dart:math';

import '../../../export_files.dart';

// ignore: must_be_immutable
class MoreAndCheapSection extends StatelessWidget {
  MoreAndCheapSection({
    Key? key,
    required this.images,
    required this.titles,
    required this.header,
  }) : super(key: key);
  List images;
  List titles;
  Widget header;
  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: header,
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: 
          
          ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/productScreen',
                  );
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
                              imageUrl: images[index],
                              placeholder: (context, url) => Shimmer.fromColors(
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
                                  titles[index],
                                  style: TextStyle(
                                    color: AppConstant.darkColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "${(index + 1) * Random().nextInt(20)}+ Sotilgan",
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
    );
  }
}
