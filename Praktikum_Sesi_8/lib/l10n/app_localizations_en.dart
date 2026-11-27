// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Student Directory';

  @override
  String get detailTitle => 'User Details';

  @override
  String get email => 'Email';

  @override
  String get city => 'City';

  @override
  String get language => 'Language';

  @override
  String get errorMessage => 'Failed to retrieve data';

  @override
  String get retry => 'Try Again';

  @override
  String get noData => 'No user data available';

  @override
  String get usersTab => 'Users';

  @override
  String get adminsTab => 'Admins';

  @override
  String get adminDetailTitle => 'Admin Details';

  @override
  String get department => 'Department';

  @override
  String get name => 'Name';

  @override
  String get idLabel => 'ID';

  @override
  String get noAdminData => 'No admin data available';

  @override
  String get deleteAdmin => 'Delete Admin';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get confirmDeleteAdminTitle => 'Delete Admin?';

  @override
  String confirmDeleteAdminMessage(int id) {
    return 'Are you sure you want to delete admin with ID $id?';
  }

  @override
  String get confirmDeleteUserTitle => 'Delete User?';

  @override
  String confirmDeleteUserMessage(int id) {
    return 'Are you sure you want to delete user with ID $id?';
  }

  @override
  String adminDeletedSuccess(int id) {
    return 'Admin with ID $id deleted successfully';
  }

  @override
  String adminDeletedFailed(int id) {
    return 'Admin with ID $id not found or failed to delete';
  }

  @override
  String userDeletedSuccess(int id) {
    return 'User with ID $id deleted successfully';
  }

  @override
  String userDeletedFailed(int id) {
    return 'User with ID $id not found or failed to delete';
  }

  @override
  String userCreatedSuccess(int id) {
    return 'User with ID $id created successfully';
  }

  @override
  String userUpdatedSuccess(int id) {
    return 'User with ID $id updated successfully';
  }

  @override
  String get userPatchedSuccess =>
      'User name patched with \'- Flutter Developer\'';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get resetDataTitle => 'Reset JSON Data?';

  @override
  String get resetDataMessage =>
      'Are you sure you want to restore User and Admin data to the initial state?';

  @override
  String get resetDataSuccess => 'User and Admin JSON data restored to default';

  @override
  String get jsonStorageTitle => 'JSON File Storage';

  @override
  String get jsonStorageInfo =>
      'Data is stored permanently in local JSON files:';

  @override
  String get jsonStorageDesc =>
      'Every POST, PUT, PATCH, and DELETE operation updates these local JSON files directly.';

  @override
  String get jsonStorageTooltip => 'JSON File Locations';

  @override
  String get resetDataTooltip => 'Reset JSON Data to Default';

  @override
  String get testApi => 'Test API';

  @override
  String get apiTesterTitle => 'API Method Tester';

  @override
  String get nimBannerText =>
      'NIM: 20240801105  •  User ID: 1105  •  Admin ID: 2105';

  @override
  String quickGetUser(int id) {
    return 'GET User $id';
  }

  @override
  String quickPostUser(int id) {
    return 'POST User $id';
  }

  @override
  String quickGetAdmin(int id) {
    return 'GET Admin $id';
  }

  @override
  String quickDeleteAdmin(int id) {
    return 'DELETE Admin $id';
  }

  @override
  String get putUpdateAction => 'PUT (Edit Name & Email)';

  @override
  String get patchFlutterDevAction => 'PATCH (+ Flutter Developer)';

  @override
  String get openApiTester => 'Open in API Tester';

  @override
  String get addUserTitle => 'Add New User (POST)';

  @override
  String get editUserTitle => 'Update User (PUT)';

  @override
  String get nameHint => 'Enter user name';

  @override
  String get emailHint => 'Enter user email';

  @override
  String get cityHint => 'Enter city';

  @override
  String get idHint => 'Example: 1105';

  @override
  String get requestConfiguration => 'Request Configuration';

  @override
  String get selectMethodSubtitle =>
      'Choose target resource, HTTP method, and enter request data.';

  @override
  String get targetResource => 'Target Resource';

  @override
  String get httpMethod => 'HTTP Method';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get sendingRequest => 'Sending Request...';

  @override
  String get responseResult => 'Response Result';

  @override
  String get appendFlutterDevLabel => 'Append \'- Flutter Developer\' to name';

  @override
  String get enterValidId => 'Please enter a valid numeric ID';

  @override
  String get nameRequired => 'Name cannot be empty';

  @override
  String get emailRequired => 'Email cannot be empty';

  @override
  String get methodInfoGetAll =>
      'GET (All): Retrieves all records from the selected resource.';

  @override
  String get methodInfoGetById =>
      'GET (By ID): Retrieves a single record matching the given ID.';

  @override
  String get methodInfoPost =>
      'POST: Creates a new User record with the specified ID (default: 1105).';

  @override
  String get methodInfoPut =>
      'PUT: Updates both name and email of the selected User.';

  @override
  String get methodInfoPatch =>
      'PATCH: Partially updates the User name by appending \'- Flutter Developer\'.';

  @override
  String get methodInfoDelete =>
      'DELETE: Removes the record matching the specified ID.';
}
