import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:the_updatooor/components/data_box_manager.dart';
import 'package:the_updatooor/components/data_box_view.dart';
import 'package:the_updatooor/models/data_box.dart';
import 'package:the_updatooor/models/db_managed.dart';
import 'package:the_updatooor/services/storage.dart';

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
  List<DataBox>? _boxes;

  Future<void> _showDataBoxManager([DataBox? dataBox]) async {
    DBManaged? dbManaged = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (_) => DataBoxManager(dataBox: dataBox),
    );
    if (dbManaged != null) {
      switch (dbManaged.managedState) {
        case ManagedState.created:
          _boxes!.add(dbManaged.dataBox);
          if (mounted) setState(() {});
          await Storage.saveDataBox(dbManaged.dataBox);
          break;
        case ManagedState.edited:
          if (dataBox != null) {
            final boxIndex = _boxes!.indexWhere((box) => box.id == dataBox.id);
            _boxes![boxIndex] = dbManaged.dataBox;
            if (mounted) setState(() {});
            await Storage.saveDataBox(dbManaged.dataBox);
          }
          break;
        case ManagedState.removed:
          if (dataBox != null) {
            _boxes!.removeWhere((box) => box.id == dataBox.id);
            if (mounted) setState(() {});
            await Storage.removeDataBox(dbManaged.dataBox);
          }
          break;
        default:
      }
    }
  }

  Future<void> _initDataBoxes() async {
    _boxes = await Storage.fetchDataBoxes();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initDataBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _boxes == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _boxes!.isEmpty
                ? Center(
                    child: TextButton(
                      onPressed: _showDataBoxManager,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Add some DataBoxes'),
                          SizedBox(height: 15),
                          Icon(Icons.add_box_rounded),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
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
                              for (var box in _boxes!)
                                DataBoxView(
                                  dataBox: box,
                                  showDataBoxManager: _showDataBoxManager,
                                ),
                            ],
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDataBoxManager,
        child: const Icon(Icons.add),
      ),
    );
  }
}
