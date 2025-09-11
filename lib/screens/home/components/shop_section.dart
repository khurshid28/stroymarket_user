import 'package:stroymarket/bloc/shopAll/shopAll_bloc.dart';
import 'package:stroymarket/bloc/shopAll/shopAll_state.dart';

import '../../../export_files.dart';

// ignore: must_be_immutable
class ShopSection extends StatelessWidget {
  ShopSection({Key? key, required this.header})
      : super(key: key);
  Widget header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          header,
          SizedBox(height: 16.h),
          BlocBuilder<ShopAllBloc, ShopAllState>(builder: (context, state) {
            if (state is ShopAllSuccessState) {
              if (state.data.length == 0) {
                return Center(
                  child: SizedBox(
                    height: 80.h,
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
              return Container(
                height: 60.h,
                width: 1.sw,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:state.data.length < 5 ?state.data.length :  5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/marketScreen', arguments: {
                          "id": state.data[index]["id"].toString(),
                          "name": state.data[index]["name"],
                        });
                      },
                      child: Container(
                        width: 60.w,
                         height: 60.w,
                        margin: index == 0
                            ? EdgeInsets.only(left: 0)
                            : EdgeInsets.only(left: 12.w),
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(30.w),
                          border: Border.all(color: AppConstant.greyColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.w),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
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
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
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
                    height: 30.h,
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
        ],
      ),
    );
  }
}
