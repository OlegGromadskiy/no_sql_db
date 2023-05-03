import 'dart:io';
import 'dart:typed_data';

import 'cluster.dart';

class ClusterWriteManager {
  int _offset;
  final RandomAccessFile _file;
  final List<Cluster> _clusters;

  ClusterWriteManager({
    required int offset,
    required RandomAccessFile file,
    required List<Cluster> clusters,
  }) : _offset = offset, _file = file, _clusters = clusters;

  Future<List<int>> get bytes async {
    final buffer = Uint8List(await _file.length());

    final oldPosition = _file.positionSync();

    _file.setPositionSync(0);
    _file.readIntoSync(buffer);
    _file.setPositionSync(oldPosition);

    return buffer;
  }

  Future<int> write<T>(Uint8List bytes) async {
    final clusters = _clusters..forEach((cluster) => cluster.reset());

    if (clusters.isEmpty) {
      _clusters.add(Cluster<T>(begin: _offset, file: _file));
    }

    var clusterIterator = clusters.iterator..moveNext();
    int iterations = 0;

    for (final byte in bytes) {
      if (!clusterIterator.current.write(byte)) {
        if (!clusterIterator.moveNext()) {
          _clusters.add(Cluster<T>(begin: _offset, file: _file));

          clusterIterator = clusters.iterator;
          for (int i = 0; i <= iterations + 1; i++) {
            clusterIterator.moveNext();
          }
        }
        iterations++;
        clusterIterator.current.write(byte);
      }
      _offset++;
    }

    return _offset;
  }
}
