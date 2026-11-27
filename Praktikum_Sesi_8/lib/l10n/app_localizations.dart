import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  String get appTitle;
  String get detailTitle;
  String get email;
  String get city;
  String get language;
  String get errorMessage;
  String get retry;
  String get noData;
  String get usersTab;
  String get adminsTab;
  String get adminDetailTitle;
  String get department;
  String get name;
  String get idLabel;
  String get noAdminData;
  String get deleteAdmin;
  String get deleteUser;
  String get confirmDeleteAdminTitle;
  String confirmDeleteAdminMessage(int id);
  String get confirmDeleteUserTitle;
  String confirmDeleteUserMessage(int id);
  String adminDeletedSuccess(int id);
  String adminDeletedFailed(int id);
  String userDeletedSuccess(int id);
  String userDeletedFailed(int id);
  String userCreatedSuccess(int id);
  String userUpdatedSuccess(int id);
  String get userPatchedSuccess;
  String get cancel;
  String get delete;
  String get close;
  String get save;
  String get reset;
  String get resetDataTitle;
  String get resetDataMessage;
  String get resetDataSuccess;
  String get jsonStorageTitle;
  String get jsonStorageInfo;
  String get jsonStorageDesc;
  String get jsonStorageTooltip;
  String get resetDataTooltip;
  String get testApi;
  String get apiTesterTitle;
  String get nimBannerText;
  String quickGetUser(int id);
  String quickPostUser(int id);
  String quickGetAdmin(int id);
  String quickDeleteAdmin(int id);
  String get putUpdateAction;
  String get patchFlutterDevAction;
  String get openApiTester;
  String get addUserTitle;
  String get editUserTitle;
  String get nameHint;
  String get emailHint;
  String get cityHint;
  String get idHint;
  String get requestConfiguration;
  String get selectMethodSubtitle;
  String get targetResource;
  String get httpMethod;
  String get sendRequest;
  String get sendingRequest;
  String get responseResult;
  String get appendFlutterDevLabel;
  String get enterValidId;
  String get nameRequired;
  String get emailRequired;
  String get methodInfoGetAll;
  String get methodInfoGetById;
  String get methodInfoPost;
  String get methodInfoPut;
  String get methodInfoPatch;
  String get methodInfoDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
