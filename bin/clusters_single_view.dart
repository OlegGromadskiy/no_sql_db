import 'dart:typed_data';

import 'lazy/lazy_list.dart';

class ClustersSingleView<T> {
  final Clusters<T> clusters;

  ClustersSingleView(this.clusters);

  int get size {
    return clusters.first.begin + clusters.last.offset;
  }

  Uint8List read(int start, int count) {
    final buffer = BytesBuilder();
    final begin = start + clusters.first.begin - 1;

    final it = clusters.iterator;
    it.moveNext();

    while(it.current.begin + it.current.offset < begin){
      it.moveNext();
    }

    var currentSize = it.current.size;
    for (int i = 0; i < count; i++, currentSize--) {
      if(currentSize == 0){
        it.moveNext();
        currentSize = it.current.size;
      }

      buffer.addByte(it.current.readByteFrom(begin + i + 1));
    }

    return buffer.toBytes();
  }
}
