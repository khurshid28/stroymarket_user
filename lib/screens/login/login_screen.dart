
import 'package:flutter/cupertino.dart';
import 'package:stroymarket/export_files.dart';
import 'package:stroymarket/manager/1_phone_manager.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';
import 'package:stroymarket/widgets/common/custom_search.dart';

import '../../bloc/1_send_sms/send_sms_bloc.dart';
import '../../bloc/1_send_sms/send_sms_state.dart';
import '../../services/loading/loading_service.dart';
import '../../services/storage/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController phonecontroller = TextEditingController();
  LoadingService loadingService = LoadingService();
  var phoneMask = new MaskTextInputFormatter(
      mask: '(##) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager,);
  @override
  Widget build(BuildContext context) {
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
              flex: 5,
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
                        Text(
                          'Telefon raqamingizni kiriting',
                          style: TextStyle(
                            color: AppConstant.darkColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          inputFormatters: [phoneMask],
                          icon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Icon(CupertinoIcons.phone, size: 20.sp),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                "+998 ",
                                style: TextStyle(
                                  color: AppConstant.darkColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                            ],
                          ),
                          text: '(XX) XXX-XX-XX',
                          controller: phonecontroller,
                          keyboardType: TextInputType.number,
                          onChanged: (p0) {
                            print(p0.length);
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 10.h),
                        CustomButton(
                          onPressed: () async{
                            if (phonecontroller.text.length == 14) {
                           
                              await PhoneManager.sendSms(context, phone: '998'+ phoneMask.unmaskText(phonecontroller.text));
                            }
                          },
                          text: 'SMS kod olish',
                          color: phonecontroller.text.length == 14
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
             BlocListener<SendSmsBloc, SendSmsState>(
                child: SizedBox(),
                listener: (context, state) async {
                  if (state is SendSmsWaitingState) {
                    loadingService.showLoading(context);
                  } else if (state is SendSmsErrorState) {
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
                    
                  } else if (state is SendSmsSuccessState) {
                    loadingService.closeLoading(context);
                    
                    Navigator.of(context).pushNamed(
                      '/smsScreen',
                      arguments: {
                        'id' : state.data["id"]
                      }
                      
                    );
                  }
                }),
         
          ],
        ),
      ),
    );
  }
}
