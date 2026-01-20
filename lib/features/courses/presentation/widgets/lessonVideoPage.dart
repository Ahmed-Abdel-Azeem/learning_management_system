import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LessonContentPage extends StatefulWidget {
  final String lessonUrl;

  const LessonContentPage({super.key, required this.lessonUrl});

  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..loadRequest(Uri.parse(widget.lessonUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Content')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
