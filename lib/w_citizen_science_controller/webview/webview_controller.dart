import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  final title = "".obs;
  final isPageLoading = 0.obs;
  final hasInternet = true.obs;

  final WebViewController webViewController = WebViewController();

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    final decode = Get.arguments;
    title.value = decode['title'] ?? 'Web View';
    final url = decode['url'] ?? '';

    _checkInitialConnection();
    _listenToConnectivity();

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            isPageLoading.value = 0;
            print("Page started: $url");
          },
          onProgress: (progress) {
            isPageLoading.value = progress;
            print("Progress: $progress");
          },
          onPageFinished: (url) {
            isPageLoading.value = 100;
            print("Page finished: $url");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    hasInternet.value = result != ConnectivityResult.none;
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      hasInternet.value = result != ConnectivityResult.none;
    });
  }

  // Optional: Retry manually from view
  void reloadPage() {
    webViewController.reload();
  }
}
