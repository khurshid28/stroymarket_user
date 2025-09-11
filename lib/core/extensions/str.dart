// ignore: camel_case_extensions
extension myextension on String?{
  String toMoney() {
  
  if (this == null) {
    return "0";
  }
  if (this!.isEmpty ) {
    return "0";
  }
  String result = "";
  for (int i = 0; i < toString().length; i++) {
    result += toString()[i];
    if ((toString().length - i) % 3 == 1) {
      result += " ";
    }
  }
  return result;
}
}