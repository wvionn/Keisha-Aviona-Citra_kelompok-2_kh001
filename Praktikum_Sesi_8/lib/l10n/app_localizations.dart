import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Campus Portal'**
  String get appTitle;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get detailTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get errorMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No user records found'**
  String get noData;

  /// No description provided for @usersTab.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTab;

  /// No description provided for @adminsTab.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get adminsTab;

  /// No description provided for @apiLabTab.
  ///
  /// In en, this message translates to:
  /// **'API Lab'**
  String get apiLabTab;

  /// No description provided for @adminDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Profile'**
  String get adminDetailTitle;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @noAdminData.
  ///
  /// In en, this message translates to:
  /// **'No admin records found'**
  String get noAdminData;

  /// No description provided for @deleteAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin'**
  String get deleteAdmin;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Remove User'**
  String get deleteUser;

  /// No description provided for @confirmDeleteAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin?'**
  String get confirmDeleteAdminTitle;

  /// No description provided for @confirmDeleteAdminMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently remove admin #{id}?'**
  String confirmDeleteAdminMessage(int id);

  /// No description provided for @confirmDeleteUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove User?'**
  String get confirmDeleteUserTitle;

  /// No description provided for @confirmDeleteUserMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently remove user #{id}?'**
  String confirmDeleteUserMessage(int id);

  /// No description provided for @adminDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin #{id} has been removed'**
  String adminDeletedSuccess(int id);

  /// No description provided for @adminDeletedFailed.
  ///
  /// In en, this message translates to:
  /// **'Admin #{id} was not found'**
  String adminDeletedFailed(int id);

  /// No description provided for @userDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User #{id} has been removed'**
  String userDeletedSuccess(int id);

  /// No description provided for @userDeletedFailed.
  ///
  /// In en, this message translates to:
  /// **'User #{id} was not found'**
  String userDeletedFailed(int id);

  /// No description provided for @userCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User #{id} created successfully'**
  String userCreatedSuccess(int id);

  /// No description provided for @userUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User #{id} updated successfully'**
  String userUpdatedSuccess(int id);

  /// No description provided for @userPatchedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User name updated with \'- Flutter Developer\''**
  String get userPatchedSuccess;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Local Data?'**
  String get resetDataTitle;

  /// No description provided for @resetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Restore all User (1104) and Admin (2104) records to initial defaults?'**
  String get resetDataMessage;

  /// No description provided for @resetDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local JSON data has been reset'**
  String get resetDataSuccess;

  /// No description provided for @jsonStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Local JSON Storage'**
  String get jsonStorageTitle;

  /// No description provided for @jsonStorageInfo.
  ///
  /// In en, this message translates to:
  /// **'Records are persisted locally in these JSON files:'**
  String get jsonStorageInfo;

  /// No description provided for @jsonStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'All POST, PUT, PATCH, and DELETE actions sync directly to local storage.'**
  String get jsonStorageDesc;

  /// No description provided for @jsonStorageMenu.
  ///
  /// In en, this message translates to:
  /// **'Storage Info'**
  String get jsonStorageMenu;

  /// No description provided for @resetDataMenu.
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetDataMenu;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search user by name, email, or ID...'**
  String get searchUsersHint;

  /// No description provided for @searchAdminsHint.
  ///
  /// In en, this message translates to:
  /// **'Search admin by name, department, or ID...'**
  String get searchAdminsHint;

  /// No description provided for @totalRecords.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String totalRecords(int count);

  /// No description provided for @inspectId.
  ///
  /// In en, this message translates to:
  /// **'Inspect #{id}'**
  String inspectId(int id);

  /// No description provided for @addNewUser.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get addNewUser;

  /// No description provided for @addUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Create User (POST)'**
  String get addUserTitle;

  /// No description provided for @editUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Update User (PUT)'**
  String get editUserTitle;

  /// No description provided for @putActionShort.
  ///
  /// In en, this message translates to:
  /// **'PUT Edit'**
  String get putActionShort;

  /// No description provided for @patchActionShort.
  ///
  /// In en, this message translates to:
  /// **'PATCH +Dev'**
  String get patchActionShort;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'Deleting this admin removes it from local JSON storage immediately.'**
  String get dangerZoneAdminDesc;

  /// No description provided for @openApiLab.
  ///
  /// In en, this message translates to:
  /// **'Test in API Lab'**
  String get openApiLab;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get nameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get emailHint;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get cityHint;

  /// No description provided for @idHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1104'**
  String get idHint;

  /// No description provided for @apiConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'REST API Console'**
  String get apiConsoleTitle;

  /// No description provided for @apiConsoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select entity & HTTP verb, then execute a request.'**
  String get apiConsoleSubtitle;

  /// No description provided for @entityLabel.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entityLabel;

  /// No description provided for @methodLabel.
  ///
  /// In en, this message translates to:
  /// **'HTTP Verb'**
  String get methodLabel;

  /// No description provided for @executeRequest.
  ///
  /// In en, this message translates to:
  /// **'Execute Request'**
  String get executeRequest;

  /// No description provided for @executingRequest.
  ///
  /// In en, this message translates to:
  /// **'Executing...'**
  String get executingRequest;

  /// No description provided for @responseOutput.
  ///
  /// In en, this message translates to:
  /// **'JSON Output'**
  String get responseOutput;

  /// No description provided for @appendFlutterDevLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto-append \'- Flutter Developer\''**
  String get appendFlutterDevLabel;

  /// No description provided for @enterValidId.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid numeric ID'**
  String get enterValidId;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @methodInfoGetAll.
  ///
  /// In en, this message translates to:
  /// **'GET All: Fetches the full list of records.'**
  String get methodInfoGetAll;

  /// No description provided for @methodInfoGetById.
  ///
  /// In en, this message translates to:
  /// **'GET By ID: Fetches a single record by ID.'**
  String get methodInfoGetById;

  /// No description provided for @methodInfoPost.
  ///
  /// In en, this message translates to:
  /// **'POST: Creates a new User record (default ID: 1104).'**
  String get methodInfoPost;

  /// No description provided for @methodInfoPut.
  ///
  /// In en, this message translates to:
  /// **'PUT: Replaces name and email of an existing User.'**
  String get methodInfoPut;

  /// No description provided for @methodInfoPatch.
  ///
  /// In en, this message translates to:
  /// **'PATCH: Appends \'- Flutter Developer\' to the User name.'**
  String get methodInfoPatch;

  /// No description provided for @methodInfoDelete.
  ///
  /// In en, this message translates to:
  /// **'DELETE: Removes a record permanently by ID.'**
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
  // Lookup logic when only language code is specified.
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
