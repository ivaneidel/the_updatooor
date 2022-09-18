import 'package:flutter/material.dart';
import 'package:the_updatooor/models/data_box.dart';

class DataBoxView extends StatefulWidget {
  final DataBox dataBox;
  final Function(DataBox?) showDataBoxManager;

  const DataBoxView({
    Key? key,
    required this.dataBox,
    required this.showDataBoxManager,
  }) : super(key: key);

  @override
  State<DataBoxView> createState() => _DataBoxView();
}

class _DataBoxView extends State<DataBoxView> {
  String? _value;
  DateTime? _dateTime;

  Future<void> _fetchValue() async {
    final value = await widget.dataBox.fetchValue();
    if (value != null) {
      _value = value;
      _dateTime = DateTime.now();
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchValue();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: MediaQuery.of(context).size.width * 0.5 - 22.5,
      height: MediaQuery.of(context).size.width * 0.5 - 22.5,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onDoubleTap: () => widget.showDataBoxManager(widget.dataBox),
          onTap: _fetchValue,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dataBox.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Expanded(child: Container()),
                if (_value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              '${widget.dataBox.prefix}$_value',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Expanded(child: Container()),
                if (_dateTime != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _dateTime.toString().split('.').first,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return Draggable<DataBox>(
      data: widget.dataBox,
      feedback: child,
      childWhenDragging: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5 - 22.5,
        height: MediaQuery.of(context).size.width * 0.5 - 22.5,
      ),
      child: child,
    );
  }
}
