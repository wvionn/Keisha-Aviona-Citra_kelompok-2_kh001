import 'package:flutter/material.dart';

import '../constants/nim_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'api_tester_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<User> _futureUser;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      _futureUser = ApiService.getUser(widget.userId);
    });
  }

  Future<void> _showPutDialog(User user) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${l10n.editUserTitle} (#${user.id})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                hintText: l10n.nameHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.email,
                hintText: l10n.emailHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  emailController.text.trim().isEmpty) {
                return;
              }
              await ApiService.updateUser(
                user.id,
                nameController.text.trim(),
                emailController.text.trim(),
              );
              if (ctx.mounted) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    nameController.dispose();
    emailController.dispose();

    if (updated == true && mounted) {
      _loadUser();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.userUpdatedSuccess(user.id))));
    }
  }

  Future<void> _patchFlutterDeveloper(User user) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isProcessing = true);
    try {
      await ApiService.patchUser(user.id, appendFlutterDeveloper: true);
      if (!mounted) return;
      _loadUser();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.userPatchedSuccess)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _confirmDelete(User user) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteUserTitle),
        content: Text(l10n.confirmDeleteUserMessage(user.id)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final success = await ApiService.deleteUser(user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.userDeletedSuccess(user.id)
                : l10n.userDeletedFailed(user.id),
          ),
        ),
      );
      if (success) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNimUser = widget.userId == NimConstants.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.detailTitle} (#${widget.userId})'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 54,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.errorMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadUser,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = snapshot.data!;
          final initialChar = user.name.isNotEmpty
              ? user.name[0].toUpperCase()
              : 'U';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: isNimUser
                              ? Colors.blue
                              : Colors.blue.shade100,
                          child: Text(
                            initialChar,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isNimUser ? Colors.white : Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Chip(
                          avatar: const Icon(Icons.tag, size: 16),
                          label: Text(
                            '${l10n.idLabel}: ${user.id}${isNimUser ? ' (NIM ${NimConstants.nim})' : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 28),
                        _DetailRow(
                          icon: Icons.email_outlined,
                          label: l10n.email,
                          value: user.email,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.location_city_outlined,
                          label: l10n.city,
                          value: user.city.isEmpty ? '-' : user.city,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // PUT BUTTON
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _showPutDialog(user),
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.putUpdateAction),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // PATCH BUTTON (- Flutter Developer)
                ElevatedButton.icon(
                  onPressed: _isProcessing
                      ? null
                      : () => _patchFlutterDeveloper(user),
                  icon: const Icon(Icons.code),
                  label: Text(l10n.patchFlutterDevAction),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // DELETE BUTTON
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _confirmDelete(user),
                  icon: const Icon(Icons.delete_outline),
                  label: Text('${l10n.deleteUser} (#${user.id})'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // OPEN IN API TESTER
                OutlinedButton.icon(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApiTesterScreen(
                                initialResource: ApiResource.user,
                                initialId: user.id,
                                initialMethod: 'GET',
                              ),
                            ),
                          ).then((_) {
                            if (mounted) _loadUser();
                          });
                        },
                  icon: const Icon(Icons.api),
                  label: Text(l10n.openApiTester),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
