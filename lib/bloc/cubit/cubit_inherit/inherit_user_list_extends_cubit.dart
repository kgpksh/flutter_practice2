import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_practice2/model/user_info_results.dart';
import 'package:meta/meta.dart';

part 'inherit_user_list_extends_state.dart';

class InheritUserListExtendsCubit extends Cubit<InheritUserListCubitsState> {
  late Dio _dio;
  InheritUserListExtendsCubit() : super(InitInheritUserListCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'https://randomuser.me/'));
   loadUserList(); 
  }

  loadUserList() async {
    try {
      if(state is LoadingInheritUserListCubitState || state is ErrorInheritUserListCubitState) {
        return;
      }

      emit(LoadingInheritUserListCubitState(userInfoResult: state.userInfoResult));
      var result = await _dio.get('api', queryParameters: {
        'results': 10,
        'seed': 'sudar',
        'page': state.userInfoResult.currentPage,
      });
  
      emit(LoadedInheritUserListCubitState(userInfoResult: state.userInfoResult.copyWithJson(result.data)));
      
    } catch(e) {
      emit(ErrorInheritUserListCubitState(errorMessage: e.toString(), userInfoResult: state.userInfoResult));
    }
  }
}
