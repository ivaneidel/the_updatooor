import 'package:flutter/material.dart';
import 'package:the_updatooor/models/data_box.dart';

class AddDataBox extends StatefulWidget {
  const AddDataBox({Key? key}) : super(key: key);

  @override
  State<AddDataBox> createState() => _AddDataBoxState();
}

class _AddDataBoxState extends State<AddDataBox> {
  final _urlController = TextEditingController();
  final _pathController = TextEditingController();
  final _nameController = TextEditingController();
  final _prefixController = TextEditingController();

  var _loading = false;
  var _error = false;

  String get _url => _urlController.text;
  String get _path => _pathController.text;
  String get _name => _nameController.text;
  String get _prefix => _prefixController.text;

  bool get _buttonEnabled =>
      !_loading && _url.isNotEmpty && _path.isNotEmpty && _name.isNotEmpty;

  Future<void> _onFetchData() async {
    _loading = true;
    _error = false;
    if (mounted) setState(() {});
    final dataBox = DataBox(_url, _path, _name, _prefix);
    final value = await dataBox.fetchValue();
    if (value != null) {
      if (mounted) {
        Navigator.of(context).pop(dataBox);
      }
    } else {
      _error = true;
    }
    _loading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com/data.json',
                  labelText: 'URL',
                ),
                onChanged: (_) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _pathController,
                decoration: const InputDecoration(
                  hintText: 'key1,key2,key3',
                  labelText: 'Path',
                ),
                onChanged: (_) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'MyData',
                  labelText: 'Name',
                ),
                onChanged: (_) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _prefixController,
                decoration: const InputDecoration(
                  hintText: '\$',
                  labelText: 'Prefix',
                ),
                onChanged: (_) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _error ? Colors.red : null,
                ),
                onPressed: _buttonEnabled ? _onFetchData : null,
                child: _loading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      )
                    : const Text('Fetch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
