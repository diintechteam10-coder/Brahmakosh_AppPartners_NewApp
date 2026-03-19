import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Logger _logger = Logger();
  
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateStatus);
    checkInitialStatus();
  }

  Future<void> checkInitialStatus() async {
    final results = await _connectivity.checkConnectivity();
    await _updateStatus(results);
  }

  Future<void> _updateStatus(List<ConnectivityResult> results) async {
    bool isConnected = false;
    
    // connectivity_plus 6.0.0+ returns a List<ConnectivityResult>
    if (results.contains(ConnectivityResult.none)) {
      isConnected = false;
    } else {
      // Even if connectivity says we are connected to Wifi/Mobile, 
      // we should check if there is actual internet access.
      isConnected = await _hasActualInternetAccess();
    }

    _logger.i('Connectivity Status Changed: ${isConnected ? "CONNECTED" : "DISCONNECTED"}');
    _connectivityController.add(isConnected);
  }

  Future<bool> _hasActualInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      _logger.e('Error checking internet access: $e');
      return false;
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
