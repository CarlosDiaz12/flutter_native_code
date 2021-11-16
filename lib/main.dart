import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _batteryLevel;
  void _showErrorMessage(String? message) {
    message ??= 'An error ocurred.';
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getBatteryLevel() async {
    const platform = MethodChannel('course.flutter.dev/battery');
    try {
      var batteryLevel = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = batteryLevel;
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevel = null;
      });
      var msg = 'Platform error: ${e.toString()}';
      _showErrorMessage(msg);
    } catch (e) {
      setState(() {
        _batteryLevel = null;
      });
      _showErrorMessage(e.toString());
    }
  }

  @override
  void initState() {
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Code'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Battery Level: ${_batteryLevel ?? ''}%'),
      ),
    );
  }
}
