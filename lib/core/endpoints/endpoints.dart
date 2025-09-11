import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static const int receiveTimeout = 20000;
  static const int connectionTimeout = 20000;
  static String baseUrl = dotenv.env["base_url"] ?? "";
  static String domain = dotenv.env["domain"] ?? "";
  static String authKey = dotenv.env["authKey"] ?? "";

  static String smsSend = dotenv.env["smsSend"] ?? "";
  static String verify = dotenv.env["verify"] ?? "";

  static String Ads = dotenv.env["Ads"] ?? "";
  static String News = dotenv.env["News"] ?? "";

  static String Order = dotenv.env["Order"] ?? "";
  static String OrderAll = dotenv.env["OrderAll"] ?? "";
  static String OrderCreate = dotenv.env["OrderCreate"] ?? "";
  static String OrderConfirm = dotenv.env["OrderConfirm"] ?? "";

  

  static String CategoryAll = dotenv.env["CategoryAll"] ?? "";
  static String ProductAll = dotenv.env["ProductAll"] ?? "";
  static String Product = dotenv.env["Product"] ?? "";
  

  static String RegionAll = dotenv.env["RegionAll"] ?? "";
  static String ServiceAll = dotenv.env["ServiceAll"] ?? "";
  static String Worker = dotenv.env["Worker"] ?? "";

  static String Shop = dotenv.env["Shop"] ?? "";
  static String ShopAll = dotenv.env["ShopAll"] ?? "";

  static String ShopProduct = dotenv.env["ShopProduct"] ?? "";
  static String ShopByProduct = dotenv.env["ShopByProduct"] ?? "";

  

  
  

  
  

  
}
