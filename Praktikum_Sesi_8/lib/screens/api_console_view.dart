import 'dart:convert';
import 'package:flutter/material.dart';

import '../constants/nim_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/admin.dart';
import '../models/user_model.dart';
import '../services/admin_service.dart';
import '../services/api_service.dart';

enum ConsoleEntity { user, admin }

class ApiConsoleScreen extends StatelessWidget {
  final ConsoleEntity initialEntity;
  final String? initialMethod;
  final int? initialId;

  const ApiConsoleScreen({
    super.key,
    this.initialEntity = ConsoleEntity.user,
    this.initialMethod,
    this.initialId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.apiConsoleTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ApiConsoleView(
        initialEntity: initialEntity,
        initialMethod: initialMethod,
        initialId: initialId,
      ),
    );
  }
}

class ApiConsoleView extends StatefulWidget {
  final ConsoleEntity initialEntity;
  final String? initialMethod;
  final int? initialId;
  final VoidCallback? onDataChanged;

  const ApiConsoleView({
    super.key,
    this.initialEntity = ConsoleEntity.user,
    this.initialMethod,
    this.initialId,
    this.onDataChanged,
  });

  @override
  State<ApiConsoleView> createState() => _ApiConsoleViewState();
}

class _ApiConsoleViewState extends State<ApiConsoleView> {
  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _amber = Color(0xFFD97706);

  late ConsoleEntity _entity;
  late String _method;

  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: 'Jakarta');

  bool _appendFlutterDev = true;
  bool _isRunning = false;
  dynamic _output;
  String? _error;

  List<String> get _methods => _entity == ConsoleEntity.user
      ? const ['GET_ALL', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE']
      : const ['GET_ALL', 'GET', 'DELETE'];

  @override
  void initState() {
    super.initState();
    _entity = widget.initialEntity;
    final desired = widget.initialMethod ?? 'GET';
    _method = _methods.contains(desired) ? desired : _methods.first;
    _idCtrl.text = (widget.initialId ??
            (_entity == ConsoleEntity.user
                ? NimConstants.userId
                : NimConstants.adminId))
        .toString();
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _selectEntity(ConsoleEntity next) {
    setState(() {
      _entity = next;
      if (!_methods.contains(_method)) {
        _method = 'GET';
      }
      _idCtrl.text = (next == ConsoleEntity.user
              ? NimConstants.userId
              : NimConstants.adminId)
          .toString();
      _output = null;
      _error = null;
    });
  }

  Color _verbColor(String verb) {
    switch (verb) {
      case 'GET_ALL':
      case 'GET':
        return const Color(0xFF059669);
      case 'POST':
        return _indigo;
      case 'PUT':
        return _amber;
      case 'PATCH':
        return const Color(0xFF7C3AED);
      case 'DELETE':
        return const Color(0xFFDC2626);
      default:
        return _indigo;
    }
  }

  String _verbLabel(String verb) {
    switch (verb) {
      case 'GET_ALL':
        return 'GET All';
      case 'GET':
        return 'GET ID';
      default:
        return verb;
    }
  }

  String _verbHint(AppLocalizations l10n) {
    switch (_method) {
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

  Future<void> _execute() async {
    final l10n = AppLocalizations.of(context)!;
    final parsedId = int.tryParse(_idCtrl.text.trim());

    if (_method != 'GET_ALL' && parsedId == null) {
      _snack(l10n.enterValidId);
      return;
    }

    if (_entity == ConsoleEntity.user) {
      if ((_method == 'POST' || _method == 'PUT') &&
          _nameCtrl.text.trim().isEmpty) {
        _snack(l10n.nameRequired);
        return;
      }
      if ((_method == 'POST' || _method == 'PUT') &&
          _emailCtrl.text.trim().isEmpty) {
        _snack(l10n.emailRequired);
        return;
      }
      if (_method == 'PATCH' &&
          !_appendFlutterDev &&
          _nameCtrl.text.trim().isEmpty) {
        _snack(l10n.nameRequired);
        return;
      }
    }

    setState(() {
      _isRunning = true;
      _output = null;
      _error = null;
    });

    try {
      dynamic res;
      bool mutated = false;

      if (_entity == ConsoleEntity.user) {
        switch (_method) {
          case 'GET_ALL':
            final List<User> users = await ApiService.getUsers();
            res = {
              'method': 'GET',
              'endpoint': ApiService.usersEndpoint,
              'count': users.length,
              'data': users.map((e) => e.toJson()).toList(),
            };
            break;
          case 'GET':
            final User user = await ApiService.getUser(parsedId!);
            res = {
              'method': 'GET',
              'endpoint': '${ApiService.usersEndpoint}/$parsedId',
              'data': user.toJson(),
            };
            break;
          case 'POST':
            final User created = await ApiService.createUser(
              _nameCtrl.text.trim(),
              _emailCtrl.text.trim(),
              id: parsedId!,
              city: _cityCtrl.text.trim().isEmpty
                  ? 'Jakarta'
                  : _cityCtrl.text.trim(),
            );
            mutated = true;
            res = {
              'method': 'POST',
              'endpoint': ApiService.usersEndpoint,
              'status': 201,
              'message': l10n.userCreatedSuccess(created.id),
              'data': created.toJson(),
            };
            break;
          case 'PUT':
            final User updated = await ApiService.updateUser(
              parsedId!,
              _nameCtrl.text.trim(),
              _emailCtrl.text.trim(),
              city: _cityCtrl.text.trim(),
            );
            mutated = true;
            res = {
              'method': 'PUT',
              'endpoint': '${ApiService.usersEndpoint}/$parsedId',
              'status': 200,
              'message': l10n.userUpdatedSuccess(updated.id),
              'data': updated.toJson(),
            };
            break;
          case 'PATCH':
            final User patched = await ApiService.patchUser(
              parsedId!,
              name: _nameCtrl.text.trim(),
              appendFlutterDeveloper: _appendFlutterDev,
            );
            mutated = true;
            res = {
              'method': 'PATCH',
              'endpoint': '${ApiService.usersEndpoint}/$parsedId',
              'status': 200,
              'message': l10n.userPatchedSuccess,
              'data': patched.toJson(),
            };
            break;
          case 'DELETE':
            final bool deleted = await ApiService.deleteUser(parsedId!);
            mutated = deleted;
            res = {
              'method': 'DELETE',
              'endpoint': '${ApiService.usersEndpoint}/$parsedId',
              'success': deleted,
              'message': deleted
                  ? l10n.userDeletedSuccess(parsedId)
                  : l10n.userDeletedFailed(parsedId),
            };
            break;
        }
      } else {
        switch (_method) {
          case 'GET_ALL':
            final List<Admin> admins = await AdminService.getAdmins();
            res = {
              'method': 'GET',
              'endpoint': AdminService.adminsEndpoint,
              'count': admins.length,
              'data': admins.map((e) => e.toJson()).toList(),
            };
            break;
          case 'GET':
            final Admin admin = await AdminService.getAdmin(parsedId!);
            res = {
              'method': 'GET',
              'endpoint': '${AdminService.adminsEndpoint}/$parsedId',
              'data': admin.toJson(),
            };
            break;
          case 'DELETE':
            final bool deleted = await AdminService.deleteAdmin(parsedId!);
            mutated = deleted;
            res = {
              'method': 'DELETE',
              'endpoint': '${AdminService.adminsEndpoint}/$parsedId',
              'success': deleted,
              'message': deleted
                  ? l10n.adminDeletedSuccess(parsedId)
                  : l10n.adminDeletedFailed(parsedId),
            };
            break;
        }
      }

      if (mutated) {
        widget.onDataChanged?.call();
      }
      if (!mounted) return;
      setState(() => _output = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isRunning = false);
      }
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUser = _entity == ConsoleEntity.user;
    final accent = isUser ? _indigo : _amber;
    final verbColor = _verbColor(_method);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENTITY SELECTOR CARDS (2 kolom)
          Text(
            l10n.entityLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _EntityCard(
                  icon: Icons.group_rounded,
                  title: l10n.usersTab,
                  subtitle: 'ID #${NimConstants.userId}',
                  selected: isUser,
                  color: _indigo,
                  onTap: () => _selectEntity(ConsoleEntity.user),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _EntityCard(
                  icon: Icons.shield_rounded,
                  title: l10n.adminsTab,
                  subtitle: 'ID #${NimConstants.adminId}',
                  selected: !isUser,
                  color: _amber,
                  onTap: () => _selectEntity(ConsoleEntity.admin),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // HTTP VERB CHIPS (POSTMAN STYLE)
          Text(
            l10n.methodLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _methods.map((verb) {
              final selected = _method == verb;
              final c = _verbColor(verb);
              return ChoiceChip(
                label: Text(
                  _verbLabel(verb),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: selected ? Colors.white : c,
                  ),
                ),
                selected: selected,
                showCheckmark: false,
                selectedColor: c,
                backgroundColor: c.withValues(alpha: 0.08),
                side: BorderSide(color: c.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (_) {
                  setState(() {
                    _method = verb;
                    _output = null;
                    _error = null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // INPUT FORM CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // METHOD DESCRIPTION PILL
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: verbColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      left: BorderSide(color: verbColor, width: 3.5),
                    ),
                  ),
                  child: Text(
                    _verbHint(l10n),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),

                if (_method != 'GET_ALL') ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${isUser ? l10n.usersTab : l10n.adminsTab} ${l10n.idLabel}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: accent,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          _idCtrl.text = (isUser
                                  ? NimConstants.userId
                                  : NimConstants.adminId)
                              .toString();
                        },
                        icon: const Icon(Icons.auto_fix_high, size: 15),
                        label: Text(
                          'ID ${isUser ? NimConstants.userId : NimConstants.adminId}',
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _idCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      hintText: isUser ? l10n.idHint : '2104',
                      prefixIcon: const Icon(Icons.tag, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                  ),
                ],

                if (isUser &&
                    (_method == 'POST' ||
                        _method == 'PUT' ||
                        _method == 'PATCH')) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      labelText: l10n.name,
                      hintText: l10n.nameHint,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                if (isUser && _method == 'PATCH') ...[
                  const SizedBox(height: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: const Color(0xFF7C3AED),
                    title: Text(
                      l10n.appendFlutterDevLabel,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: _appendFlutterDev,
                    onChanged: (v) => setState(() => _appendFlutterDev = v),
                  ),
                ],

                if (isUser && (_method == 'POST' || _method == 'PUT')) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      labelText: l10n.email,
                      hintText: l10n.emailHint,
                      prefixIcon: const Icon(Icons.alternate_email, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                if (isUser && _method == 'POST') ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cityCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      labelText: l10n.city,
                      hintText: l10n.cityHint,
                      prefixIcon: const Icon(Icons.location_on_outlined,
                          size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _isRunning ? null : _execute,
                    style: FilledButton.styleFrom(
                      backgroundColor: verbColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isRunning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      _isRunning ? l10n.executingRequest : l10n.executeRequest,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DARK TERMINAL RESPONSE OUTPUT
          if (_output != null || _error != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  l10n.responseOutput,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _error != null
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _error != null ? 'ERROR' : 'OK • $_method',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _error != null
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFF15803D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _error != null
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF334155),
                ),
              ),
              child: SelectableText(
                _error ?? const JsonEncoder.withIndent('  ').convert(_output),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.45,
                  color: _error != null
                      ? const Color(0xFFFCA5A5)
                      : const Color(0xFF86EFAC),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EntityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _EntityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFFE2E8F0),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? color : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: selected ? color : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
