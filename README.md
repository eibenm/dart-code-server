A web server built using [Shelf](https://pub.dartlang.org/packages/shelf).

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## How To Build
Requires Dart version 2.1.0 or greater

Find your desired target with `make`.  Running `make` executes self documenting makefile logic which will tell you each target and what they do.

## Running the app

```bash
make start-server
```

By default, the server starts on `localhost:8082`.  However, if a different port is required, the direct command can be run with a flag instead:
```bash
dart bin/server.dart --port xxxx
```
