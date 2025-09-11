import 'package:flutter/cupertino.dart';
import 'package:stroymarket/export_files.dart';
import 'package:stroymarket/services/storage/storage_service.dart';
import 'package:stroymarket/widgets/common/custom_alert.dart';
import 'package:stroymarket/widgets/common/custom_button.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key, required this.scaffoldKey});
  GlobalKey<ScaffoldState> scaffoldKey;
  logoutWidget(BuildContext context) {
    return Container(
      height: 390.h,
      width: 300.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Image.asset(
            "assets/images/stroymarket1.png",
            height: 155.h,
            width: 200.w,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              "Chiqishni xoxlaysizmi ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Column(
            children: [
              CustomButton(
                text: "Yo'\q",
                onPressed: () {
                  Navigator.of(scaffoldKey.currentContext!).pop();
                },
                color: AppConstant.primaryColor,
              ),
              SizedBox(height: 15.h),
              CustomButton(
                text: 'Ha',
                onPressed: () {
                  Future.wait([
                    StorageService().remove(
                      StorageService.token,
                    ),
                    StorageService().remove(
                      StorageService.user,
                    )
                  ]);
                  Navigator.pushNamedAndRemoveUntil(
                    scaffoldKey.currentContext!,
                    RouteNames.loginScreen,
                    (route) => false,
                  );
                },
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }
 

  @override
  Widget build(BuildContext context) {
    final user = StorageService().read(StorageService.user);
   
    List<IconData> tileIcon = [
      Icons.history_outlined,
      CupertinoIcons.hammer,
      CupertinoIcons.home,
       Icons.design_services_rounded ,
      
        CupertinoIcons.news,
      CupertinoIcons.settings,
      Icons.logout_outlined,
    ];
    List<String> tileText = ['Tarix', 'Mahsulotlar',"Do\'konlar","Xizmatlar","Yangiliklar", 'Sozlamalar', 'Chiqish'];
    List<String> screens = [
      '/historyScreen',
      '/categoryScreen',
      '/marketAllScreen',
      '/serviceAllScreen',
      '/newsScreen',
      '/settingsScreen',
      '/'
    ];
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.r,
                backgroundColor: const Color(0xFFF7F8FF),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  color: AppConstant.primaryColor,
                ),
              ),
              title: Text(
               user ==null ? "- - -": user["phone"].toString(),
                style: TextStyle(
                  color: AppConstant.darkColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const Divider(thickness: 0.1),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: tileIcon.length,
              itemBuilder: (context, index) => index != 6
                  ? ListTile(
                      leading: Icon(tileIcon[index]),
                      title: Text(
                        tileText[index],
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        print(index);
                         Navigator.of(scaffoldKey.currentContext!).pushNamed(
                            screens[index],
                          );
                       
                      },
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: const Divider(thickness: 0.1),
                        ),
                        ListTile(
                          leading: Icon(tileIcon[index]),
                          title: Text(
                            tileText[index],
                            style: TextStyle(
                              color: AppConstant.darkColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                             customAlert(context, logoutWidget(context));
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
