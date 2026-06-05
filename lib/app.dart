import 'package:flutter/material.dart';
import 'shared/theme/theme.dart';
import 'shared/theme/util.dart';

class App extends StatelessWidget {
  final String initialRoute;
  final Map<String, Widget Function(BuildContext)> routes;

  const App({
    super.key,
    required this.initialRoute,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Montserrat', 'Roboto');
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Financial App',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}