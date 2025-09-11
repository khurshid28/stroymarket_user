
import 'package:stroymarket/bloc/ads/ads_bloc.dart';
import 'package:stroymarket/bloc/ads/ads_state.dart';

import '../export_files.dart';

class AdsManager {
  static Future<void> getAll(
    BuildContext context,
  ) async {
    try {
      await BlocProvider.of<AdsBloc>(context).get();
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<AdsBloc>(context).emit(AdsErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
}
