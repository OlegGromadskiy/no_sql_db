import 'dart:typed_data';

import 'cluster.dart';

class ClusterReadManager {
  final List<Cluster> _clusters;

  ClusterReadManager(this._clusters);

  Future<Uint8List> read<T>() async {
    final clusters = _clusters;
    final List<int> buffer = [];

    for (final cluster in clusters) {
      buffer.addAll(cluster.read());
    }

    return Uint8List.fromList(buffer);
  }
}