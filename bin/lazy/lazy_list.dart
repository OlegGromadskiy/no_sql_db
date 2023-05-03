import '../binary_codec.dart';
import '../cluster.dart';


typedef Clusters<T> = Iterable<Cluster<List<T>>>;

class LazyList<T> extends Iterable<T>{
  final Clusters<T> _clusters;

  LazyList(Clusters<T> clusters) : _clusters = clusters;

  @override
  Iterator<T> get iterator => LazyIterator(this);
}

class LazyIterator<T> extends Iterator<T>{
  int offset = 0;
  final LazyList<T> _source;

  LazyIterator(LazyList<T> iterable): _source = iterable;

  @override
  T get current {
    var start = _source._clusters.first.begin;

    start += 8; // add list tag
    start += 8; // add list length


    binaryCodec.de

    throw UnimplementedError();
  }

  @override
  bool moveNext() {
    throw UnimplementedError();
  }
}