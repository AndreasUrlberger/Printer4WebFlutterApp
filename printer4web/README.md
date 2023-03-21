# printer4web

Printer app for phone and web

## Adding credentials

Add a file named keys.dart under lib/auth.
It contains:

const prusalinkUsername =  "...";
const prusalinkPassword =  "...";


## Building the Web App

You need to add some build options to make sure the http authentication is working:
flutter build -d chrome --web-browser-flag "--disable-web-security"

There is a mention in the daemon logs that the "nouce does not match".