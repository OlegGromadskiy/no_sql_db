import 'binary_codec.dart';
import 'cluster.dart';

class Container<T> {
  final bool _showDebugPrints;
  final ClusterManager manager;

  Container(
    this.manager, {
    required bool showDebugPrints,
  }) : _showDebugPrints = showDebugPrints;

  Future<void> put(T object) async {
    final bytes = binaryCodec.encodeObject(object); // encode<T>(object);

    await manager.write<T>(bytes);

    if (_showDebugPrints) {
      print('Write => $bytes');

      print('Current file structure is ${await manager.bytes}');
    }
  }

  Future<dynamic> get() async {
    final bytes = await manager.read<T>();

    final list = binaryCodec.decodeBytes(bytes);

    if (_showDebugPrints) {
      print('Read => $bytes');
    }

    return list;
  }
}

extension ListContainer<T> on Container<List<T>> {
  Future<List<T>> getLazy() async {
    final clusters = manager.typedClusters<List<T>>();

    return await get();
  }
}
