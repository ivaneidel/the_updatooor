import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:the_updatooor/components/add_data_box.dart';
import 'package:the_updatooor/components/data_box.dart';
import 'package:the_updatooor/models/data_box.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setWindowSize(const Size(400, 800));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Updator',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _boxes = <DataBox>[];

  Future<void> _addDataBox() async {
    DataBox? dataBox = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (_) => const AddDataBox(),
    );
    if (dataBox != null) {
      _boxes.add(dataBox);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    for (var box in _boxes) DataBoxView(dataBox: box),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDataBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
