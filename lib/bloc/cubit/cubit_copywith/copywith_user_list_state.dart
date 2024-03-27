part of 'copywith_user_list_cubit.dart';

enum UserListCubitStatus {
  init,
  loading,
  loaded,
  error,
}

final class UserListCopyWithCubitState extends Equatable {
  final UserListCubitStatus status;
  final UserInfoResult userInfoResult;
  final String? errorMessage;

  const UserListCopyWithCubitState({
    required this.status,
    required this.userInfoResult,
    this.errorMessage,
  });

  UserListCopyWithCubitState.init()
      : this(
          status: UserListCubitStatus.init,
          userInfoResult: UserInfoResult.init(),
        );

  UserListCopyWithCubitState copyWith({
    UserListCubitStatus? status,
    UserInfoResult? userInfoResult,
    String? errorMessage,
  }) {
    return UserListCopyWithCubitState(
      status: status ?? this.status,
      userInfoResult: userInfoResult ?? this.userInfoResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userInfoResult,
        errorMessage,
      ];
}
