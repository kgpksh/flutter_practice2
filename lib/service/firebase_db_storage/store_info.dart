import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice2/service/firebase_db_storage/store_info_constants.dart';

class StoreInfo {
  final String documentId;
  final String userId;
  final String storeName;
  final bool isOpened;

  StoreInfo({
    required this.documentId,
    required this.userId,
    required this.storeName,
    required this.isOpened,
  });

  StoreInfo.fromDb(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    documentId = snapshot.id,
    userId = snapshot.data()[userIdFieldName],
    storeName = snapshot.data()[storeNameFieldName],
    isOpened = snapshot.data()[isOpenedFieldName];

}
