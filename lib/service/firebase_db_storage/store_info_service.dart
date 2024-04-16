import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info_constants.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info_exceptions.dart';

class FirebaseCloudStorage {
  final stores = FirebaseFirestore.instance.collection('StoreInfo');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  Future<StoreInfo> createStore(
      {required String userId, required String storeName}) async {
    final document = await stores.add({
      userIdFieldName: userId,
      storeNameFieldName: storeName,
      isOpenedFieldName: false,
    });

    final fetchResult = await document.get();
    return StoreInfo(
      documentId: fetchResult.id,
      userId: userId,
      storeName: storeName,
      isOpened: false,
    );
  }

  Stream<List<StoreInfo>> allStores() {
    return stores
        .limit(10)
        .snapshots()
        .map((event) => event.docs.map((doc) => StoreInfo.fromDb(doc)).toList());
  }

  Stream<List<StoreInfo>> getMyAllStores({required String userId}) {
    return stores
        .where(userIdFieldName, isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs.map((doc) => StoreInfo.fromDb(doc)).toList());
  }

  Future<void> changeStoreState({required StoreInfo store}) async {
    try {
      stores.doc(store.documentId).update({isOpenedFieldName: !store.isOpened});
    } catch (e) {
      throw CouldNotChangeStoreStateException();
    }
  }

  Future<void> deleteStore({required String documentId}) async {
    try {
      stores.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteStoreException();
    }
  }
}
