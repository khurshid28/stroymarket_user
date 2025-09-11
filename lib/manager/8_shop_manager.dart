import 'package:stroymarket/bloc/shop/shop_state.dart';
import 'package:stroymarket/bloc/shopAll/shopAll_bloc.dart';
import 'package:stroymarket/bloc/shopAll/shopAll_state.dart';
import 'package:stroymarket/bloc/shopbyProduct/shopbyProduct_bloc.dart';
import 'package:stroymarket/bloc/shopbyProduct/shopbyProduct_state.dart';

import '../bloc/shop/shop_bloc.dart';
import '../export_files.dart';

class ShopManager {
  static Future<void> getAll(
    BuildContext context,
  ) async {
    try {
      await BlocProvider.of<ShopAllBloc>(context).getAll(
        context,
      );
    } catch (e, track) {
     var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<ShopAllBloc>(context).emit(ShopAllErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }

  static Future<void> getById(BuildContext context,
      {required String ShopId}) async {
    try {
      await BlocProvider.of<ShopBloc>(context).get(ShopId: ShopId);
    } catch (e, track) {
       var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<ShopBloc>(context).emit(ShopErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }

  static Future<void> getByProductId(BuildContext context,
      {required String productId}) async {
    try {
      await BlocProvider.of<ShopByProductBloc>(context)
          .get(context, productId: productId);
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<ShopByProductBloc>(context).emit(ShopByProductErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
}
