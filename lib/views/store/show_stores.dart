import 'package:flutter/material.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info_service.dart';

class ShowStores extends StatefulWidget {
  const ShowStores({super.key});

  @override
  State<ShowStores> createState() => _ShowStoresState();
}

class _ShowStoresState extends State<ShowStores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseCloudStorage().allStores(),
          builder: (context, snapshot) {
            if (snapshot == null) {
              return const Text('Error occured1');
            }

            if (snapshot.hasError) {
              return const Text('Error occured2');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              final data = snapshot.data as List<StoreInfo>;
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].storeName),
                    subtitle: Text(data[index].isOpened ? 'Opened!' : 'Closed!'),
                  );
                },
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(),
                            );
            }

            return const Text('Error occured3');
          },
        ),
      ),
    );
  }
}
