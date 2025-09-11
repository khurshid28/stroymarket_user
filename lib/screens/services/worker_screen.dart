import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:stroymarket/core/extensions/str.dart';
import 'package:stroymarket/manager/10_services_manager.dart';

import '../../bloc/worker/worker_bloc.dart';
import '../../bloc/worker/worker_state.dart';
import '../../export_files.dart';
import '../../widgets/common/custom_button.dart';

// ignore: must_be_immutable
class WorkerScreen extends StatefulWidget {
  String? id;
  String? name;
  WorkerScreen({super.key, required this.id, required this.name});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKey1 = GlobalKey();
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  Map payment_dates = {"day": "kun", "month": "oy", "week": "hafta"};
  @override
  void initState() {
    super.initState();
    ServicesManager.getWorkerById(context, WorkerId: widget.id ?? "");
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
      body: SafeArea(child:
          BlocBuilder<WorkerBloc, WorkerState>(builder: (context, state) {
        if (state is WorkerSuccessState) {
          if (state.data == null) {
            return Center(
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
            );
          }
          return WorkerScreenBody(
            state.data,
          );
        } else if (state is WorkerWaitingState) {
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
      })),
    );
  }

  WorkerScreenBody<Widget>(data) {
    print(data);
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150.h,
                width: 150.h,
              // width: 1.sw,
                decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75.h),
                          border: Border.all(color: AppConstant.greyColor),
                        ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(110.h),
                child: CachedNetworkImage(
                  width: 222.h,
                  height: 222.h,
                  fit: BoxFit.cover,
                  imageUrl: Endpoints.domain +
                      data["image"].toString() +
                      "?key=${Endpoints.authKey}",
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
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                 SizedBox(
                       width: MediaQuery.of(context).size.width - 32.w,
                       child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                    child: Icon(CupertinoIcons.person_alt_circle),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 5.w,
                                    ),
                                  ),
                       
                                  //  SizedBox(height: 5.h),
                                  TextSpan(
                                    text: "${data["fullname"]}",
                                    style: TextStyle(
                                      color: AppConstant.darkColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
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
                          '+${data["phone"]}',
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
                        Icon(CupertinoIcons.money_dollar),
                        SizedBox(width: 10.w),
                        Text(
                          "${data["amount"]}".toMoney() +
                              " so'\m / " +
                              payment_dates["${data["payment_type"]}"]
                                  .toString(),
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
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 32.w,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(Icons.info_outline_rounded),
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                width: 5.w,
                              ),
                            ),

                            //  SizedBox(height: 5.h),
                            TextSpan(
                              text: data["desc"].toString() * 10,
                              style: TextStyle(
                                color: AppConstant.darkColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                 SizedBox(height: 32.h),
               
                
                  CustomButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(
                          "+${data["phone"]}");
                    },
                    text: "Bog'lanish",
                    width: 1.sw,
                  ),
                  SizedBox(height: 70.h),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
