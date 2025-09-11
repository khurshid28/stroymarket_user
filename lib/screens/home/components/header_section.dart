import '../../../export_files.dart';
// ignore: must_be_immutable
class HeaderSections extends StatelessWidget {
  HeaderSections({Key? key, required this.title, required this.onTap})
      : super(key: key);
  String title;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppConstant.darkColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Barchasi',
            style: TextStyle(
              color: AppConstant.primaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
