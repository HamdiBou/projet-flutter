import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';
import 'services/localization_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon'); // replace app_icon with your app's icon name
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
      onDidReceiveBackgroundNotificationResponse: null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, LanguageService>(
      builder: (context, themeService, languageService, child) {
        return MaterialApp(
          title: 'Quiz App',
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: languageService.currentLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('fr', 'FR'),
            Locale('ar', 'SA'),
          ],
          localizationsDelegates: const [
            LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  final String _key = "language";

  Locale get currentLocale => _currentLocale;

  LanguageService() {
    _loadFromPrefs();
  }

  Future<void> setLocale(Locale locale) async {
    _currentLocale = locale;
    notifyListeners();
    await _saveToPrefs(locale);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_key) ?? 'en';
    _currentLocale = Locale(languageCode, languageCode == 'en' ? 'US' : languageCode == 'fr' ? 'FR' : 'SA');
    notifyListeners();
  }

  Future<void> _saveToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
