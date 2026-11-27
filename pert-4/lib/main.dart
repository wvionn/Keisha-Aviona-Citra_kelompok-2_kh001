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

import 'package:flutter/material.dart';
import 'package:pertemuan2/constans/colors.dart';
import 'theme/app_theme.dart';
import 'widgets/buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Design System Demo'),
        backgroundColor: AppColors.secondary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Github Vion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.tertiary,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tekan tombol di bawah untuk melihat lokasi kampus.',
            ),

            const SizedBox(height: 24),

            AppButton(
              label: 'Buka Github Vion',
              icon: Icons.location_on,
              url:
              'https://github.com/wvionn',
            ),

            const SizedBox(height: 16),

            AppButton(
              label: 'Tes Tombol',
              icon: Icons.touch_app,
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              },
            ),
          ],
        ),
      ),
    );
  }
}