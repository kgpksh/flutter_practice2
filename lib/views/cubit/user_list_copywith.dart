import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/cubit/cubit_copywith/copywith_user_list_cubit.dart';
import 'package:flutter_practice2/components/user_info.dart';
import 'package:flutter_practice2/model/user_info_results.dart';

class CopyWithUserList extends StatefulWidget {
  const CopyWithUserList({super.key});

  @override
  State<CopyWithUserList> createState() =>
      _InheritUserListForCubitExtendsState();
}

class _InheritUserListForCubitExtendsState extends State<CopyWithUserList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<CopyWithUserListCubit>().loadUserList();
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
      body: BlocBuilder<CopyWithUserListCubit, UserListCopyWithCubitState>(
        builder: (context, state) {
          switch(state.status){

            case UserListCubitStatus.init:
            case UserListCubitStatus.loading:
            case UserListCubitStatus.loaded:
              return _userListWidget(state.userInfoResult.userInfoList);
            case UserListCubitStatus.error:
              return _error();
            default:
              return _loading();
          }
        },
      ),
    );
  }
}
