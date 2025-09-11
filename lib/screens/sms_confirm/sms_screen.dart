
import 'package:stroymarket/export_files.dart';
import 'package:stroymarket/manager/1_phone_manager.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';

import '../../bloc/2_verify/verify_bloc.dart';
import '../../bloc/2_verify/verify_state.dart';
import '../../services/loading/loading_service.dart';
import '../../services/storage/storage_service.dart';

class SmsScreen extends StatefulWidget {
   SmsScreen({super.key,required this.id});
  String? id;

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController smscontroller = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  LoadingService loadingService = LoadingService();
  @override
  Widget build(BuildContext context) {
    final focusedPinTheme = 

    PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: AppConstant.primaryColor, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Colors.white,
       border: Border.all(color: AppConstant.primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
  );
    
   

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppConstant.primaryColor,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(20.w),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   shape: BoxShape.circle,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.5),
                    //       spreadRadius: 5,
                    //       blurRadius: 7,
                    //       offset: const Offset(0, 3),
                    //     ),
                    //   ],
                    // ),
                    child: Image(
                      image: const AssetImage('assets/images/stroymarket1.png'),
                      width: 120.w,
                    ),
                  ),
                  Text(
                    'Diametr',
                    style: TextStyle(
                      color: AppConstant.darkColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      "Biz bilan istalgan xaridingizni oson amalga oshiring",
                      
                      style: TextStyle(
                        color: AppConstant.darkColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: 325.w,
                          child: Text(
                            'Telefon raqamingizni tasdiqlang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 325.w,
                          child: Text(
                            'Raqamingizga tasdiqlash uchun kod yubordik',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Pinput(
                          onChanged: (value) {
                            setState(() {});
                          },
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.none,
                          controller: smscontroller,
                        ),
                        // CustomTextField(
                        //   icon: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       SizedBox(
                        //         width: 20.w,
                        //       ),
                        //       Icon(CupertinoIcons.phone, size: 20.sp),
                        //       SizedBox(
                        //         width: 8.w,
                        //       ),
                        //       Text(
                        //         "+998 ",
                        //         style: TextStyle(
                        //           color: AppConstant.darkColor,
                        //           fontSize: 14.sp,
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //       SizedBox(
                        //         width: 4.w,
                        //       ),
                        //     ],
                        //   ),
                        //   text: '(XX) XXX-XX-XX',
                        //   controller: smscontroller,
                        //   keyboardType: TextInputType.number,
                        //   onChanged: (p0) {
                        //     print(p0.length);
                        //     setState(() {

                        //     });
                        //   },
                        // ),

                        SizedBox(height: 12.h),
                        CustomButton(
                          onPressed: ()async {
                            if (smscontroller.text.length == 6) {
                             await PhoneManager.verify(context, id: widget.id, code: smscontroller.text);
                            print(widget.id);

                            }
                          },
                          text: 'Tasdiqlash',
                          color: smscontroller.text.length == 6
                              ? AppConstant.primaryColor
                              : Colors.grey.shade200,
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
             BlocListener<VerifyBloc, VerifyState>(
                child: SizedBox(),
                listener: (context, state) async {
                  if (state is VerifyWaitingState) {
                    loadingService.showLoading(context);
                  } else if (state is VerifyErrorState) {
                    loadingService.closeLoading(context);
                    Flushbar(
                      backgroundColor: Colors.red.shade700,
                      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.GROUNDED,
                      isDismissible: true,
                      message:state.message ??  "Xatolik Bor",
                      messageColor: Colors.white,
                      messageSize: 18.sp,
                      icon: Icon(
                        Icons.error,
                        size: 28.0,
                        color: Colors.white,
                      ),
                      duration: Duration(seconds : 5),
                      leftBarIndicatorColor: Colors.red.shade700,
                    ).show(context);
                  } else if (state is VerifySuccessState) {
                    loadingService.closeLoading(context);
                     Future.wait([
                      StorageService().write(
                        StorageService.token,
                        state.token.toString(),
                      ),
                      StorageService().write(
                        StorageService.user,
                        state.user,
                      )
                    ]);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                                '/homeScreen',
                                (r)=>false
                              );
                  }
                }),
         
         
          ],
        ),
      ),
    );
  }
}
