import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants/nim_constants.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String usersEndpoint = '$baseUrl/users';
  static const String fileName = 'users.json';
  static const int nimUserId = NimConstants.userId; // 1105
  static const String flutterDeveloperSuffix =
      NimConstants.flutterDeveloperSuffix;

  // Mendapatkan path file users.json di internal storage perangkat
  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // Mendapatkan path lengkap file JSON dalam bentuk String
  static Future<String> getJsonFilePath() async {
    final file = await getLocalFile();
    return file.path;
  }

  // Inisialisasi file users.json jika belum ada
  static Future<File> _ensureFileInitialized() async {
    final file = await getLocalFile();

    if (!await file.exists()) {
      List<dynamic> initialData = [];
      try {
        final response = await http
            .get(Uri.parse(usersEndpoint))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          initialData = List<dynamic>.from(jsonDecode(response.body) as List);
        }
      } catch (_) {
        // Fallback default data jika offline
        initialData = List<dynamic>.from(_defaultUsers);
      }

      if (initialData.isEmpty) {
        initialData = List<dynamic>.from(_defaultUsers);
      }

      // Pastikan User awal sesuai konstanta NIM (ID 1105) tersedia pada inisialisasi
      final hasNimUser = initialData.any(
        (u) => _parseId(u['id']) == nimUserId,
      );
      if (!hasNimUser) {
        initialData.insert(0, Map<String, dynamic>.from(_defaultNimUser));
      }

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(initialData),
      );
    }

    return file;
  }

  static int _parseId(dynamic rawId) {
    if (rawId is int) return rawId;
    return int.tryParse(rawId.toString()) ?? 0;
  }

  // Membaca semua data dari file users.json lokal
  static Future<List<dynamic>> _readJsonFile() async {
    final file = await _ensureFileInitialized();
    final contents = await file.readAsString();
    return List<dynamic>.from(jsonDecode(contents) as List);
  }

  // Menyimpan seluruh list data kembali ke file users.json lokal
  static Future<void> _writeJsonFile(List<dynamic> users) async {
    final file = await getLocalFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(users),
    );
  }

  // GET: Mengambil semua pengguna dari file JSON lokal sebagai List<User>
  static Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final rawList = await _readJsonFile();
    return rawList
        .map((item) => User.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // GET: Mengambil detail pengguna berdasarkan ID (termasuk ID 1105)
  static Future<User> getUser(int id) async {
    try {
      await http
          .get(Uri.parse('$usersEndpoint/$id'))
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // Tetap gunakan penyimpanan lokal jika offline atau mock tidak menyimpan ID 1105
    }

    final users = await _readJsonFile();
    for (final element in users) {
      final map = Map<String, dynamic>.from(element as Map);
      if (_parseId(map['id']) == id) {
        return User.fromJson(map);
      }
    }

    throw Exception('Data pengguna dengan ID $id tidak ditemukan');
  }

  // POST: Menambahkan pengguna baru dengan ID default 1105 dan menyimpan ke file JSON lokal
  static Future<User> createUser(
    String name,
    String email, {
    int id = nimUserId,
    String city = 'Jakarta',
  }) async {
    final newUserMap = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': {
        'city': city,
      },
      'city': city,
    };

    try {
      await http
          .post(
            Uri.parse(usersEndpoint),
            headers: const {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(newUserMap),
          )
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // Fallback ke penyimpanan JSON lokal saat offline
    }

    final users = await _readJsonFile();
    final existingIndex = users.indexWhere(
      (element) => _parseId((element as Map)['id']) == id,
    );

    if (existingIndex != -1) {
      users.removeAt(existingIndex);
    }

    users.insert(0, newUserMap);
    await _writeJsonFile(users);

    return User.fromJson(newUserMap);
  }

  // PUT: Memperbarui name dan email pengguna (termasuk ID 1105)
  static Future<User> updateUser(
    int id,
    String name,
    String email, {
    String? city,
  }) async {
    final users = await _readJsonFile();
    final index = users.indexWhere(
      (element) => _parseId((element as Map)['id']) == id,
    );

    if (index == -1) {
      throw Exception('Gagal memperbarui pengguna: ID $id tidak ditemukan');
    }

    final existing = Map<String, dynamic>.from(users[index] as Map);
    existing['name'] = name;
    existing['email'] = email;
    if (city != null && city.trim().isNotEmpty) {
      existing['city'] = city.trim();
      existing['address'] = {'city': city.trim()};
    }

    try {
      await http
          .put(
            Uri.parse('$usersEndpoint/$id'),
            headers: const {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(existing),
          )
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // Fallback ke penyimpanan JSON lokal saat offline
    }

    users[index] = existing;
    await _writeJsonFile(users);

    return User.fromJson(existing);
  }

  // PATCH: Memperbarui name pengguna dengan menambahkan teks '- Flutter Developer'
  static Future<User> patchUser(
    int id, {
    String? name,
    bool appendFlutterDeveloper = true,
  }) async {
    final users = await _readJsonFile();
    final index = users.indexWhere(
      (element) => _parseId((element as Map)['id']) == id,
    );

    if (index == -1) {
      throw Exception('Gagal mengubah nama pengguna: ID $id tidak ditemukan');
    }

    final existing = Map<String, dynamic>.from(users[index] as Map);
    final currentName = existing['name']?.toString() ?? '';
    String updatedName =
        (name != null && name.trim().isNotEmpty) ? name.trim() : currentName;

    if (appendFlutterDeveloper &&
        !updatedName.endsWith('- Flutter Developer')) {
      updatedName = '$updatedName$flutterDeveloperSuffix';
    }

    existing['name'] = updatedName;

    try {
      await http
          .patch(
            Uri.parse('$usersEndpoint/$id'),
            headers: const {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({'name': updatedName}),
          )
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // Fallback ke penyimpanan JSON lokal saat offline
    }

    users[index] = existing;
    await _writeJsonFile(users);

    return User.fromJson(existing);
  }

  // DELETE: Menghapus pengguna berdasarkan ID (termasuk ID 1105)
  static Future<bool> deleteUser(int id) async {
    try {
      await http
          .delete(Uri.parse('$usersEndpoint/$id'))
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // Fallback ke penyimpanan JSON lokal saat offline
    }

    final users = await _readJsonFile();
    final index = users.indexWhere(
      (element) => _parseId((element as Map)['id']) == id,
    );

    if (index == -1) {
      return false;
    }

    users.removeAt(index);
    await _writeJsonFile(users);

    return true;
  }

  // Reset data file users.json kembali ke data awal
  static Future<void> resetToDefault() async {
    final file = await getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }
    await _ensureFileInitialized();
  }

  static final Map<String, dynamic> _defaultNimUser = {
    'id': NimConstants.userId,
    'name': 'Mahasiswa ${NimConstants.nim}',
    'email': 'mahasiswa.${NimConstants.nim}@kampus.ac.id',
    'address': {'city': 'Jakarta'},
    'city': 'Jakarta',
  };

  // Default data fallback jika tidak ada koneksi internet saat inisialisasi awal
  static final List<Map<String, dynamic>> _defaultUsers = [
    {
      'id': 1,
      'name': 'Leanne Graham',
      'email': 'Sincere@april.biz',
      'address': {'city': 'Gwenborough'},
    },
    {
      'id': 2,
      'name': 'Ervin Howell',
      'email': 'Shanna@melissa.tv',
      'address': {'city': 'Wisokyburgh'},
    },
    {
      'id': 3,
      'name': 'Clementine Bauch',
      'email': 'Nathan@yesenia.net',
      'address': {'city': 'McKenziehaven'},
    },
    {
      'id': 4,
      'name': 'Patricia Lebsack',
      'email': 'Julianne.OConner@kory.org',
      'address': {'city': 'South Elvis'},
    },
    {
      'id': 5,
      'name': 'Chelsey Dietrich',
      'email': 'Lucio_Hettinger@annie.ca',
      'address': {'city': 'Roscoeview'},
    },
    {
      'id': 6,
      'name': 'Mrs. Dennis Schulist',
      'email': 'Karley_Dach@jasper.info',
      'address': {'city': 'South Christy'},
    },
    {
      'id': 7,
      'name': 'Kurtis Weissnat',
      'email': 'Telly.Hoeger@billy.biz',
      'address': {'city': 'Howemouth'},
    },
    {
      'id': 8,
      'name': 'Nicholas Runolfsdottir V',
      'email': 'Sherwood@rosamond.me',
      'address': {'city': 'Aliyaview'},
    },
    {
      'id': 9,
      'name': 'Glenna Reichert',
      'email': 'Chaim_McDermott@dana.io',
      'address': {'city': 'Bartholomebury'},
    },
    {
      'id': 10,
      'name': 'Clementina DuBuque',
      'email': 'Rey.Padberg@karina.biz',
      'address': {'city': 'Lebsackbury'},
    },
  ];
}
