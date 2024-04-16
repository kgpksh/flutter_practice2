class StoreInfoDb implements Exception {
  const StoreInfoDb();
}

class CouldNotChangeStoreStateException extends StoreInfoDb {}

class CouldNotDeleteStoreException extends StoreInfoDb {}