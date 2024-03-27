import 'package:flutter/material.dart';
import 'package:flutter_practice2/components/user_info.dart';

class WebApiList extends StatelessWidget {
  const WebApiList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Api List'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return UserInfoWidget();
        },
        separatorBuilder: (context, index) => const Divider(color: Colors.grey),
        itemCount: 100,
      ),
    );
  }
}
