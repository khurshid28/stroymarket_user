


import 'package:stroymarket/bloc/news/news_bloc.dart';
import 'package:stroymarket/bloc/shopProduct/shopProduct_bloc.dart';
import 'package:stroymarket/bloc/shopProduct/shopProduct_state.dart';

import '../export_files.dart';

class ShopProductManager {
  static Future<void> getAll(
    BuildContext context,
    {
    required String productId,
    required String shopId,
    }
  ) async {
    try {
      await BlocProvider.of<ShopProductBloc>(context).get(
        productId: productId,
        shopId: shopId
      );
    } catch (e, track) {
     var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<ShopProductBloc>(context).emit(ShopProductErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
   static Future<void> refresh(
    BuildContext context,
    {
    required String productId,
    required String shopId,
    }
  ) async {
    try {
      await BlocProvider.of<ShopProductBloc>(context).refreshAll(
        productId: productId,
        shopId: shopId
      );
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<ShopProductBloc>(context).emit(ShopProductErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
}
