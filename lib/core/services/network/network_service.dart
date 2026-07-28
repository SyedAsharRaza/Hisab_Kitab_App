import 'package:connectivity_plus/connectivity_plus.dart';
import '../logger/logger_service.dart';

// device connectivity status check karna
class NetworkService {
  final Connectivity _connectivity;
  NetworkService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _hasConnection(result);
    } catch (e) {
      AppLogger.error('Failed to check connectivity', 'NetworkService', e);
      // agar error agaya to user ko block nhi karenge
      return true;
    }
  }
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }
  bool _hasConnection(List<ConnectivityResult> result) {
    return result.any((r) => r != ConnectivityResult.none);
  }
}