import 'package:flutter/material.dart';

import '../constants/nim_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import 'api_console_view.dart';

class AdminDetailScreen extends StatefulWidget {
  final int adminId;

  const AdminDetailScreen({super.key, required this.adminId});

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  static const Color _amber = Color(0xFFD97706);
  static const Color _orange = Color(0xFFEA580C);

  late Future<Admin> _futureAdmin;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _futureAdmin = AdminService.getAdmin(widget.adminId);
    });
  }

  Future<void> _deleteAdmin(Admin admin) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteAdminTitle),
        content: Text(l10n.confirmDeleteAdminMessage(admin.id)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (ok != true) return;
    setState(() => _busy = true);
    try {
      final deleted = await AdminService.deleteAdmin(admin.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            deleted
                ? l10n.adminDeletedSuccess(admin.id)
                : l10n.adminDeletedFailed(admin.id),
          ),
        ),
      );
      if (deleted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNim = widget.adminId == NimConstants.adminId;

    return Scaffold(
      body: FutureBuilder<Admin>(
        future: _futureAdmin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFDC2626),
                        size: 52,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.errorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.close),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: _reload,
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final admin = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // WARM AMBER GRADIENT HEADER
              SliverAppBar(
                expandedHeight: 215,
                pinned: true,
                backgroundColor: _amber,
                foregroundColor: Colors.white,
                title: Text(l10n.adminDetailTitle),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_amber, _orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.shield_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              admin.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${l10n.idLabel} #${admin.id}${isNim ? ' • NIM ${NimConstants.nim}' : ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    // INFO CARD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _amber.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.alternate_email_rounded,
                                color: _amber,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              l10n.email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            subtitle: Text(
                              admin.email,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 56),
                          ListTile(
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: _orange,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              l10n.department,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            subtitle: Text(
                              admin.department,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // OPEN API LAB
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApiConsoleScreen(
                                    initialEntity: ConsoleEntity.admin,
                                    initialId: admin.id,
                                    initialMethod: 'GET',
                                  ),
                                ),
                              ).then((_) {
                                if (mounted) _reload();
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _amber,
                        side: const BorderSide(color: Color(0xFFFDE68A)),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.terminal_rounded, size: 18),
                      label: Text(l10n.openApiLab),
                    ),
                    const SizedBox(height: 18),

                    // DANGER ZONE CARD
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.dangerZone,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB91C1C),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.dangerZoneAdminDesc,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _busy ? null : () => _deleteAdmin(admin),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              minimumSize: const Size.fromHeight(46),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.delete_forever_rounded),
                            label: Text('${l10n.deleteAdmin} (#${admin.id})'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
