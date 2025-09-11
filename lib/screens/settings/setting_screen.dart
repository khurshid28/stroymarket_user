import 'package:flutter/cupertino.dart';
import 'package:stroymarket/export_files.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int selectIndex = 0;
  List<String> titleText = [
    "O'zbek",
    'Русский',
    "English",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.black26,
      appBar: CustomAppBar(
        scaffoldKey,
        'Sozlamalar',
        () {
          Navigator.of(context).pop();
        },
        'assets/icons/chevron-left.png',
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Text(
                'Til sozlamalari',
                style: TextStyle(
                  color: AppConstant.primaryColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  selectIndex = index;
                  setState(() {});
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        titleText[index],
                        style: TextStyle(
                          color: AppConstant.darkColor,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),

                      trailing: index != selectIndex
                          ? Container(
                              width: 40.w,
                              height: 40.w,
                             decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                // color: AppConstant.primaryColor,
                                border: Border.all(
                                    color: AppConstant.primaryColor,
                                    width: 3.w),
                              ),
                            )
                          : Container(
                              width: 40.w,
                              height: 40.w,
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 22,
                                weight: 900,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: AppConstant.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4.r,
                                        blurStyle: BlurStyle.normal)
                                  ]),
                            ),
                      // trailing: CupertinoSwitch(
                      //   activeColor: AppConstant.primaryColor,
                      //   value: values[index],
                      //   onChanged: (v) => setState(
                      //     () => values[index] = v,
                      //   ),
                      // ),
                    ),
                    Divider(thickness: 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
