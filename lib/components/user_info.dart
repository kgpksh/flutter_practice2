import 'package:flutter/material.dart';
import 'package:flutter_practice2/model/user_info_results.dart';

class UserInfoWidget extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoWidget({required this.userInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(userInfo.profileImage).image,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  userInfo.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 11,
                  ),
                ),
                Text(
                  userInfo.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue),
                ),
                Row(
                  children: [const Icon(Icons.phone), Text(userInfo.phone)],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
