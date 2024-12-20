import 'package:pubspec_checker/src/constants.dart';

class LogPrintHelper {
  final int maxLength;

  LogPrintHelper({this.maxLength = 60});

  void printStart(String platformName) {
    printLog('Started checking compatibility for "$platformName"');
  }

  void printEnd(String platformName) {
    printLog('Compatibility check completed for "$platformName"');
  }

  void printLog(String text) {
    int textLength = text.length;
    int totalDashLength = maxLength - textLength - 2; // Account for spaces around text
    int leftDashLength = totalDashLength ~/ 2;
    int rightDashLength = totalDashLength - leftDashLength;

    print('$yellow${'-' * leftDashLength} $text ${'-' * rightDashLength}$reset');
  }
}
