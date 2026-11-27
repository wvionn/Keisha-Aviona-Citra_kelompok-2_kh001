// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Campus Portal';

  @override
  String get detailTitle => 'User Profile';

  @override
  String get email => 'Email';

  @override
  String get city => 'City';

  @override
  String get language => 'Language';

  @override
  String get errorMessage => 'Failed to load data';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No user records found';

  @override
  String get usersTab => 'Users';

  @override
  String get adminsTab => 'Admins';

  @override
  String get apiLabTab => 'API Lab';

  @override
  String get adminDetailTitle => 'Admin Profile';

  @override
  String get department => 'Department';

  @override
  String get name => 'Full Name';

  @override
  String get idLabel => 'ID';

  @override
  String get noAdminData => 'No admin records found';

  @override
  String get deleteAdmin => 'Remove Admin';

  @override
  String get deleteUser => 'Remove User';

  @override
  String get confirmDeleteAdminTitle => 'Remove Admin?';

  @override
  String confirmDeleteAdminMessage(int id) {
    return 'Are you sure you want to permanently remove admin #$id?';
  }

  @override
  String get confirmDeleteUserTitle => 'Remove User?';

  @override
  String confirmDeleteUserMessage(int id) {
    return 'Are you sure you want to permanently remove user #$id?';
  }

  @override
  String adminDeletedSuccess(int id) {
    return 'Admin #$id has been removed';
  }

  @override
  String adminDeletedFailed(int id) {
    return 'Admin #$id was not found';
  }

  @override
  String userDeletedSuccess(int id) {
    return 'User #$id has been removed';
  }

  @override
  String userDeletedFailed(int id) {
    return 'User #$id was not found';
  }

  @override
  String userCreatedSuccess(int id) {
    return 'User #$id created successfully';
  }

  @override
  String userUpdatedSuccess(int id) {
    return 'User #$id updated successfully';
  }

  @override
  String get userPatchedSuccess =>
      'User name updated with \'- Flutter Developer\'';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Remove';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get resetDataTitle => 'Reset Local Data?';

  @override
  String get resetDataMessage =>
      'Restore all User (1104) and Admin (2104) records to initial defaults?';

  @override
  String get resetDataSuccess => 'Local JSON data has been reset';

  @override
  String get jsonStorageTitle => 'Local JSON Storage';

  @override
  String get jsonStorageInfo =>
      'Records are persisted locally in these JSON files:';

  @override
  String get jsonStorageDesc =>
      'All POST, PUT, PATCH, and DELETE actions sync directly to local storage.';

  @override
  String get jsonStorageMenu => 'Storage Info';

  @override
  String get resetDataMenu => 'Reset Data';

  @override
  String get searchUsersHint => 'Search user by name, email, or ID...';

  @override
  String get searchAdminsHint => 'Search admin by name, department, or ID...';

  @override
  String totalRecords(int count) {
    return '$count records';
  }

  @override
  String inspectId(int id) {
    return 'Inspect #$id';
  }

  @override
  String get addNewUser => 'New User';

  @override
  String get addUserTitle => 'Create User (POST)';

  @override
  String get editUserTitle => 'Update User (PUT)';

  @override
  String get putActionShort => 'PUT Edit';

  @override
  String get patchActionShort => 'PATCH +Dev';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get dangerZoneAdminDesc =>
      'Deleting this admin removes it from local JSON storage immediately.';

  @override
  String get openApiLab => 'Test in API Lab';

  @override
  String get nameHint => 'Enter full name';

  @override
  String get emailHint => 'Enter email address';

  @override
  String get cityHint => 'Enter city name';

  @override
  String get idHint => 'e.g. 1104';

  @override
  String get apiConsoleTitle => 'REST API Console';

  @override
  String get apiConsoleSubtitle =>
      'Select entity & HTTP verb, then execute a request.';

  @override
  String get entityLabel => 'Entity';

  @override
  String get methodLabel => 'HTTP Verb';

  @override
  String get executeRequest => 'Execute Request';

  @override
  String get executingRequest => 'Executing...';

  @override
  String get responseOutput => 'JSON Output';

  @override
  String get appendFlutterDevLabel => 'Auto-append \'- Flutter Developer\'';

  @override
  String get enterValidId => 'Enter a valid numeric ID';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get methodInfoGetAll => 'GET All: Fetches the full list of records.';

  @override
  String get methodInfoGetById => 'GET By ID: Fetches a single record by ID.';

  @override
  String get methodInfoPost =>
      'POST: Creates a new User record (default ID: 1104).';

  @override
  String get methodInfoPut =>
      'PUT: Replaces name and email of an existing User.';

  @override
  String get methodInfoPatch =>
      'PATCH: Appends \'- Flutter Developer\' to the User name.';

  @override
  String get methodInfoDelete => 'DELETE: Removes a record permanently by ID.';
}
