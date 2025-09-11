import '../../export_files.dart';

customBottomsheet(BuildContext context, Widget widget) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
    ),
    backgroundColor: Colors.white,
    barrierColor: Colors.black26,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: widget,
      );
    },
  );
}
