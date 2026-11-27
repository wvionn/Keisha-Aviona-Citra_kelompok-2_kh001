// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Portal Kampus';

  @override
  String get detailTitle => 'Profil Pengguna';

  @override
  String get email => 'Email';

  @override
  String get city => 'Kota';

  @override
  String get language => 'Bahasa';

  @override
  String get errorMessage => 'Gagal memuat data';

  @override
  String get retry => 'Muat Ulang';

  @override
  String get noData => 'Belum ada data pengguna';

  @override
  String get usersTab => 'Pengguna';

  @override
  String get adminsTab => 'Admin';

  @override
  String get apiLabTab => 'API Lab';

  @override
  String get adminDetailTitle => 'Profil Admin';

  @override
  String get department => 'Departemen';

  @override
  String get name => 'Nama Lengkap';

  @override
  String get idLabel => 'ID';

  @override
  String get noAdminData => 'Belum ada data admin';

  @override
  String get deleteAdmin => 'Hapus Admin';

  @override
  String get deleteUser => 'Hapus Pengguna';

  @override
  String get confirmDeleteAdminTitle => 'Hapus Admin?';

  @override
  String confirmDeleteAdminMessage(int id) {
    return 'Apakah Anda yakin ingin menghapus permanen admin #$id?';
  }

  @override
  String get confirmDeleteUserTitle => 'Hapus Pengguna?';

  @override
  String confirmDeleteUserMessage(int id) {
    return 'Apakah Anda yakin ingin menghapus permanen pengguna #$id?';
  }

  @override
  String adminDeletedSuccess(int id) {
    return 'Admin #$id berhasil dihapus';
  }

  @override
  String adminDeletedFailed(int id) {
    return 'Admin #$id tidak ditemukan';
  }

  @override
  String userDeletedSuccess(int id) {
    return 'Pengguna #$id berhasil dihapus';
  }

  @override
  String userDeletedFailed(int id) {
    return 'Pengguna #$id tidak ditemukan';
  }

  @override
  String userCreatedSuccess(int id) {
    return 'Pengguna #$id berhasil ditambahkan';
  }

  @override
  String userUpdatedSuccess(int id) {
    return 'Pengguna #$id berhasil diperbarui';
  }

  @override
  String get userPatchedSuccess =>
      'Nama pengguna diperbarui dengan \'- Flutter Developer\'';

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
  String get resetDataTitle => 'Reset Data Lokal?';

  @override
  String get resetDataMessage =>
      'Kembalikan seluruh data Pengguna (1104) dan Admin (2104) ke data awal?';

  @override
  String get resetDataSuccess => 'Data JSON lokal berhasil di-reset';

  @override
  String get jsonStorageTitle => 'Penyimpanan JSON Lokal';

  @override
  String get jsonStorageInfo =>
      'Data disimpan permanen pada file JSON berikut:';

  @override
  String get jsonStorageDesc =>
      'Seluruh aksi POST, PUT, PATCH, dan DELETE langsung tersimpan ke penyimpanan lokal.';

  @override
  String get jsonStorageMenu => 'Info Penyimpanan';

  @override
  String get resetDataMenu => 'Reset Data';

  @override
  String get searchUsersHint =>
      'Cari pengguna berdasarkan nama, email, atau ID...';

  @override
  String get searchAdminsHint =>
      'Cari admin berdasarkan nama, departemen, atau ID...';

  @override
  String totalRecords(int count) {
    return '$count data';
  }

  @override
  String inspectId(int id) {
    return 'Lihat #$id';
  }

  @override
  String get addNewUser => 'Tambah User';

  @override
  String get addUserTitle => 'Tambah Pengguna (POST)';

  @override
  String get editUserTitle => 'Ubah Pengguna (PUT)';

  @override
  String get putActionShort => 'PUT Ubah';

  @override
  String get patchActionShort => 'PATCH +Dev';

  @override
  String get dangerZone => 'Zona Hapus';

  @override
  String get dangerZoneAdminDesc =>
      'Menghapus admin ini akan langsung menghapusnya dari file JSON lokal.';

  @override
  String get openApiLab => 'Uji di API Lab';

  @override
  String get nameHint => 'Masukkan nama lengkap';

  @override
  String get emailHint => 'Masukkan alamat email';

  @override
  String get cityHint => 'Masukkan nama kota';

  @override
  String get idHint => 'Contoh: 1104';

  @override
  String get apiConsoleTitle => 'Konsol REST API';

  @override
  String get apiConsoleSubtitle =>
      'Pilih entitas & metode HTTP, lalu jalankan request.';

  @override
  String get entityLabel => 'Entitas';

  @override
  String get methodLabel => 'Metode HTTP';

  @override
  String get executeRequest => 'Jalankan Request';

  @override
  String get executingRequest => 'Memproses...';

  @override
  String get responseOutput => 'Output JSON';

  @override
  String get appendFlutterDevLabel => 'Otomatis tambah \'- Flutter Developer\'';

  @override
  String get enterValidId => 'Masukkan ID angka yang valid';

  @override
  String get nameRequired => 'Nama tidak boleh kosong';

  @override
  String get emailRequired => 'Email tidak boleh kosong';

  @override
  String get methodInfoGetAll => 'GET All: Mengambil seluruh daftar data.';

  @override
  String get methodInfoGetById =>
      'GET By ID: Mengambil satu data berdasarkan ID.';

  @override
  String get methodInfoPost =>
      'POST: Membuat data Pengguna baru (default ID: 1104).';

  @override
  String get methodInfoPut =>
      'PUT: Mengganti nama dan email Pengguna secara penuh.';

  @override
  String get methodInfoPatch =>
      'PATCH: Menambahkan \'- Flutter Developer\' pada nama Pengguna.';

  @override
  String get methodInfoDelete =>
      'DELETE: Menghapus data secara permanen berdasarkan ID.';
}
