import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_practice2/model/user_info_results.dart';
import 'package:meta/meta.dart';

part 'copywith_user_list_state.dart';

class CopyWithUserListCubit extends Cubit<UserListCopyWithCubitState> {
  late Dio _dio;

  CopyWithUserListCubit() : super(UserListCopyWithCubitState.init()) {
    _dio = Dio(BaseOptions(baseUrl: 'https://randomuser.me/'));
    loadUserList();
  }

  loadUserList() async {
    try {
      if (state.status == UserListCubitStatus.loading ||
          state.status == UserListCubitStatus.error) {
        return;
      }

      emit(state.copyWith(status: UserListCubitStatus.loading));
      var result = await _dio.get('api', queryParameters: {
        'results': 10,
        'seed': 'sudar',
        'page': state.userInfoResult.currentPage,
      });

      emit(state.copyWith(status: UserListCubitStatus.loaded, userInfoResult: state.userInfoResult.copyWithJson(result.data)));
    } catch (e) {
      emit(state.copyWith(status: UserListCubitStatus.error, errorMessage: e.toString()));
    }
  }
}
