// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Direktori Mahasiswa';

  @override
  String get detailTitle => 'Detail Pengguna';

  @override
  String get email => 'Email';

  @override
  String get city => 'Kota';

  @override
  String get language => 'Bahasa';

  @override
  String get errorMessage => 'Gagal mengambil data';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get noData => 'Tidak ada data pengguna';

  @override
  String get usersTab => 'Pengguna';

  @override
  String get adminsTab => 'Admin';

  @override
  String get adminDetailTitle => 'Detail Admin';

  @override
  String get department => 'Departemen';

  @override
  String get name => 'Nama';

  @override
  String get idLabel => 'ID';

  @override
  String get noAdminData => 'Tidak ada data admin';

  @override
  String get deleteAdmin => 'Hapus Admin';

  @override
  String get deleteUser => 'Hapus Pengguna';

  @override
  String get confirmDeleteAdminTitle => 'Hapus Admin?';

  @override
  String confirmDeleteAdminMessage(int id) {
    return 'Apakah Anda yakin ingin menghapus admin dengan ID $id?';
  }

  @override
  String get confirmDeleteUserTitle => 'Hapus Pengguna?';

  @override
  String confirmDeleteUserMessage(int id) {
    return 'Apakah Anda yakin ingin menghapus pengguna dengan ID $id?';
  }

  @override
  String adminDeletedSuccess(int id) {
    return 'Admin dengan ID $id berhasil dihapus';
  }

  @override
  String adminDeletedFailed(int id) {
    return 'Admin dengan ID $id tidak ditemukan atau gagal dihapus';
  }

  @override
  String userDeletedSuccess(int id) {
    return 'Pengguna dengan ID $id berhasil dihapus';
  }

  @override
  String userDeletedFailed(int id) {
    return 'Pengguna dengan ID $id tidak ditemukan atau gagal dihapus';
  }

  @override
  String userCreatedSuccess(int id) {
    return 'Pengguna dengan ID $id berhasil ditambahkan';
  }

  @override
  String userUpdatedSuccess(int id) {
    return 'Pengguna dengan ID $id berhasil diperbarui';
  }

  @override
  String get userPatchedSuccess =>
      'Nama pengguna berhasil diperbarui dengan \'- Flutter Developer\'';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get close => 'Tutup';

  @override
  String get save => 'Simpan';

  @override
  String get reset => 'Reset';

  @override
  String get resetDataTitle => 'Reset Data JSON?';

  @override
  String get resetDataMessage =>
      'Apakah Anda yakin ingin mengembalikan data Pengguna dan Admin ke data awal?';

  @override
  String get resetDataSuccess =>
      'Data JSON Pengguna dan Admin berhasil di-reset ke data awal';

  @override
  String get jsonStorageTitle => 'Penyimpanan File JSON';

  @override
  String get jsonStorageInfo =>
      'Data tersimpan secara permanen di file JSON lokal:';

  @override
  String get jsonStorageDesc =>
      'Setiap operasi Tambah (POST), Ubah (PUT/PATCH), dan Hapus (DELETE) langsung memperbarui file JSON ini.';

  @override
  String get jsonStorageTooltip => 'Lokasi File JSON';

  @override
  String get resetDataTooltip => 'Reset Data JSON ke Awal';

  @override
  String get testApi => 'Uji API';

  @override
  String get apiTesterTitle => 'API Method Tester';

  @override
  String get nimBannerText =>
      'NIM: 20240801105  •  ID User: 1105  •  ID Admin: 2105';

  @override
  String quickGetUser(int id) {
    return 'GET User $id';
  }

  @override
  String quickPostUser(int id) {
    return 'POST User $id';
  }

  @override
  String quickGetAdmin(int id) {
    return 'GET Admin $id';
  }

  @override
  String quickDeleteAdmin(int id) {
    return 'HAPUS Admin $id';
  }

  @override
  String get putUpdateAction => 'PUT (Ubah Nama & Email)';

  @override
  String get patchFlutterDevAction => 'PATCH (+ Flutter Developer)';

  @override
  String get openApiTester => 'Buka di API Tester';

  @override
  String get addUserTitle => 'Tambah Pengguna Baru (POST)';

  @override
  String get editUserTitle => 'Perbarui Pengguna (PUT)';

  @override
  String get nameHint => 'Masukkan nama pengguna';

  @override
  String get emailHint => 'Masukkan email pengguna';

  @override
  String get cityHint => 'Masukkan kota';

  @override
  String get idHint => 'Contoh: 1105';

  @override
  String get requestConfiguration => 'Konfigurasi Request';

  @override
  String get selectMethodSubtitle =>
      'Pilih target resource, HTTP method, dan masukkan data yang ingin dikirim.';

  @override
  String get targetResource => 'Target Resource';

  @override
  String get httpMethod => 'HTTP Method';

  @override
  String get sendRequest => 'Kirim Request';

  @override
  String get sendingRequest => 'Mengirim Request...';

  @override
  String get responseResult => 'Hasil Response';

  @override
  String get appendFlutterDevLabel =>
      'Tambahkan \'- Flutter Developer\' pada nama';

  @override
  String get enterValidId => 'Masukkan ID angka yang valid';

  @override
  String get nameRequired => 'Nama tidak boleh kosong';

  @override
  String get emailRequired => 'Email tidak boleh kosong';

  @override
  String get methodInfoGetAll =>
      'GET (All): Mengambil seluruh data dari resource yang dipilih.';

  @override
  String get methodInfoGetById =>
      'GET (By ID): Mengambil satu data berdasarkan ID yang dimasukkan.';

  @override
  String get methodInfoPost =>
      'POST: Menambahkan data User baru dengan ID yang ditentukan (default: 1105).';

  @override
  String get methodInfoPut =>
      'PUT: Memperbarui nama dan email User secara menyeluruh.';

  @override
  String get methodInfoPatch =>
      'PATCH: Memperbarui sebagian data (nama) dengan menambahkan \'- Flutter Developer\'.';

  @override
  String get methodInfoDelete =>
      'DELETE: Menghapus data berdasarkan ID yang dimasukkan.';
}
