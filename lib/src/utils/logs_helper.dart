import 'package:pubspec_checker/src/constants.dart';

/// A helper class to print logs with dynamic padding for aesthetics.
class LogPrintHelper {
  //   /// Defaults `maxLength` to 60 if not specified.
  final int maxLength;

  /// The maximum length for the log message including padding.
  /// /// Constructor for LogPrintHelper.
  LogPrintHelper({this.maxLength = 60});

  /// Prints the start log message for a given platform.
  ///
  /// Example: `------- Started checking compatibility for "android" -------`
  void printStart(String platformName) {
    printLog('Started checking compatibility for "$platformName"');
  }

  /// Prints the end log message for a given platform.
  ///
  /// Example: `------- Compatibility check completed for "android" -------`
  void printEnd(String platformName) {
    printLog('Compatibility check completed for "$platformName"');
  }

  /// Prints a log message with dynamic hyphen padding.
  ///
  /// Ensures the text is centered within the specified `maxLength`.
  void printLog(String text) {
    int textLength = text.length;
    int totalDashLength = maxLength - textLength - 2; // Account for spaces around text
    int leftDashLength = totalDashLength ~/ 2;
    int rightDashLength = totalDashLength - leftDashLength;

    print('$yellow${'-' * leftDashLength} $text ${'-' * rightDashLength}$reset');
  }
}
