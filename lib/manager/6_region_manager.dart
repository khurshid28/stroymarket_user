import 'package:stroymarket/bloc/categoryAll/categoryAll_bloc.dart';
import 'package:stroymarket/bloc/regionAll/regionAll_bloc.dart';
import 'package:stroymarket/bloc/regionAll/regionAll_state.dart';
import 'package:stroymarket/bloc/regionSelected/regionSelected_bloc.dart';

import '../export_files.dart';

class RegionManager {
  static Future<void> getAll(
    BuildContext context,
  ) async {
    try {
      await BlocProvider.of<RegionAllBloc>(context).getAll();
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<RegionAllBloc>(context).emit(RegionAllErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }

  static changeSelectedValue(BuildContext context, {required List data}) {
    BlocProvider.of<RegionSelectedBloc>(context).changeValue(data);
  }

  static getSelectedValue(BuildContext context) {
    return BlocProvider.of<RegionSelectedBloc>(context).getValue();
  }
}
