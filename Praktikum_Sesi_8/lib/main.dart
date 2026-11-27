import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants/nim_constants.dart';
import 'l10n/app_localizations.dart';
import 'models/admin.dart';
import 'models/user_model.dart';
import 'screens/admin_detail_screen.dart';
import 'screens/api_console_view.dart';
import 'screens/user_detail_screen.dart';
import 'services/admin_service.dart';
import 'services/api_service.dart';

void main() {
  runApp(const CampusPortalApp());
}

class CampusPortalApp extends StatefulWidget {
  const CampusPortalApp({super.key});

  @override
  State<CampusPortalApp> createState() => _CampusPortalAppState();
}

class _CampusPortalAppState extends State<CampusPortalApp> {
  Locale _locale = const Locale('id');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'id'
          ? const Locale('en')
          : const Locale('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Portal - ${NimConstants.nim}',
      locale: _locale,
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
      ),
      home: PortalHomeScreen(
        currentLanguageCode: _locale.languageCode,
        onToggleLanguage: _toggleLocale,
      ),
    );
  }
}

class PortalHomeScreen extends StatefulWidget {
  final String currentLanguageCode;
  final VoidCallback onToggleLanguage;

  const PortalHomeScreen({
    super.key,
    required this.currentLanguageCode,
    required this.onToggleLanguage,
  });

  @override
  State<PortalHomeScreen> createState() => _PortalHomeScreenState();
}

class _PortalHomeScreenState extends State<PortalHomeScreen> {
  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _amber = Color(0xFFD97706);

  int _navIndex = 0;
  late Future<List<User>> _futureUsers;
  late Future<List<Admin>> _futureAdmins;

  final _userSearchCtrl = TextEditingController();
  final _adminSearchCtrl = TextEditingController();
  String _userQuery = '';
  String _adminQuery = '';

  @override
  void initState() {
    super.initState();
    _futureUsers = ApiService.getUsers();
    _futureAdmins = AdminService.getAdmins();
  }

  @override
  void dispose() {
    _userSearchCtrl.dispose();
    _adminSearchCtrl.dispose();
    super.dispose();
  }

  void _refreshUsers() {
    setState(() {
      _futureUsers = ApiService.getUsers();
    });
  }

  void _refreshAdmins() {
    setState(() {
      _futureAdmins = AdminService.getAdmins();
    });
  }

  void _refreshAll() {
    setState(() {
      _futureUsers = ApiService.getUsers();
      _futureAdmins = AdminService.getAdmins();
    });
  }

  Future<void> _showStorageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final userPath = await ApiService.getJsonFilePath();
    final adminPath = await AdminService.getJsonFilePath();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.jsonStorageTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.jsonStorageInfo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('Users JSON:', style: TextStyle(fontSize: 12)),
            SelectableText(
              userPath,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: _indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Admins JSON:', style: TextStyle(fontSize: 12)),
            SelectableText(
              adminPath,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: _amber,
              ),
            ),
            const SizedBox(height: 10),
            Text(l10n.jsonStorageDesc, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetDataTitle),
        content: Text(l10n.resetDataMessage),
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
            child: Text(l10n.reset),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.resetToDefault();
      await AdminService.resetToDefault();
      _refreshAll();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.resetDataSuccess)));
      }
    }
  }

  Future<void> _openCreateUserSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final idCtrl = TextEditingController(text: NimConstants.userId.toString());
    final nameCtrl = TextEditingController(
      text: 'Mahasiswa ${NimConstants.nim}',
    );
    final emailCtrl = TextEditingController(
      text: 'user.${NimConstants.userId}@kampus.ac.id',
    );
    final cityCtrl = TextEditingController(text: 'Jakarta');

    final createdId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.addUserTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: idCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.usersTab} ${l10n.idLabel}',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  hintText: l10n.nameHint,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  hintText: l10n.emailHint,
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityCtrl,
                decoration: InputDecoration(
                  labelText: l10n.city,
                  hintText: l10n.cityHint,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _indigo,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final parsedId =
                      int.tryParse(idCtrl.text.trim()) ?? NimConstants.userId;
                  if (nameCtrl.text.trim().isEmpty ||
                      emailCtrl.text.trim().isEmpty) {
                    return;
                  }
                  final created = await ApiService.createUser(
                    nameCtrl.text.trim(),
                    emailCtrl.text.trim(),
                    id: parsedId,
                    city: cityCtrl.text.trim().isEmpty
                        ? 'Jakarta'
                        : cityCtrl.text.trim(),
                  );
                  if (ctx.mounted) Navigator.pop(ctx, created.id);
                },
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );

    idCtrl.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    cityCtrl.dispose();

    if (createdId != null && mounted) {
      _refreshUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userCreatedSuccess(createdId))),
      );
    }
  }

  Future<void> _confirmDeleteAdmin(int adminId) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteAdminTitle),
        content: Text(l10n.confirmDeleteAdminMessage(adminId)),
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
    final deleted = await AdminService.deleteAdmin(adminId);
    if (!mounted) return;
    _refreshAdmins();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? l10n.adminDeletedSuccess(adminId)
              : l10n.adminDeletedFailed(adminId),
        ),
      ),
    );
  }

  String _pageTitle(AppLocalizations l10n) {
    switch (_navIndex) {
      case 0:
        return l10n.appTitle;
      case 1:
        return '${l10n.adminsTab} • ${l10n.appTitle}';
      default:
        return l10n.apiConsoleTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle(l10n),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
        actions: [
          // ONE-TAP LANGUAGE TOGGLE PILL
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ActionChip(
              avatar: const Icon(Icons.translate_rounded, size: 16),
              label: Text(
                widget.currentLanguageCode.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              backgroundColor: const Color(0xFFF1F5F9),
              onPressed: widget.onToggleLanguage,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) {
              if (action == 'storage') {
                _showStorageDialog();
              } else if (action == 'reset') {
                _confirmReset();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'storage',
                child: Row(
                  children: [
                    const Icon(Icons.folder_outlined, size: 18),
                    const SizedBox(width: 10),
                    Text(l10n.jsonStorageMenu),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    const Icon(
                      Icons.restart_alt_rounded,
                      size: 18,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.resetDataMenu,
                      style: const TextStyle(color: Color(0xFFDC2626)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _navIndex == 0
          ? FloatingActionButton(
              onPressed: _openCreateUserSheet,
              backgroundColor: _indigo,
              foregroundColor: Colors.white,
              tooltip: l10n.addNewUser,
              child: const Icon(Icons.person_add_alt_1_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        backgroundColor: Colors.white,
        indicatorColor: _navIndex == 1
            ? _amber.withValues(alpha: 0.18)
            : _indigo.withValues(alpha: 0.14),
        onDestinationSelected: (idx) {
          setState(() => _navIndex = idx);
          if (idx == 0) _refreshUsers();
          if (idx == 1) _refreshAdmins();
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group_rounded, color: _indigo),
            label: l10n.usersTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: const Icon(Icons.shield_rounded, color: _amber),
            label: l10n.adminsTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.terminal_outlined),
            selectedIcon: const Icon(Icons.terminal_rounded, color: _indigo),
            label: l10n.apiLabTab,
          ),
        ],
      ),
      body: IndexedStack(
        index: _navIndex,
        children: [
          _buildUsersView(l10n),
          _buildAdminsView(l10n),
          ApiConsoleView(
            initialEntity: ConsoleEntity.user,
            initialId: NimConstants.userId,
            onDataChanged: _refreshAll,
          ),
        ],
      ),
    );
  }

  Widget _buildUsersView(AppLocalizations l10n) {
    return FutureBuilder<List<User>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorState(
            message: l10n.errorMessage,
            retryLabel: l10n.retry,
            onRetry: _refreshUsers,
          );
        }

        final allUsers = snapshot.data ?? [];
        final q = _userQuery.toLowerCase();
        final filtered = q.isEmpty
            ? allUsers
            : allUsers.where((u) {
                return u.name.toLowerCase().contains(q) ||
                    u.email.toLowerCase().contains(q) ||
                    u.id.toString().contains(q);
              }).toList();

        return Column(
          children: [
            // SEARCH BAR + QUICK INSPECT HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  TextField(
                    controller: _userSearchCtrl,
                    onChanged: (v) => setState(() => _userQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: l10n.searchUsersHint,
                      hintStyle: const TextStyle(fontSize: 13.5),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _userQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _userSearchCtrl.clear();
                                setState(() => _userQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _indigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.totalRecords(filtered.length),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _indigo,
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _indigo.withValues(alpha: 0.12),
                          foregroundColor: _indigo,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserDetailScreen(
                                userId: NimConstants.userId,
                              ),
                            ),
                          ).then((_) => _refreshUsers());
                        },
                        icon: const Icon(Icons.manage_search_rounded, size: 17),
                        label: Text(l10n.inspectId(NimConstants.userId)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(l10n.noData))
                  : RefreshIndicator(
                      onRefresh: () async => _refreshUsers(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final user = filtered[idx];
                          final isNim = user.id == NimConstants.userId;

                          return _AccentRecordCard(
                            id: user.id,
                            title: user.name,
                            subtitle: user.email,
                            tagIcon: Icons.location_on_outlined,
                            tagText: user.city.isEmpty ? '-' : user.city,
                            accentColor: _indigo,
                            highlighted: isNim,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserDetailScreen(userId: user.id),
                                ),
                              ).then((_) => _refreshUsers());
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdminsView(AppLocalizations l10n) {
    return FutureBuilder<List<Admin>>(
      future: _futureAdmins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorState(
            message: l10n.errorMessage,
            retryLabel: l10n.retry,
            onRetry: _refreshAdmins,
          );
        }

        final allAdmins = snapshot.data ?? [];
        final q = _adminQuery.toLowerCase();
        final filtered = q.isEmpty
            ? allAdmins
            : allAdmins.where((a) {
                return a.name.toLowerCase().contains(q) ||
                    a.department.toLowerCase().contains(q) ||
                    a.id.toString().contains(q);
              }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  TextField(
                    controller: _adminSearchCtrl,
                    onChanged: (v) => setState(() => _adminQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: l10n.searchAdminsHint,
                      hintStyle: const TextStyle(fontSize: 13.5),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _adminQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _adminSearchCtrl.clear();
                                setState(() => _adminQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _amber.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.totalRecords(filtered.length),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _amber,
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _amber.withValues(alpha: 0.14),
                          foregroundColor: _amber,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDetailScreen(
                                adminId: NimConstants.adminId,
                              ),
                            ),
                          ).then((_) => _refreshAdmins());
                        },
                        icon: const Icon(
                          Icons.verified_user_outlined,
                          size: 17,
                        ),
                        label: Text(l10n.inspectId(NimConstants.adminId)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(l10n.noAdminData))
                  : RefreshIndicator(
                      onRefresh: () async => _refreshAdmins(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final admin = filtered[idx];
                          final isNim = admin.id == NimConstants.adminId;

                          return _AccentRecordCard(
                            id: admin.id,
                            title: admin.name,
                            subtitle: admin.email,
                            tagIcon: Icons.apartment_rounded,
                            tagText: admin.department,
                            accentColor: _amber,
                            highlighted: isNim,
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFDC2626),
                              ),
                              tooltip: l10n.deleteAdmin,
                              onPressed: () => _confirmDeleteAdmin(admin.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AdminDetailScreen(adminId: admin.id),
                                ),
                              ).then((_) => _refreshAdmins());
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _AccentRecordCard extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final IconData tagIcon;
  final String tagText;
  final Color accentColor;
  final bool highlighted;
  final Widget? trailing;
  final VoidCallback onTap;

  const _AccentRecordCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tagIcon,
    required this.tagText,
    required this.accentColor,
    required this.highlighted,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? accentColor.withValues(alpha: 0.06) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted
                  ? accentColor.withValues(alpha: 0.45)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // LEFT VERTICAL ACCENT BAR
                  Container(
                    width: 5,
                    color: highlighted ? accentColor : const Color(0xFFE2E8F0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // ROUNDED-SQUARE ID BADGE
                          Container(
                            width: 50,
                            height: 46,
                            decoration: BoxDecoration(
                              color: highlighted
                                  ? accentColor
                                  : accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '#$id',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: highlighted ? Colors.white : accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(tagIcon, size: 13, color: accentColor),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        tagText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing ??
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Color(0xFF94A3B8),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFDC2626),
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(message),
          const SizedBox(height: 10),
          FilledButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
