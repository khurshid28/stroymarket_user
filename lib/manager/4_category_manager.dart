import 'package:stroymarket/bloc/categoryAll/categoryAll_bloc.dart';
import 'package:stroymarket/bloc/categoryAll/categoryAll_state.dart';

import '../export_files.dart';

class CategoryManager {
  static Future<void> getAll(
    BuildContext context,
  ) async {
    try {
      await BlocProvider.of<CategoryAllBloc>(context).getAll();
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<CategoryAllBloc>(context).emit(CategoryAllErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
}
