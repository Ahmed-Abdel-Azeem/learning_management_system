import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LessonWebViewPage extends StatefulWidget {
  final String url;
  const LessonWebViewPage({super.key, required this.url});

  @override
  State<LessonWebViewPage> createState() => _LessonWebViewPageState();
}

class _LessonWebViewPageState extends State<LessonWebViewPage> {
  bool _isLoading = true;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
