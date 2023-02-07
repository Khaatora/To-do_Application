import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/layout/home_layout.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/modules/settings/settings_provider/settings_provider.dart';
import 'package:todo_own/modules/tasks/edit_task/edit_task_screen.dart';
import 'package:todo_own/my_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.disableNetwork();

  runApp(ChangeNotifierProvider(
      create: (context) => SettingsProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      initialRoute: HomeLayout.routeName,
      onGenerateRoute: (settings) {
        var routes = <String, WidgetBuilder>{
          HomeLayout.routeName: (ctx) => HomeLayout(),
          EditTaskScreen.routeName: (ctx) =>
              EditTaskScreen(settings.arguments as TaskData),
        };
        WidgetBuilder? builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder!(ctx));
      },
      debugShowCheckedModeBanner: false,
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: Locale(provider.langCode),
    );
  }
}
