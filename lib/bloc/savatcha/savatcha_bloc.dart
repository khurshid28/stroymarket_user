import '../../export_files.dart';

class SavatchaBloc extends Cubit<List> {
  SavatchaBloc() : super([]);

  changeValue(List data) {
    print(">>>> emitted Data");
    emit(data);
  }
  getValue(){
    return state;
  }
}
