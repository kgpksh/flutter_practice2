import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/auth/auth_bloc.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info_service.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Store'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthLoggedIn) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                          hintText: 'Type your store name here'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseCloudStorage().createStore(userId: state.userId, storeName: _textController.text);
                      _textController.clear();
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              StreamBuilder(
                stream:
                    FirebaseCloudStorage().getMyAllStores(userId: state.userId),
                builder: (context, snapshot) {
                  if (snapshot == null) {
                    return const Text('Error occured1');
                  }

                  if (snapshot.hasError) {
                    return const Text('Error occured2');
                  }

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data as List<StoreInfo>;

                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data[index].storeName),
                                TextButton(
                                    onPressed: () {
                                      FirebaseCloudStorage()
                                          .changeStoreState(store: data[index]);
                                    },
                                    child: data[index].isOpened
                                        ? const Text('Opened!')
                                        : const Text('Closed!')),
                                IconButton(
                                  onPressed: () {
                                    FirebaseCloudStorage().deleteStore(
                                        documentId: data[index].documentId);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    );
                  }

                  return const Text('Error occured3');
                },
              )
            ],
          );
        },
      ),
    );
  }
}
