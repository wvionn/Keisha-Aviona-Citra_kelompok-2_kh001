import 'dart:convert';
import 'package:flutter/material.dart';

import '../constants/nim_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/admin.dart';
import '../models/user_model.dart';
import '../services/admin_service.dart';
import '../services/api_service.dart';

enum ApiResource { user, admin }

class ApiTesterScreen extends StatefulWidget {
  final ApiResource initialResource;
  final String? initialMethod;
  final int? initialId;

  const ApiTesterScreen({
    super.key,
    this.initialResource = ApiResource.user,
    this.initialMethod,
    this.initialId,
  });

  @override
  State<ApiTesterScreen> createState() => _ApiTesterScreenState();
}

class _ApiTesterScreenState extends State<ApiTesterScreen> {
  late ApiResource selectedResource;
  late String selectedMethod;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController(text: 'Jakarta');

  bool appendFlutterDeveloper = true;
  bool isLoading = false;

  dynamic result;
  String? errorMessage;

  List<String> get availableMethods => selectedResource == ApiResource.user
      ? const ['GET_ALL', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE']
      : const ['GET_ALL', 'GET', 'DELETE'];

  @override
  void initState() {
    super.initState();
    selectedResource = widget.initialResource;
    final defaultMethod =
        widget.initialMethod ?? (widget.initialId != null ? 'GET' : 'GET');
    selectedMethod = availableMethods.contains(defaultMethod)
        ? defaultMethod
        : availableMethods.first;

    idController.text = (widget.initialId ??
            (selectedResource == ApiResource.user
                ? NimConstants.userId
                : NimConstants.adminId))
        .toString();
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _onResourceChanged(ApiResource resource) {
    setState(() {
      selectedResource = resource;
      if (!availableMethods.contains(selectedMethod)) {
        selectedMethod = 'GET';
      }
      idController.text = (resource == ApiResource.user
              ? NimConstants.userId
              : NimConstants.adminId)
          .toString();
      result = null;
      errorMessage = null;
    });
  }

  Future<void> sendRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final id = int.tryParse(idController.text.trim());

    final needsId = selectedMethod != 'GET_ALL';
    if (needsId && id == null) {
      showMessage(l10n.enterValidId);
      return;
    }

    if (selectedResource == ApiResource.user) {
      if ((selectedMethod == 'POST' || selectedMethod == 'PUT') &&
          nameController.text.trim().isEmpty) {
        showMessage(l10n.nameRequired);
        return;
      }

      if ((selectedMethod == 'POST' || selectedMethod == 'PUT') &&
          emailController.text.trim().isEmpty) {
        showMessage(l10n.emailRequired);
        return;
      }

      if (selectedMethod == 'PATCH' &&
          !appendFlutterDeveloper &&
          nameController.text.trim().isEmpty) {
        showMessage(l10n.nameRequired);
        return;
      }
    }

    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      dynamic response;

      if (selectedResource == ApiResource.user) {
        switch (selectedMethod) {
          case 'GET_ALL':
            final List<User> users = await ApiService.getUsers();
            response = {
              'method': 'GET',
              'endpoint': ApiService.usersEndpoint,
              'count': users.length,
              'data': users.map((u) => u.toJson()).toList(),
            };
            break;

          case 'GET':
            final User user = await ApiService.getUser(id!);
            response = {
              'method': 'GET',
              'endpoint': '${ApiService.usersEndpoint}/$id',
              'data': user.toJson(),
            };
            break;

          case 'POST':
            final User created = await ApiService.createUser(
              nameController.text.trim(),
              emailController.text.trim(),
              id: id!,
              city: cityController.text.trim().isEmpty
                  ? 'Jakarta'
                  : cityController.text.trim(),
            );
            response = {
              'method': 'POST',
              'endpoint': ApiService.usersEndpoint,
              'status': 201,
              'message': l10n.userCreatedSuccess(created.id),
              'data': created.toJson(),
            };
            break;

          case 'PUT':
            final User updated = await ApiService.updateUser(
              id!,
              nameController.text.trim(),
              emailController.text.trim(),
              city: cityController.text.trim(),
            );
            response = {
              'method': 'PUT',
              'endpoint': '${ApiService.usersEndpoint}/$id',
              'status': 200,
              'message': l10n.userUpdatedSuccess(updated.id),
              'data': updated.toJson(),
            };
            break;

          case 'PATCH':
            final User patched = await ApiService.patchUser(
              id!,
              name: nameController.text.trim(),
              appendFlutterDeveloper: appendFlutterDeveloper,
            );
            response = {
              'method': 'PATCH',
              'endpoint': '${ApiService.usersEndpoint}/$id',
              'status': 200,
              'message': l10n.userPatchedSuccess,
              'data': patched.toJson(),
            };
            break;

          case 'DELETE':
            final bool deleted = await ApiService.deleteUser(id!);
            response = {
              'method': 'DELETE',
              'endpoint': '${ApiService.usersEndpoint}/$id',
              'success': deleted,
              'message': deleted
                  ? l10n.userDeletedSuccess(id)
                  : l10n.userDeletedFailed(id),
            };
            break;
        }
      } else {
        switch (selectedMethod) {
          case 'GET_ALL':
            final List<Admin> admins = await AdminService.getAdmins();
            response = {
              'method': 'GET',
              'endpoint': AdminService.adminsEndpoint,
              'count': admins.length,
              'data': admins.map((a) => a.toJson()).toList(),
            };
            break;

          case 'GET':
            final Admin admin = await AdminService.getAdmin(id!);
            response = {
              'method': 'GET',
              'endpoint': '${AdminService.adminsEndpoint}/$id',
              'data': admin.toJson(),
            };
            break;

          case 'DELETE':
            final bool deleted = await AdminService.deleteAdmin(id!);
            response = {
              'method': 'DELETE',
              'endpoint': '${AdminService.adminsEndpoint}/$id',
              'success': deleted,
              'message': deleted
                  ? l10n.adminDeletedSuccess(id)
                  : l10n.adminDeletedFailed(id),
            };
            break;
        }
      }

      if (!mounted) return;
      setState(() {
        result = response;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _methodLabel(String method) {
    switch (method) {
      case 'GET_ALL':
        return 'GET (All) - Retrieve All Data';
      case 'GET':
        return 'GET (By ID) - Retrieve Single Data';
      case 'POST':
        return 'POST - Create Data (ID 1105)';
      case 'PUT':
        return 'PUT - Replace Name & Email';
      case 'PATCH':
        return 'PATCH - Append - Flutter Developer';
      case 'DELETE':
        return 'DELETE - Remove Data';
      default:
        return method;
    }
  }

  String _methodDescription(AppLocalizations l10n) {
    switch (selectedMethod) {
      case 'GET_ALL':
        return l10n.methodInfoGetAll;
      case 'GET':
        return l10n.methodInfoGetById;
      case 'POST':
        return l10n.methodInfoPost;
      case 'PUT':
        return l10n.methodInfoPut;
      case 'PATCH':
        return l10n.methodInfoPatch;
      case 'DELETE':
        return l10n.methodInfoDelete;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUser = selectedResource == ApiResource.user;
    final isGetAll = selectedMethod == 'GET_ALL';
    final isPost = selectedMethod == 'POST';
    final isPut = selectedMethod == 'PUT';
    final isPatch = selectedMethod == 'PATCH';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.apiTesterTitle),
        backgroundColor: isUser ? Colors.blue : Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.requestConfiguration,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.selectMethodSubtitle,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // TARGET RESOURCE SELECTOR
            Text(
              l10n.targetResource,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ApiResource>(
                segments: [
                  ButtonSegment(
                    value: ApiResource.user,
                    icon: const Icon(Icons.person),
                    label: Text('${l10n.usersTab} (${NimConstants.userId})'),
                  ),
                  ButtonSegment(
                    value: ApiResource.admin,
                    icon: const Icon(Icons.admin_panel_settings),
                    label: Text('${l10n.adminsTab} (${NimConstants.adminId})'),
                  ),
                ],
                selected: {selectedResource},
                onSelectionChanged: (values) {
                  _onResourceChanged(values.first);
                },
              ),
            ),
            const SizedBox(height: 20),

            // METHOD DROPDOWN
            Text(
              l10n.httpMethod,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.api),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMethod,
                  isExpanded: true,
                  items: availableMethods
                      .map(
                        (m) => DropdownMenuItem<String>(
                          value: m,
                          child: Text(_methodLabel(m)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedMethod = value;
                      result = null;
                      errorMessage = null;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ID INPUT (digunakan untuk GET By ID, POST, PUT, PATCH, DELETE)
            if (!isGetAll) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isUser
                        ? '${l10n.usersTab} ${l10n.idLabel}'
                        : '${l10n.adminsTab} ${l10n.idLabel}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.bolt, size: 16),
                    label: Text(
                      'NIM ID: ${isUser ? NimConstants.userId : NimConstants.adminId}',
                    ),
                    onPressed: () {
                      idController.text = (isUser
                              ? NimConstants.userId
                              : NimConstants.adminId)
                          .toString();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: isUser ? l10n.idHint : '2105',
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // NAME INPUT (untuk User POST, PUT, PATCH)
            if (isUser && (isPost || isPut || isPatch)) ...[
              Text(
                l10n.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: isPatch
                      ? '${l10n.nameHint} (opsional jika append)'
                      : l10n.nameHint,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // APPEND SUFFIX CHECKBOX FOR PATCH
            if (isUser && isPatch) ...[
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: appendFlutterDeveloper,
                title: Text(l10n.appendFlutterDevLabel),
                onChanged: (val) {
                  setState(() {
                    appendFlutterDeveloper = val ?? true;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],

            // EMAIL INPUT (untuk User POST dan PUT)
            if (isUser && (isPost || isPut)) ...[
              Text(
                l10n.email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.emailHint,
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // CITY INPUT (untuk User POST)
            if (isUser && isPost) ...[
              Text(
                l10n.city,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.cityHint,
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // METHOD INFO BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (isUser ? Colors.blue : Colors.teal)
                    .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _methodDescription(l10n),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : sendRequest,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  isLoading ? l10n.sendingRequest : l10n.sendRequest,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUser ? Colors.blue : Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // RESPONSE RESULT
            if (result != null || errorMessage != null) ...[
              Text(
                l10n.responseResult,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: errorMessage != null
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: errorMessage != null ? Colors.red : Colors.green,
                  ),
                ),
                child: SelectableText(
                  errorMessage != null
                      ? errorMessage!
                      : const JsonEncoder.withIndent('  ').convert(result),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
