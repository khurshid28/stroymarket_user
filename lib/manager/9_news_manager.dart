


import 'package:stroymarket/bloc/news/news_bloc.dart';
import 'package:stroymarket/bloc/news/news_state.dart';

import '../export_files.dart';

class NewsManager {
  static Future<void> getAll(
    BuildContext context,
  ) async {
    try {
      await BlocProvider.of<NewsBloc>(context).get();
    } catch (e, track) {
      var err = e as DioExceptions;
      print("Manager Error >>" + e.toString());
      print("Manager track >>" + track.toString());
      BlocProvider.of<NewsBloc>(context).emit(NewsErrorState(
        message: err.message,
        title: err.message,
      ));
    }
  }
}
