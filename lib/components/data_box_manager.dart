import 'package:flutter/material.dart';
import 'package:the_updatooor/helpers/random.dart';
import 'package:the_updatooor/models/data_box.dart';
import 'package:the_updatooor/models/db_managed.dart';

class DataBoxManager extends StatefulWidget {
  final DataBox? dataBox;

  const DataBoxManager({
    Key? key,
    this.dataBox,
  }) : super(key: key);

  @override
  State<DataBoxManager> createState() => _DataBoxManagerState();
}

class _DataBoxManagerState extends State<DataBoxManager> {
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
    final dataBox = DataBox(
      widget.dataBox?.id ?? getRandomString(15),
      _url,
      _path,
      _name,
      _prefix,
    );
    final value = await dataBox.fetchValue();
    if (value != null) {
      if (mounted) {
        Navigator.of(context).pop(
          DBManaged(
            dataBox,
            widget.dataBox != null ? ManagedState.edited : ManagedState.created,
          ),
        );
      }
    } else {
      _error = true;
    }
    _loading = false;
    if (mounted) setState(() {});
  }

  Future<void> _removeDataBox() async {
    bool? response = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove DataBox'),
        content: const Text('Are you sure you want to remove this DataBox?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (response != null && response) {
      if (mounted) {
        Navigator.of(context).pop(DBManaged(
          widget.dataBox!,
          ManagedState.removed,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.dataBox != null) {
      _urlController.text = widget.dataBox!.url;
      _pathController.text = widget.dataBox!.path;
      _nameController.text = widget.dataBox!.name;
      _prefixController.text = widget.dataBox!.prefix;

      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.dataBox != null)
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: _removeDataBox,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
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
