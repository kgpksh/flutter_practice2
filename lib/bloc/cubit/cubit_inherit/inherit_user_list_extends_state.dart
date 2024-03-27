part of 'inherit_user_list_extends_cubit.dart';

@immutable
abstract class InheritUserListCubitsState extends Equatable {
  final UserInfoResult userInfoResult;
  const InheritUserListCubitsState({required this.userInfoResult});
}

class InitInheritUserListCubitState extends InheritUserListCubitsState {
  InitInheritUserListCubitState() : super(userInfoResult: UserInfoResult.init());

  @override
  List<Object?> get props => [];
}

class LoadingInheritUserListCubitState extends InheritUserListCubitsState {
  const LoadingInheritUserListCubitState({required super.userInfoResult});

  @override
  List<Object?> get props => [];
}

class LoadedInheritUserListCubitState extends InheritUserListCubitsState {
  const LoadedInheritUserListCubitState({required super.userInfoResult});

  @override
  List<Object?> get props => [];
}

class ErrorInheritUserListCubitState extends InheritUserListCubitsState {
  String errorMessage;
  ErrorInheritUserListCubitState({required this.errorMessage, required super.userInfoResult});

  @override
  List<Object?> get props => [];
}