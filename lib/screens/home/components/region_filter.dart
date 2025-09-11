import 'package:stroymarket/manager/6_region_manager.dart';
import 'package:stroymarket/manager/8_shop_manager.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';

import '../../../bloc/regionAll/regionAll_bloc.dart';
import '../../../bloc/regionAll/regionAll_state.dart';
import '../../../export_files.dart';

regionFilter<Widget>() {
  List<String> statusString = [
    'Chilonzor',
    'Olmazor',
    'Yakkasaroy',
  ];

  List<bool> check1 = [];
  return StatefulBuilder(
    builder: (context, setSt) {
      return SizedBox(
        height: 560.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manzilni tanlang",
                    style: TextStyle(
                      color: AppConstant.darkColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Orqaga",
                      style: TextStyle(
                        color: AppConstant.primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.1,
              ),
              // SizedBox(height: 16.h),
              BlocBuilder<RegionAllBloc, RegionAllState>(
                  builder: (context, state) {
                if (state is RegionAllSuccessState) {
                  if (state.data.length == 0) {
                    return SizedBox(
                      height: 200.h,
                      width: 1.sw,
                      child: Center(
                        child: SizedBox(
                          height: 265.h,
                          child: Text(
                            "Region mavjud emas",
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
                  List selectedValues = RegionManager.getSelectedValue(context);
                  if (selectedValues.isEmpty) {
                     RegionManager.changeSelectedValue(context, data: state.data);
                     selectedValues = state.data;
                  }
                  if (check1.isEmpty) {
                    check1 = List.generate(state.data.length,(index)=>selectedValues.any((element) => element["id"]==state.data[index]["id"]));
                  }

                

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: 170.h,
                          width: 1.sw,
                          child: ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              state.data.length,
                              (index) {
                                return CheckboxListTile(
                                  activeColor: AppConstant.primaryColor,
                                  side: BorderSide(width: 0.2.w),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    state.data[index]["name"].toString(),
                                    style: TextStyle(
                                      color: AppConstant.darkColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  value: check1[index],
                                  onChanged: (value) {
                                    setSt(
                                      () {
                                        check1[index] = value!;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          )),
                       Divider(
                thickness: 0.1,
              ),
                     SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        check1 = List.generate(state.data.length, (index) => false);
                        setSt(
                          () {},
                        );
                      },
                      child: Text(
                        "Tozalash",
                        style: TextStyle(
                          color: AppConstant.primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    CustomButton(
                      onPressed: () {
                       if (check1.any((element) => element)) {
                          RegionManager.changeSelectedValue(context, data:List.generate(state.data.length, (index) => check1[index] ? state.data[index] :   null).where((element) => element != null).toList()  );
                           ShopManager.getAll(context);
                          Navigator.pop(context);
                       }
                      },
                      text: "Qo'llash",
                      width: 150.w,
                      color: check1.any((element) => element) ? AppConstant.primaryColor : AppConstant.greyColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
                    ],
                  );
                } else if (state is RegionAllWaitingState) {
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
      );
    },
  );
}
