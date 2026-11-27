import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants/nim_constants.dart';
import '../models/admin.dart';
import 'api_service.dart';

class AdminService {
  static const String baseUrl = ApiService.baseUrl;
  static const String adminsEndpoint = '$baseUrl/users';
  static const String fileName = 'admins_2104.json';
  static const int nimAdminId = NimConstants.adminId; // 2104

  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<String> getJsonFilePath() async {
    final file = await getLocalFile();
    return file.path;
  }

  static int _parseId(dynamic rawId) {
    if (rawId is int) return rawId;
    return int.tryParse(rawId.toString()) ?? 0;
  }

  static Future<File> _ensureFileInitialized() async {
    final file = await getLocalFile();

    if (!await file.exists()) {
      final List<Map<String, dynamic>> initialAdmins = [
        Map<String, dynamic>.from(_defaultNimAdmin),
      ];

      try {
        final response = await http
            .get(Uri.parse(adminsEndpoint))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final List<dynamic> remoteUsers = jsonDecode(response.body) as List;
          final departments = [
            'IT Infrastructure',
            'Sistem Informasi',
            'Keamanan Siber',
            'Akademik & Kurikulum',
            'Operasional & Keuangan',
          ];

          for (int i = 0; i < remoteUsers.length && i < 5; i++) {
            final item = Map<String, dynamic>.from(remoteUsers[i] as Map);
            final company = item['company'];
            final deptName = (company is Map && company['name'] != null)
                ? company['name'].toString()
                : departments[i % departments.length];

            initialAdmins.add({
              'id': 2001 + i,
              'name': item['name']?.toString() ?? 'Admin ${2001 + i}',
              'email':
                  item['email']?.toString() ?? 'admin${2001 + i}@kampus.ac.id',
              'department': deptName,
            });
          }
        }
      } catch (_) {}

      if (initialAdmins.length == 1) {
        initialAdmins.addAll(
          _defaultAdmins.map((e) => Map<String, dynamic>.from(e)),
        );
      }

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(initialAdmins),
      );
    }

    return file;
  }

  static Future<List<dynamic>> _readJsonFile() async {
    final file = await _ensureFileInitialized();
    final contents = await file.readAsString();
    return List<dynamic>.from(jsonDecode(contents) as List);
  }

  static Future<void> _writeJsonFile(List<dynamic> admins) async {
    final file = await getLocalFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(admins),
    );
  }

  // GET: Mengambil seluruh data Admin
  static Future<List<Admin>> getAdmins() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final rawList = await _readJsonFile();
    return rawList
        .map((item) => Admin.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // GET: Mengambil satu data Admin berdasarkan ID (uji ID 2104)
  static Future<Admin> getAdmin(int id) async {
    try {
      await http
          .get(Uri.parse('$adminsEndpoint/$id'))
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {}

    final admins = await _readJsonFile();
    for (final element in admins) {
      final map = Map<String, dynamic>.from(element as Map);
      if (_parseId(map['id']) == id) {
        return Admin.fromJson(map);
      }
    }

    throw Exception('Data admin dengan ID $id tidak ditemukan');
  }

  // DELETE: Menghapus data Admin berdasarkan ID (uji ID 2104)
  static Future<bool> deleteAdmin(int id) async {
    try {
      await http
          .delete(Uri.parse('$adminsEndpoint/$id'))
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {}

    final admins = await _readJsonFile();
    final index = admins.indexWhere(
      (element) => _parseId((element as Map)['id']) == id,
    );

    if (index == -1) {
      return false;
    }

    admins.removeAt(index);
    await _writeJsonFile(admins);

    return true;
  }

  static Future<void> resetToDefault() async {
    final file = await getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }
    await _ensureFileInitialized();
  }

  static final Map<String, dynamic> _defaultNimAdmin = {
    'id': NimConstants.adminId,
    'name': 'Admin NIM ${NimConstants.nim}',
    'email': 'admin.${NimConstants.adminId}@kampus.ac.id',
    'department': 'Teknik Informatika',
  };

  static final List<Map<String, dynamic>> _defaultAdmins = [
    {
      'id': 2001,
      'name': 'Dr. Hendra Wijaya',
      'email': 'hendra.wijaya@kampus.ac.id',
      'department': 'IT Infrastructure',
    },
    {
      'id': 2002,
      'name': 'Siti Rahmawati',
      'email': 'siti.rahmawati@kampus.ac.id',
      'department': 'Sistem Informasi',
    },
    {
      'id': 2003,
      'name': 'Budi Pratama',
      'email': 'budi.pratama@kampus.ac.id',
      'department': 'Keamanan Siber',
    },
    {
      'id': 2004,
      'name': 'Dewi Lestari',
      'email': 'dewi.lestari@kampus.ac.id',
      'department': 'Akademik & Kurikulum',
    },
    {
      'id': 2005,
      'name': 'Rizky Saputra',
      'email': 'rizky.saputra@kampus.ac.id',
      'department': 'Operasional & Keuangan',
    },
  ];
}
