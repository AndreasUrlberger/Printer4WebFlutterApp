import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:printer4web/printer_settings.dart';

import 'app_config.dart';

class HtmlView extends StatelessWidget {
  final String html = """
<html>
  <body style="margin: 0; padding: 0">
    <img
      id="image"
      src=$mjpgStreamAddress
      height="100%"
      width="100%"
      onError="reloadImage()"
    />
    <script>
      function adjustStyle() {
        if (window.navigator.userAgent.indexOf("Trident") > -1) {
          document.body.style.msOverflowStyle = "none";
        }
        if (window.navigator.userAgent.indexOf("Chrome") > -1 || window.navigator.userAgent.indexOf("Safari") > -1) {
          document.documentElement.style.WebkitScrollbar = "display: none;";
        }
        document.documentElement.style.overflow = "hidden";
      }

      function reloadImage() {
        setTimeout(function () {
          document.getElementById('image').src = "$mjpgStreamAddress?" + new Date().getTime();
        }, $mjpgImageReloadIntervalMS);
      }

      window.onload = adjustStyle;
    </script>
  </body>
</html>
""";

  const HtmlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'html-view',
      (int viewId) {
        final element = IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..srcdoc = html
          ..style.border = 'none';

        return element;
      },
    );

    return const HtmlElementView(viewType: 'html-view');
  }
}
