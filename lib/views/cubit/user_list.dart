import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practice2/components/user_info.dart';

// class UserListForCubitExtends extends StatelessWidget {
//   const UserListForCubitExtends({super.key});
//
//   Widget _loading() {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }
//
//   Widget _error() {
//     return const Center(
//       child: Text('오류 발생'),
//     );
//   }
//
//   Widget _userListWidget(List<UserInfo> userInfoList) {
//     return ListView.separated(itemBuilder: (context, index) {
//       if(index == userInfoList.length) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       return UserInfoWidget(user)
//     },
//         separatorBuilder: separatorBuilder,
//         itemCount: itemCount)
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('cubit 상태관리'),
//       ),
//       body:,
//     );
//   }
// }
