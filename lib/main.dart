import 'package:flutter/material.dart';
import 'package:untitled1/router.dart';
import 'core/di/injectProvider.dart';


void main() async  {
  // ADD THIS: ফ্লাটার বাইন্ডিং নিশ্চিত করা (GetIt এবং অন্যান্য asynchronous কাজের জন্য)
  WidgetsFlutterBinding.ensureInitialized();

  // ADD THIS: GetIt ডিপেন্ডেন্সি ইনজেকশন কন্টেইনার চালু করা
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Animated Sliver Header',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: router,
    );
  }
}






