import 'package:dio/dio.dart' as dio;
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'send_sms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendSmsBloc extends Cubit<SendSmsState> {
  DioClient dioClient = DioClient();
  SendSmsBloc() : super(SendSmsIntialState());

  Future post({required String? phone}) async {
    emit(SendSmsWaitingState());
    dio.Response response = await dioClient.post(Endpoints.smsSend,
        data: {'phone': "+"+phone.toString()}, queryParameters: {'key': Endpoints.authKey});
    print(response.statusCode);
    print(response.data);

    if (response.statusCode == 200) {
      emit(
        SendSmsSuccessState(
          data: response.data,
        ),
      );
    } else {
      emit(
        SendSmsErrorState(
            title: response.data["name"], message: response.data["message"]),
      );
    }

    return response.data;
  }
}
