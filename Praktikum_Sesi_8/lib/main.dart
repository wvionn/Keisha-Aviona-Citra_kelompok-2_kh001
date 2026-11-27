import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants/nim_constants.dart';
import 'l10n/app_localizations.dart';
import 'models/admin.dart';
import 'models/user_model.dart';
import 'screens/admin_detail_screen.dart';
import 'screens/api_tester_screen.dart';
import 'screens/user_detail_screen.dart';
import 'services/admin_service.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MAIN APP
// ==========================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Sesi 8 - NIM ${NimConstants.nim}',
      locale: locale,
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(
        onLanguageChanged: (value) {
          setState(() {
            locale = Locale(value);
          });
        },
      ),
    );
  }
}

// ==========================================
// HOME SCREEN - USER & ADMIN DIRECTORY
// ==========================================

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late Future<List<User>> _futureUsers;
  late Future<List<Admin>> _futureAdmins;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureUsers = ApiService.getUsers();
    _futureAdmins = AdminService.getAdmins();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Future<void> _showJsonStorageDialog() async {
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Users:', style: TextStyle(fontSize: 12)),
            SelectableText(
              userPath,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Admins:', style: TextStyle(fontSize: 12)),
            SelectableText(
              adminPath,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.jsonStorageDesc,
              style: const TextStyle(fontSize: 12),
            ),
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

  Future<void> _confirmResetData() async {
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.resetDataSuccess)),
        );
      }
    }
  }

  Future<void> _showPostUserDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final idController =
        TextEditingController(text: NimConstants.userId.toString());
    final nameController =
        TextEditingController(text: 'Mahasiswa ${NimConstants.nim}');
    final emailController =
        TextEditingController(text: 'user.${NimConstants.userId}@kampus.ac.id');
    final cityController = TextEditingController(text: 'Jakarta');

    final createdId = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addUserTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.usersTab} ${l10n.idLabel}',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: l10n.city,
                  hintText: l10n.cityHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final parsedId =
                  int.tryParse(idController.text.trim()) ?? NimConstants.userId;
              if (nameController.text.trim().isEmpty ||
                  emailController.text.trim().isEmpty) {
                return;
              }
              final created = await ApiService.createUser(
                nameController.text.trim(),
                emailController.text.trim(),
                id: parsedId,
                city: cityController.text.trim().isEmpty
                    ? 'Jakarta'
                    : cityController.text.trim(),
              );
              if (ctx.mounted) {
                Navigator.pop(ctx, created.id);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();

    if (createdId != null && mounted) {
      _refreshUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userCreatedSuccess(createdId))),
      );
    }
  }

  Future<void> _confirmDeleteAdmin(int adminId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteAdminTitle),
        content: Text(l10n.confirmDeleteAdminMessage(adminId)),
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

    final success = await AdminService.deleteAdmin(adminId);
    if (!mounted) return;
    _refreshAdmins();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? l10n.adminDeletedSuccess(adminId)
              : l10n.adminDeletedFailed(adminId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.jsonStorageTooltip,
            onPressed: _showJsonStorageDialog,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: l10n.resetDataTooltip,
            onPressed: _confirmResetData,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onSelected: widget.onLanguageChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'id',
                child: Text('Bahasa Indonesia'),
              ),
              PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.people),
              text: '${l10n.usersTab} (${NimConstants.userId})',
            ),
            Tab(
              icon: const Icon(Icons.admin_panel_settings),
              text: '${l10n.adminsTab} (${NimConstants.adminId})',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final isAdminTab = _tabController.index == 1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApiTesterScreen(
                initialResource:
                    isAdminTab ? ApiResource.admin : ApiResource.user,
                initialId:
                    isAdminTab ? NimConstants.adminId : NimConstants.userId,
              ),
            ),
          ).then((_) => _refreshAll());
        },
        icon: const Icon(Icons.api),
        label: Text(l10n.testApi),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(l10n),
          _buildAdminsTab(l10n),
        ],
      ),
    );
  }

  Widget _buildUsersTab(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
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
                  icon: const Icon(Icons.person_search, size: 18),
                  label: Text(l10n.quickGetUser(NimConstants.userId)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showPostUserDialog,
                  icon: const Icon(Icons.person_add, size: 18),
                  label: Text(l10n.quickPostUser(NimConstants.userId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<User>>(
            future: _futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 50),
                      const SizedBox(height: 12),
                      Text(l10n.errorMessage),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _refreshUsers,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              final users = snapshot.data ?? [];
              if (users.isEmpty) {
                return Center(child: Text(l10n.noData));
              }

              return RefreshIndicator(
                onRefresh: () async => _refreshUsers(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isNimUser = user.id == NimConstants.userId;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: isNimUser
                          ? Colors.blue.withValues(alpha: 0.08)
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isNimUser
                              ? Colors.blue
                              : Colors.blue.shade100,
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: isNimUser ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isNimUser
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${user.id}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isNimUser
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email),
                            if (user.city.isNotEmpty)
                              Text(
                                '${l10n.city}: ${user.city}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserDetailScreen(userId: user.id),
                            ),
                          ).then((_) => _refreshUsers());
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminsTab(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
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
              icon: const Icon(Icons.badge_outlined, size: 18),
              label: Text(l10n.quickGetAdmin(NimConstants.adminId)),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Admin>>(
            future: _futureAdmins,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 50),
                      const SizedBox(height: 12),
                      Text(l10n.errorMessage),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _refreshAdmins,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              final admins = snapshot.data ?? [];
              if (admins.isEmpty) {
                return Center(child: Text(l10n.noAdminData));
              }

              return RefreshIndicator(
                onRefresh: () async => _refreshAdmins(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  itemCount: admins.length,
                  itemBuilder: (context, index) {
                    final admin = admins[index];
                    final isNimAdmin = admin.id == NimConstants.adminId;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: isNimAdmin
                          ? Colors.teal.withValues(alpha: 0.08)
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isNimAdmin
                              ? Colors.teal
                              : Colors.teal.shade100,
                          child: Text(
                            admin.name.isNotEmpty
                                ? admin.name[0].toUpperCase()
                                : 'A',
                            style: TextStyle(
                              color: isNimAdmin ? Colors.white : Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                admin.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isNimAdmin
                                    ? Colors.teal
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${admin.id}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isNimAdmin
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(admin.email),
                            Text(
                              '${l10n.department}: ${admin.department}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
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
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
