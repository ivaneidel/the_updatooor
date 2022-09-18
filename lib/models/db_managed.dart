import 'package:the_updatooor/models/data_box.dart';

enum ManagedState {
  created,
  edited,
  removed,
}

class DBManaged {
  final DataBox dataBox;
  final ManagedState managedState;

  DBManaged(
    this.dataBox,
    this.managedState,
  );
}
