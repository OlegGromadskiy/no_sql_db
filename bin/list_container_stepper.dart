import 'binary_codec.dart';
import 'cluster.dart';
import 'lazy/lazy_list.dart';

class ListContainerStepper<T> {
  final Iterable<Cluster> _clusters;

  late int offset = start + 16;
  late int start = currentCluster.begin;
  late Cluster currentCluster = _clusters.first;

  bool isFirstMove = true;

  ListContainerStepper(Clusters<T> iterable) : _clusters = iterable;

  int get length {
    return binaryCodec.decodeInt(currentCluster.readFromTo(start + 8, start + 16));
  }

  T get current {
    var tempOffset = offset;


    for(int i = 0; i < 8; i++){

    }
    final size = binaryCodec.decodeInt(currentCluster.readFromTo(tempOffset, tempOffset += 8));

    return binaryCodec.decodeBytes<T>(currentCluster.readFromTo(tempOffset, tempOffset += size));
  }

  bool moveNext() {
    if (isFirstMove) {
      isFirstMove = false;
      return true;
    }

    final size = binaryCodec.decodeInt(currentCluster.readFromTo(offset, offset += 8));
    offset += size;

    if (currentCluster.begin + currentCluster.offset == offset) {
      return false;
    }

    return true;
  }
}
