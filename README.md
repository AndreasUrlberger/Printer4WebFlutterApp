# Printer4WebFlutterApp

This flutter app serves as a companion app to the [PrinterServiceController](https://github.com/AndreasUrlberger/PrinterServiceController). It connects to the housing's API and displays the temperature and print progress as well as a live webcam view. It allwos configuration of print profiles which automatically sync with the housing and allows preheating of the printer nozzle and heatbed through the Prusa API. The app can be build as an android app as well as for the web.

## Settings and persistence

Open the gear icon in the app bar to configure the printer and PrusaLink
hosts, service ports, and PrusaLink credentials. The values in
`printer4web/lib/printer_settings.dart` are used as defaults. Settings are
persisted with `shared_preferences`: native builds use platform preferences
and web builds use browser local storage for the current origin.

The PrusaLink password field is write-only in the UI. The built-in password is
never copied to preferences; a user-entered override is stored so it survives
restarts, but `shared_preferences` does not provide cryptographic secret
storage. Resetting settings removes the override and restores the built-in
default.

## Android builds

The Android project uses Gradle 9.3.1 and Android Gradle Plugin 9.1.0. These
versions support Java 25:

```powershell
flutter build apk
```

Flutter's Android plugin setup must remain declarative. Do not restore the
deprecated `app_plugin_loader.gradle` or `flutter.gradle` script applications.

# Libraries and Licenses

The project makes use of the following libraries:
- [protobuf](https://pub.dev/packages/protobuf)
- [flutter_custom_tabs](https://pub.dev/packages/flutter_custom_tabs)
- [webviewx](https://pub.dev/packages/webviewx)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [tuple](https://pub.dev/packages/tuple)

The according licenses can be found in the linked packages.
