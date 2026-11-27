// import 'package:flutter/material.dart';
// import 'constans/colors.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;
//
//   final List<Widget> pages = const [
//     HomeContent(),
//     Content2(),
//   ];
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("VionApp"),
//       ),
//       body: pages[currentIndex],
//
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//
//         items: const[
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home, color: AppColors.primary),
//               label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class HomeContent extends StatelessWidget {
//   const HomeContent ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//               "Selamat Datang!",
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.w900,
//                 fontSize: 25,
//               ),
//           ),
//           Container(
//             width: 200,
//             height: 30,
//             color: Colors.blue,
//           ),
//           const Padding(padding: EdgeInsets.only(bottom: 20)),
//           Container(
//             width: 400,
//             height: 28,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//                   ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                   child: Container(
//                     height: 50,
//                     color: Colors.red,
//                   ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Container(
//                   height: 50,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class Content2 extends StatelessWidget {
//   const Content2 ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 200,
//             height: 30,
//             color: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:pertemuan2/constans/colors.dart';
// import 'theme/app_theme.dart';
// import 'widgets/buttons.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Design System Demo'),
//         backgroundColor: AppColors.secondary,
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Github Vion',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.tertiary,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             const Text(
//               'Tekan tombol di bawah untuk melihat lokasi kampus.',
//             ),
//
//             const SizedBox(height: 24),
//
//             AppButton(
//               label: 'Buka Github Vion',
//               icon: Icons.location_on,
//               url:
//               'https://github.com/wvionn',
//             ),
//
//             const SizedBox(height: 16),
//
//             AppButton(
//               label: 'Tes Tombol',
//               icon: Icons.touch_app,
//               onPressed: () {
//                 debugPrint('Tombol berhasil ditekan!');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GlobalKey untuk validasi Form
  final _formKey = GlobalKey<FormState>();

  // TextEditingController untuk mengambil input dari pengguna
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _matakuliahController = TextEditingController();

  // Pilihan Keterangan Kehadiran (Hadir, Izin, Sakit)
  String? _selectedStatus = 'Hadir';
  final List<String> _statusOptions = ['Hadir', 'Izin', 'Sakit'];

  bool _isLoading = false;

  // Fungsi dinamis untuk menyimpan data input pengguna ke Firestore
  Future<void> simpanData() async {
    await FirebaseFirestore.instance.collection('praktikum').add({
      'nama': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'lokasi': _lokasiController.text.trim(),
      'mata_kuliah': _matakuliahController.text.trim(),
      'status': _selectedStatus,
      'waktu': FieldValue.serverTimestamp(),
    });
  }

  // Fungsi penanganan proses simpan data dan validasi
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await simpanData();

        if (mounted) {
          // Notifikasi Keberhasilan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan ke Firebase!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset Form dan Kosongkan Seluruh Field Input
          _formKey.currentState!.reset();
          _namaController.clear();
          _nimController.clear();
          _lokasiController.clear();
          _matakuliahController.clear();
          setState(() {
            _selectedStatus = 'Hadir';
          });
        }
      } catch (e) {
        if (mounted) {
          // Notifikasi Kesalahan / Gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _lokasiController.dispose();
    _matakuliahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Firebase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Form Presensi Mahasiswa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Field Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field NIM
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Lokasi
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Masukkan Lokasi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Mata Kuliah
              TextFormField(
                controller: _matakuliahController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  hintText: 'Masukkan Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata Kuliah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Keterangan Kehadiran (Hadir, Izin, Sakit)
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Kehadiran',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.how_to_reg),
                ),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih keterangan kehadiran';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(
                  'Simpan ke Firebase',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}