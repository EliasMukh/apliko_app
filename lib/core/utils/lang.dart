import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// this class is used to manage app languages
class AppLanguage {
  static var currentLocale = LocaleWithName.english;
  static bool get isLTR => currentLocale.isLTR;

  static List<LocaleWithName> supportedLocales = [
    LocaleWithName.arabic,
    LocaleWithName.english,
  ];

  static List<Locale> getSupportedLocales() => supportedLocales.map((e) => e.locale).toList();

  static void init(BuildContext context) {
    currentLocale = getCurrentLocal(context);
  }

  static LocaleWithName getCurrentLocal(BuildContext context) =>
      supportedLocales.firstWhere((e) => e.locale.languageCode == context.locale.languageCode);

  static Future<void> changeLocale(BuildContext context, Locale locale) async {
    currentLocale = getCurrentLocal(context);
    await context.setLocale(locale);
    final engine = WidgetsFlutterBinding.ensureInitialized();
    await engine.performReassemble();
  }
}

enum LocaleWithName {
  arabic(Locale("ar"), "عربي", true),
  english(Locale("en"), "English", false);

  final Locale locale;
  final String name;
  final bool isLTR;
  const LocaleWithName(this.locale, this.name, this.isLTR);
}
