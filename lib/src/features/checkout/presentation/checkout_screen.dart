import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/api_keys.dart';
import '../../../core/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Default URL + /checkout
    final checkoutUrl = '${AppConstants.siteUrl}/checkout'; // Ensure AppConstants.siteUrl doesn't end with / in implementation or handle it
    
    // Note: Since siteUrl is a placeholder 'SITE_URL_HERE', this will fail if not replaced.
    // I will add a check to show a message if it's the placeholder.
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
             if(mounted) setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
             if(mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );

    if (AppConstants.siteUrl != 'SITE_URL_HERE') {
      _controller.loadRequest(Uri.parse(checkoutUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppConstants.siteUrl == 'SITE_URL_HERE') {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
         appBar: AppBar(title: const Text('Checkout'), backgroundColor: AppTheme.backgroundDark),
         body: Center(
           child: Padding(
             padding: const EdgeInsets.all(24.0),
             child: Text(
               'Please configure your SITE_URL in constants/api_keys.dart to test checkout.',
               textAlign: TextAlign.center,
               style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
             ),
           ),
         ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        ],
      ),
    );
  }
}
