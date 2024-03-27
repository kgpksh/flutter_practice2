import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(
                'https://randomuser.me/api/portraits/men/75.jpg')
                .image,
          ),
          const SizedBox(width: 20,),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'test@gmail.com',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 11,
                  ),
                ),
                Text(
                  'Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue),
                ),
                Row(
                  children: [
                    Icon(Icons.phone),
                    Text('01012345678')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
