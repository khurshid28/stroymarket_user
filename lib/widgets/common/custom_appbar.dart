
import 'package:stroymarket/bloc/savatcha/savatcha_bloc.dart';

import '../../export_files.dart';

// customAppBar<Widget>(
//   BuildContext context,
//   GlobalKey<ScaffoldState> scaffoldKey,
//   String text,
//   VoidCallback onPressed,
//   String icon, {
//   bool savatcha = false,
//   actions,
// }) {
//   return AppBar(
//     elevation: 0,
//     surfaceTintColor: Colors.transparent,
//     bottom: PreferredSize(
//       preferredSize: Size(MediaQuery.of(context).size.width, 1.h),
//       child: const Divider(
//         color: AppConstant.greyColor,
//         height: 0,
//       ),
//     ),
//     centerTitle: true,
//     title: Text(
//       text,
//       style: TextStyle(
//         fontSize: 18.sp,
//         color: AppConstant.darkColor,
//         fontWeight: FontWeight.w300,
//       ),
//     ),
//     leading: GestureDetector(
//       onTap: onPressed,
//       child: Image.asset(
//         icon,
//         scale: 3.sp,
//       ),
//     ),
//     actions: [
//       if (actions != null)
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: actions!,
//         ),
//       savatcha == true
//           ? GestureDetector(onTap: () {
//               Navigator.of(context).pushNamed(
//                 '/cartScreen',
//               );
//             }, child: BlocBuilder<SavatchaBloc, List>(
//               builder: (context, state) {
//                 return Container(
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(5.0.w),
//                         child: Image.asset(
//                           'assets/icons/Grocery.png',
//                           scale: 3.sp,
//                         ),
//                       ),
//                       if (state.isNotEmpty)
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             child: Text(
//                               "${state.length}",
//                               style: TextStyle(
//                                   fontSize: 9.sp, fontWeight: FontWeight.bold),
//                             ),
//                             padding: EdgeInsets.all(5.w),
//                             decoration: BoxDecoration(
//                                 // borderRadius: BorderRadius.circular(2.w),
//                                 shape: BoxShape.circle,
//                                 color: Colors.amber),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ))
//           : SizedBox(),
//       SizedBox(width: 16.w),
//     ],
//   );

// }


class CustomAppBar extends StatefulWidget  implements  PreferredSizeWidget  {
  GlobalKey<ScaffoldState>? scaffoldKey;
  String? text;
  VoidCallback? onPressed;
  String? icon;
  bool savatcha = false;
  final actions;
     @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
  CustomAppBar(this.scaffoldKey, this.text, this.onPressed, this.icon,
      {this.savatcha = false, this.actions, super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 1.h),
        child: const Divider(
          color: AppConstant.greyColor,
          height: 0,
        ),
      ),
      centerTitle: true,
      title: Text(
        widget.text!,
        style: TextStyle(
          fontSize: 18.sp,
          color: AppConstant.darkColor,
          fontWeight: FontWeight.w300,
        ),
      ),
      leading: GestureDetector(
        onTap: widget.onPressed,
        child: Image.asset(
          widget.icon!,
          scale: 3.sp,
        ),
      ),
      actions: [
        if (widget.actions != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.actions!,
          ),

          BlocListener<SavatchaBloc, List>(
            listener: (context, state) {
               setState(() {
                 
               });
               print('>>>> State changed in LISTENER');
            },
            child: Container(),
          ),
        widget.savatcha == true
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/cartScreen',
                  );
                },
                child: BlocBuilder<SavatchaBloc, List>(
                 
                  
                  builder: (context, state) {
                    print(">>>>" + state.length.toString());
                     print('>>>> ${widget.text}');
                    return Container(
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: Image.asset(
                              'assets/icons/Grocery.png',
                              scale: 3.sp,
                            ),
                          ),
                          if (state.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                child: Text(
                                  "${state.length}",
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(2.w),
                                    shape: BoxShape.circle,
                                    color: Colors.amber),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ))
            : SizedBox(),
        SizedBox(width: 16.w),
      ],
    );
  }
}
