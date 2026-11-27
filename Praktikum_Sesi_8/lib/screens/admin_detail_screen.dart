import 'package:flutter/material.dart';

import '../constants/nim_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import 'api_tester_screen.dart';

class AdminDetailScreen extends StatefulWidget {
  final int adminId;

  const AdminDetailScreen({
    super.key,
    required this.adminId,
  });

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  late Future<Admin> _futureAdmin;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  void _loadAdmin() {
    setState(() {
      _futureAdmin = AdminService.getAdmin(widget.adminId);
    });
  }

  Future<void> _confirmDelete(Admin admin) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteAdminTitle),
        content: Text(l10n.confirmDeleteAdminMessage(admin.id)),
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
      final success = await AdminService.deleteAdmin(admin.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.adminDeletedSuccess(admin.id)
                : l10n.adminDeletedFailed(admin.id),
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
    final isNimAdmin = widget.adminId == NimConstants.adminId;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.adminDetailTitle} (#${widget.adminId})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Admin>(
        future: _futureAdmin,
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
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 54),
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
                      onPressed: _loadAdmin,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final admin = snapshot.data!;
          final initialChar =
              admin.name.isNotEmpty ? admin.name[0].toUpperCase() : 'A';

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
                          backgroundColor: isNimAdmin
                              ? Colors.teal
                              : Colors.teal.shade100,
                          child: Text(
                            initialChar,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isNimAdmin ? Colors.white : Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Chip(
                          avatar: const Icon(Icons.admin_panel_settings,
                              size: 16),
                          label: Text(
                            '${l10n.idLabel}: ${admin.id}${isNimAdmin ? ' (NIM ${NimConstants.nim})' : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          admin.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 28),
                        _AdminInfoRow(
                          icon: Icons.email_outlined,
                          label: l10n.email,
                          value: admin.email,
                        ),
                        const SizedBox(height: 12),
                        _AdminInfoRow(
                          icon: Icons.business_outlined,
                          label: l10n.department,
                          value: admin.department,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // DELETE ADMIN BUTTON
                ElevatedButton.icon(
                  onPressed:
                      _isProcessing ? null : () => _confirmDelete(admin),
                  icon: const Icon(Icons.delete_outline),
                  label: Text('${l10n.deleteAdmin} (#${admin.id})'),
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
                                initialResource: ApiResource.admin,
                                initialId: admin.id,
                                initialMethod: 'GET',
                              ),
                            ),
                          ).then((_) {
                            if (mounted) _loadAdmin();
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

class _AdminInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AdminInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 22),
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
