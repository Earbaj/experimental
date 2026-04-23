import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/router.dart';

import 'methode_channel_service.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
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





