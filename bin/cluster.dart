import 'dart:io';
import 'dart:typed_data';

class ClusterManager {
  int offset = 0;
  final RandomAccessFile _file;
  final List<Cluster> _clusters = [];

  ClusterManager(this._file);

  Future<List<int>> get bytes async {
    final buffer = Uint8List(await _file.length());

    final oldPosition = _file.positionSync();

    _file.setPositionSync(0);
    _file.readIntoSync(buffer);
    _file.setPositionSync(oldPosition);

    return buffer;
  }

  Future<void> write<T>(Uint8List bytes) async {
    final clusters = typedClusters<T>()..forEach((cluster) => cluster.reset());

    if (clusters.isEmpty) {
      _clusters.add(Cluster<T>(begin: offset, file: _file));
    }

    var clusterIterator = clusters.iterator..moveNext();
    int iterations = 0;

    for (final byte in bytes) {
      if (!clusterIterator.current.write(byte)) {
        if (!clusterIterator.moveNext()) {
          _clusters.add(Cluster<T>(begin: offset, file: _file));

          clusterIterator = clusters.iterator;
          for (int i = 0; i <= iterations + 1; i++) {
            clusterIterator.moveNext();
          }
        }
        iterations++;
        clusterIterator.current.write(byte);
      }
      offset++;
    }

    //for (final byte in bytes) {
    //  if (!clusters.last.write(byte)) {
    //    _clusters.add(Cluster<T>(begin: offset, file: _file));
    //    clusters.last.write(byte);
    //  }
    //  offset++;
    //}

    //print('Used clusters ${clusters.length}');
  }

  Iterable<Cluster> typedClusters<T>() {
    return _clusters.whereType<Cluster<T>>();
  }

  Future<Uint8List> read<T>() async {
    final clusters = typedClusters<T>();
    final List<int> buffer = [];

    for (final cluster in clusters) {
      buffer.addAll(cluster.read());
    }

    return Uint8List.fromList(buffer);
  }
}

class Cluster<T> {
  final int size;
  final int begin;
  final RandomAccessFile _file;
  int _offset = 0;

  Cluster({
    required this.begin,
    required RandomAccessFile file,
    this.size = 1024,
  }) : _file = file;

  void reset() {
    _offset = 0;
  }

  int get offset => _offset;

  Uint8List read() {
    _file.setPositionSync(begin);

    final buffer = Uint8List(_offset);
    _file.readIntoSync(buffer, 0, _offset);

    return buffer;
  }

  bool write(int byte) {
    if (_offset + 1 > size) {
      return false;
    }

    _file.setPositionSync(begin + _offset);
    _offset++;
    _file.writeByteSync(byte);

    return true;
  }

  int get availableSize => size - _offset;
}
