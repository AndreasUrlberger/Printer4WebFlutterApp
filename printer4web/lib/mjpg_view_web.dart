import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

int _nextViewId = 0;

class _MjpgView extends StatefulWidget {
  const _MjpgView({required this.url});

  final String url;

  @override
  State<_MjpgView> createState() => _MjpgViewState();
}

class _MjpgViewState extends State<_MjpgView> {
  late final String _viewType;
  late final html.ImageElement _image;
  Timer? _retryTimer;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _viewType = 'mjpg-view-${_nextViewId++}';
    _image = html.ImageElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black';
    _image.onLoad.listen((_) {
      _retryTimer?.cancel();
      _retryCount = 0;
    });
    _image.onError.listen((_) => _scheduleRetry());
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return _image;
    });
    _loadImage();
  }

  void _loadImage() {
    final separator = widget.url.contains('?') ? '&' : '?';
    _image.src = '${widget.url}$separator' 'retry=$_retryCount';
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final delay = Duration(milliseconds: 500 + (_retryCount.clamp(0, 10) * 500));
    _retryCount++;
    _retryTimer = Timer(delay, _loadImage);
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}

Widget createMjpgView(String url) => _MjpgView(url: url);
