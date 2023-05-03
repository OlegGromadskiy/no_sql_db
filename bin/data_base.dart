import 'dart:io';

import 'cluster.dart';
import 'container.dart';

class DataBase {
  late File file;
  final ClusterManager manager;
  final Map<Type, Container> _containers = {};
  final bool _showDebugPrints;

  DataBase._(
    this.file,
    this.manager, {
    required bool showDebugPrints,
  }) : _showDebugPrints = showDebugPrints;

  static Future<DataBase> init({bool showDebugPrints = false}) async {
    final file = File('${Directory.current.path}/db');
    final manager = ClusterManager(await file.open(mode: FileMode.write));

    return DataBase._(
      file,
      manager,
      showDebugPrints: showDebugPrints,
    );
  }

  Container<T> container<T>() {
    if (_containers.containsKey(T)) {
      return _containers[T]! as Container<T>;
    } else {
      return _containers[T] = Container<T>(
        manager,
        showDebugPrints: _showDebugPrints,
      );
    }
  }
}
