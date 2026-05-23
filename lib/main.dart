import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/router.dart';
import 'package:workmanager/workmanager.dart';
import 'core/di/injectProvider.dart';

import 'methode_channel_service.dart';

void main() async  {
  // ADD THIS: ফ্লাটার বাইন্ডিং নিশ্চিত করা (GetIt এবং অন্যান্য asynchronous কাজের জন্য)
  WidgetsFlutterBinding.ensureInitialized();

  // ADD THIS: GetIt ডিপেন্ডেন্সি ইনজেকশন কন্টেইনার চালু করা
  await init();

  // Initialize WorkManager
  await Workmanager().initialize(
        (task, inputData) async {
      // Background task handler
      return Future.value(true);
    },
  );

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


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  context.go("/profile/10");
                },
                child: Text("Go To Next")
            ),
            ElevatedButton(
              onPressed: () async {
                String battery = await NativeService.getBatteryPercentage();
                print(battery);
              },
              child: Text("Get Battery"),
            )

          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String productId;
  const ProfilePage({super.key, required this.productId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Profile ${widget.productId}"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              context.goNamed("home");
            },
            child: Text("Go Back")
        ),
      ),
    );
  }
}





