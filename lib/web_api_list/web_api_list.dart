import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice2/components/user_info.dart';
import 'package:flutter_practice2/model/user_info_results.dart';

class WebApiList extends StatefulWidget {
  const WebApiList({super.key});

  @override
  State<WebApiList> createState() => _WebApiListState();
}

class _WebApiListState extends State<WebApiList> {
  late Dio _dio;
  ScrollController scrollController = ScrollController();
  late UserInfoResult userInfoResult;
  int nextPage = -1;

  @override
  void initState() {
    userInfoResult = UserInfoResult(currentPage: 0, userInfoList: []);
    _dio = Dio(BaseOptions(baseUrl: 'https://randomuser.me/'));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent * 0.7 <=
              scrollController.offset &&
          nextPage != userInfoResult.currentPage) {
        nextPage = userInfoResult.currentPage;
        setState(() {});
      }
    });
    super.initState();
  }

  Future<UserInfoResult> _loadUserList() async {
    var result = await _dio.get('api', queryParameters: {
      'results': 10,
      'seed': 'sudar',
      'page': userInfoResult.currentPage,
    });

    userInfoResult = userInfoResult.copyWithJson(result.data);
    return userInfoResult;
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
        if(index == userInfoList.length) {
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
      appBar: AppBar(
        title: const Text('Web Api List'),
      ),
      body: FutureBuilder<UserInfoResult>(
        future: _loadUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _error();
          }
          if (snapshot.hasData) {
            return _userListWidget(snapshot.data!.userInfoList);
          }
          return _loading();
        },
      ),
    );
  }
}