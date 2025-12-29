import 'dart:js_interop';

@JS('console.log')
external void _consoleLog(JSAny? value);

void writeStdout(String value) {
  _consoleLog(value.toJS);
}

void writeCarriageReturn() {
  // Browsers cannot overwrite console lines.
  // We emit an empty log or carriage marker instead.
  _consoleLog('\r'.toJS);
}
