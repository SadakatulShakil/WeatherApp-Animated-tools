import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/api_urls.dart';

enum NetworkState { loading, online, offline }

class NetworkController extends GetxController {
  var networkState = NetworkState.loading.obs; // initial state
  var networkMessage = ''.obs;
  var networkStatus = 'Checking network...'.obs;
  var networkIcon = Icons.wifi_off.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), _initNetworkCheck);

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateStatus(result);
    });

  }

  Future<void> checkConnection() async {
    await _initNetworkCheck();
  }

  Future<void> _initNetworkCheck() async {
    networkState.value = NetworkState.loading;
    final result = await Connectivity().checkConnectivity();
    await _updateStatus(result);
  }

  Future<void> _updateStatus(List<ConnectivityResult> result) async {
    networkState.value = NetworkState.loading;

    if (result.contains(ConnectivityResult.wifi)) {
      networkStatus.value = 'Wi-Fi connected';
      networkIcon.value = Icons.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      networkStatus.value = 'Mobile data connected';
      networkIcon.value = Icons.network_cell;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      networkStatus.value = 'Ethernet connected';
      networkIcon.value = Icons.settings_ethernet;
    } else {
      networkStatus.value = 'No network';
      networkIcon.value = Icons.wifi_off;
      networkState.value = NetworkState.offline;
      networkMessage.value = 'No internet';
      return;
    }

    await _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    final urlsToTry = [
      ApiURL.CHECK_NETWORK,
      'https://www.google.com/generate_204',
      'https://1.1.1.1',
    ];

    bool hasInternet = false;

    for (final url in urlsToTry) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 204 ||
            response.statusCode == 200 ||
            response.statusCode == 301) {
          hasInternet = true;
          break;
        }
      } catch (_) {}
    }

    if (hasInternet) {
      networkState.value = NetworkState.online;
      networkMessage.value = 'Internet working';
    } else {
      _setOffline('No internet access');
    }
  }

  void _setOffline(String message) {
    networkState.value = NetworkState.offline;
    networkMessage.value = message;
  }
}
