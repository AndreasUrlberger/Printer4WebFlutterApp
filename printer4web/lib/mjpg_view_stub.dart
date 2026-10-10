import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class _MjpgView extends StatefulWidget {
  const _MjpgView({required this.url});

  final String url;

  @override
  State<_MjpgView> createState() => _MjpgViewState();
}

class _MjpgViewState extends State<_MjpgView> {
  final http.Client _client = http.Client();
  StreamSubscription<List<int>>? _streamSubscription;
  Timer? _retryTimer;
  Uint8List? _frame;
  int _connectionId = 0;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void didUpdateWidget(covariant _MjpgView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _retryTimer?.cancel();
      _streamSubscription?.cancel();
      _frame = null;
      _retryCount = 0;
      _connect();
    }
  }

  Future<void> _connect() async {
    final int connectionId = ++_connectionId;
    try {
      final response =
          await _client.send(http.Request('GET', Uri.parse(widget.url)));
      if (!_isCurrent(connectionId)) {
        return;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
            'MJPEG stream returned HTTP ${response.statusCode}');
      }

      _retryCount = 0;
      final parser = _JpegFrameParser();
      _streamSubscription = response.stream.listen(
        (chunk) {
          if (!_isCurrent(connectionId)) {
            return;
          }
          for (final frame in parser.add(chunk)) {
            if (!mounted || !_isCurrent(connectionId)) {
              return;
            }
            setState(() {
              _frame = frame;
            });
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (_isCurrent(connectionId)) {
            _handleStreamFailure(error);
          }
        },
        onDone: () {
          if (_isCurrent(connectionId)) {
            _handleStreamFailure(
              const HttpException('MJPEG stream ended unexpectedly'),
            );
          }
        },
        cancelOnError: true,
      );
    } catch (error) {
      if (_isCurrent(connectionId)) {
        _handleStreamFailure(error);
      }
    }
  }

  bool _isCurrent(int connectionId) => mounted && connectionId == _connectionId;

  void _handleStreamFailure(Object _) {
    _streamSubscription = null;
    if (!mounted) {
      return;
    }
    _retryTimer?.cancel();
    final delay =
        Duration(milliseconds: 500 + (_retryCount.clamp(0, 10) * 500));
    _retryCount++;
    _retryTimer = Timer(delay, _connect);
  }

  @override
  void dispose() {
    _connectionId++;
    _retryTimer?.cancel();
    _streamSubscription?.cancel();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frame = _frame;
    if (frame != null) {
      return Image.memory(
        frame,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      );
    }
    return const Center(
      child: Icon(Icons.videocam_off, color: Colors.white54),
    );
  }
}

class _JpegFrameParser {
  final List<int> _buffer = <int>[];

  Iterable<Uint8List> add(List<int> chunk) sync* {
    _buffer.addAll(chunk);
    while (true) {
      final start = _findMarker(0xff, 0xd8);
      if (start == -1) {
        _discardUnusableData();
        return;
      }

      final end = _findMarker(0xff, 0xd9, start + 2);
      if (end == -1) {
        if (start > 0) {
          _buffer.removeRange(0, start);
        }
        return;
      }

      yield Uint8List.fromList(_buffer.sublist(start, end + 2));
      _buffer.removeRange(0, end + 2);
    }
  }

  int _findMarker(int first, int second, [int start = 0]) {
    for (var index = start; index < _buffer.length - 1; index++) {
      if (_buffer[index] == first && _buffer[index + 1] == second) {
        return index;
      }
    }
    return -1;
  }

  void _discardUnusableData() {
    if (_buffer.length > 1) {
      _buffer.removeRange(0, _buffer.length - 1);
    }
  }
}

class HttpException implements Exception {
  const HttpException(this.message);

  final String message;

  @override
  String toString() => message;
}

Widget createMjpgView(String url) => _MjpgView(url: url);
