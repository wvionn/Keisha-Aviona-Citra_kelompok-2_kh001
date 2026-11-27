import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum_sesi_8/constants/nim_constants.dart';
import 'package:praktikum_sesi_8/models/admin.dart';
import 'package:praktikum_sesi_8/models/user_model.dart';

void main() {
  test('Konstanta NIM sesuai dengan 20240801105', () {
    expect(NimConstants.nim, '20240801105');
    expect(NimConstants.lastThreeDigits, 105);
    expect(NimConstants.userId, 1105);
    expect(NimConstants.adminId, 2105);
  });

  test('User.fromJson memetakan properti id, name, email, city', () {
    final user = User.fromJson({
      'id': 1105,
      'name': 'Mahasiswa 20240801105',
      'email': 'mahasiswa.20240801105@kampus.ac.id',
      'address': {'city': 'Jakarta'},
    });

    expect(user.id, 1105);
    expect(user.name, 'Mahasiswa 20240801105');
    expect(user.email, 'mahasiswa.20240801105@kampus.ac.id');
    expect(user.city, 'Jakarta');
  });

  test('Admin.fromJson memetakan properti id, name, email, department', () {
    final admin = Admin.fromJson({
      'id': 2105,
      'name': 'Admin NIM 20240801105',
      'email': 'admin.2105@kampus.ac.id',
      'department': 'Teknik Informatika',
    });

    expect(admin.id, 2105);
    expect(admin.name, 'Admin NIM 20240801105');
    expect(admin.email, 'admin.2105@kampus.ac.id');
    expect(admin.department, 'Teknik Informatika');
  });
}
