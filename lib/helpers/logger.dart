import 'package:logger/logger.dart';

Logger getLogger() {
  return Logger(
    // filter: null, // Use the default LogFilter (-> only log in debug mode)
    // output: null, // Use the default LogOutput (-> send everything to console)
    printer: PrettyPrinter(
        // number of method calls to be displayed
        // methodCount: 2,
        // number of method calls if stacktrace is provided
        // errorMethodCount: 8,
        // width of the output
        // lineLength: 120,
        // Colorful log messages
        // colors: true,
        // Print an emoji for each log message
        // printEmojis: true,
        // printTime: true, // Should each log print contain a timestamp
        ),
  );
}
