import 'package:stroymarket/core/extensions/date_extension.dart';
import 'package:stroymarket/core/extensions/str.dart';

import '../../bloc/orderAll/orderAll_bloc.dart';
import '../../bloc/orderAll/orderAll_state.dart';
import '../../export_files.dart';
import '../../manager/3_order_manager.dart';
import '../../widgets/common/custom_appbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    OrderManager.getAll(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        displacement: 60.h,
        backgroundColor: AppConstant.primaryColor,
        color: Colors.white,
        strokeWidth: 2.h,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await OrderManager.refreshAll(context);
        },
        child: Scaffold(
            key: scaffoldKey,
            drawerEnableOpenDragGesture: false,
            drawerScrimColor: Colors.black26,
            appBar: CustomAppBar(
              scaffoldKey,
              'Sotuv tarixi',
              () {
                Navigator.of(context).pop();
              },
              'assets/icons/chevron-left.png',
            ),
            body: 
            
            BlocBuilder<OrderAllBloc, OrderAllState>(
                builder: (context, state) {
              if (state is OrderAllSuccessState) {
                if (state.data.length == 0) {
                  return Center(
                    child: SizedBox(
                      width: 365.w,
                      child: Text(
                        "Zakas mavjud emas",
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
                return orderBody(state.data ?? []);
              } else if (state is OrderAllWaitingState) {
                return Center(
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
                ));
              } else {
                return SizedBox();
              }
            })));
  }

  statusWidget(order) {
    if (order["status"] == "CONFIRMED") {
      return Row(
        children: [
          Image.asset(
            'assets/icons/check.png',
            scale: 2.5.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            "YETKAZILGAN",
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(
                0XFF00C48C,
              ),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else if (order["status"] == "STARTED") {
      return Row(
        children: [
          Image.asset(
            'assets/icons/clock.png',
            scale: 2.5.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            "KUTILYAPTI",
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(
                0XFFFFCF5C,
              ),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else if (order["status"] == "FINISHED") {
      return Row(
        children: [
          Image.asset(
            'assets/icons/clock.png',
            scale: 2.5.sp,
            //
            color: Color(
              0xFF0084F4,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            "JARAYONDA",
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(
                0xFF0084F4,
              ),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Image.asset(
          'assets/icons/x_circle.png',
          scale: 2.5.sp,
          //
          color: Color(
            0xFFFF647C,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          "RAD ETILGAN",
          style: TextStyle(
            fontSize: 12.sp,
            color: Color(
              0xFFFF647C,
            ),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  orderBody(List data) {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/statusScreen', arguments: {
            "id": "${data[index]["id"]}",
            "order_id": "${data[index]["id"]}",
            "shop_id": "${data[index]["shop_id"]}",
              "status": "${data[index]["status"]}",
          });
        },
        child: Container(
          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusWidget(data[index]),
                  Text(
                    DateTime.tryParse(data[index]["createdt"].toString())
                        .toMyFormat(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF999999),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 0.1),
              Text(
                'Buyurtma : ${data[index]["id"].toString()}',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppConstant.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(thickness: 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UMUMIY QIYMAT',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${data[index]["amount"] ?? "- - -"}".toMoney() + " so'm",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppConstant.darkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'TURI',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${data[index]["products"]?.length}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppConstant.darkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
