
import '../../export_files.dart';

customAlert(BuildContext context, Widget child) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        content: child
        
      );
    },
  );
}
