import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/cubit/cubit_inherit/inherit_user_list_extends_cubit.dart';
import 'package:flutter_practice2/components/user_info.dart';
import 'package:flutter_practice2/model/user_info_results.dart';

class InheritUserListForCubitExtends extends StatefulWidget {
  const InheritUserListForCubitExtends({super.key});

  @override
  State<InheritUserListForCubitExtends> createState() =>
      _InheritUserListForCubitExtendsState();
}

class _InheritUserListForCubitExtendsState extends State<InheritUserListForCubitExtends> {
  late Dio _dio;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'https://randomuser.me/'));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<InheritUserListExtendsCubit>().loadUserList();
      }
    });
  }

  Widget _error() {
    return const Center(
      child: Text('오류 발생'),
    );
  }

  Widget _loading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _userListWidget(List<UserInfo> userInfoList) {
    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index == userInfoList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return UserInfoWidget(
          userInfo: userInfoList[index],
        );
      },
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      itemCount: userInfoList.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cubit 상태관리')),
      body: BlocBuilder<InheritUserListExtendsCubit, InheritUserListCubitsState>(
        builder: (context, state) {
          if (state is ErrorInheritUserListCubitState) {
            return _error();
          }

          if (state is LoadedInheritUserListCubitState ||
              state is LoadingInheritUserListCubitState) {
            return _userListWidget(state.userInfoResult.userInfoList);
          }

          return _loading();
        },
      ),
    );
  }
}
