import 'package:dio/dio.dart' as dio;
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'verify_state.dart';

class VerifyBloc extends Cubit<VerifyState> {
  DioClient dioClient = DioClient();
  VerifyBloc() : super(VerifyIntialState());

  Future post({
    required String? id,
    required String? code,
  }) async {
    emit(VerifyWaitingState());
    dio.Response response = await dioClient.post(Endpoints.verify, data: {
      'id': id,
      'code': code,
    }, queryParameters: {
      'key': Endpoints.authKey,
    });
    print(response.statusCode);
    print(response.data);

    if (response.statusCode == 200) {
      emit(
        VerifySuccessState(
            user: response.data["user"], token: response.data["token"]),
      );
    } else {
      emit(
        VerifyErrorState(
            title: response.data["name"], message: response.data["message"]),
      );
    }

    return response.data;
  }
}
