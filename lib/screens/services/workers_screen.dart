import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:stroymarket/core/extensions/str.dart';
import 'package:stroymarket/manager/10_services_manager.dart';

import '../../bloc/workerbyService/workerbyService_bloc.dart';
import '../../bloc/workerbyService/workerbyService_state.dart';
import '../../export_files.dart';

// ignore: must_be_immutable
class WorkersScreen extends StatefulWidget {
  final data;
  WorkersScreen({super.key, required this.data});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    ServicesManager.getWorkers(context, serviceId: "${widget.data["id"]}");
    super.initState();
  }
  
  Map payment_dates ={
     "day" :"kun",
     "month" :"oy",
     "week" :"hafta"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          scaffoldKey, widget.data?["name"] ?? "- - -", () {
        Navigator.of(context).pop();
      }, 'assets/icons/chevron-left.png'),
      body: BlocBuilder<WorkerByServiceBloc, WorkerByServiceState>(
          builder: (context, state) {
        if (state is WorkerByServiceSuccessState) {
          if (state.data.length == 0) {
            return Center(
              child: SizedBox(
                width: 365.w,
                child: Text(
                  "Ishchi mavjud emas",
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
          return WorkersScreenBody(state.data ?? []);
        } else if (state is WorkerByServiceWaitingState) {
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

  WorkersScreenBody<Widget>(List data) {
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
            Navigator.of(context).pushNamed('/workerScreen', arguments: {
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
                  flex: 7,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
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
                          Text.rich(
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
                                  text: "${data[index]["fullname"]}",
                                  style: TextStyle(
                                    color: AppConstant.darkColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                           Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                  child: Icon(CupertinoIcons.money_dollar_circle),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 5.w,
                                  ),
                                ),

                                //  SizedBox(height: 5.h),
                                TextSpan(
                                  text: "${data[index]["amount"]}".toMoney() +" so'\m / "+payment_dates["${data[index]["payment_type"]}"].toString(),
                                  style: TextStyle(
                                    color: AppConstant.darkColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
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
