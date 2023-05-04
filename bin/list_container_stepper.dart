import 'binary_codec.dart';
import 'clusters_single_view.dart';
import 'lazy/lazy_list.dart';

class ListContainerStepper<T> {
  final ClustersSingleView<T> clustersView;

  final start = 0;
  final lengthStart = 8;
  final firstItemSizeStart = 16;

  late int offset = firstItemSizeStart;

  bool isFirstMove = true;

  ListContainerStepper(Clusters<T> iterable) : clustersView = ClustersSingleView(iterable);

  int get length => binaryCodec.decodeInt(clustersView.read(lengthStart, 8));

  T get current {
    var tempOffset = offset;

    final size = binaryCodec.decodeInt(clustersView.read(tempOffset, 8));
    tempOffset+=8;

    return binaryCodec.decodeBytes<T>(clustersView.read(tempOffset, size));
  }

  bool moveNext() {
    if (isFirstMove) {
      isFirstMove = false;
      return true;
    }

    final size = binaryCodec.decodeInt(clustersView.read(offset, 8));
    offset += size + 8;

    return clustersView.size != offset;
  }
}
