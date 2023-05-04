import '../binary_codec.dart';
import '../cluster.dart';
import '../list_container_stepper.dart';

typedef Clusters<T> = Iterable<Cluster<List<T>>>;

class LazyList<T> extends Iterable<T> {
  final Clusters<T> _clusters;

  LazyList(Clusters<T> clusters) : _clusters = clusters;

  @override
  Iterator<T> get iterator => LazyIterator(_clusters);

  @override
  int get length {
    final it = iterator  as LazyIterator<T>;

    return it._length;
  }

  T operator[](int index){
    if(index < 0){
      throw RangeError.range(index , 0, length -1);
    }

    index++;
    final it = iterator;

    for(int i = 0; i < index; i++){
      final result = it.moveNext();

      if(!result){
        throw RangeError.range(index -1 , 0, length -1);
      }
    }

    return it.current;
  }
}

class LazyIterator<T> extends Iterator<T> {
  final ListContainerStepper<T> stepper;

  LazyIterator(Clusters<T> iterable) : stepper = ListContainerStepper<T>(iterable);

  @override
  T get current => stepper.current;

  int get _length => stepper.length;

  @override
  bool moveNext() => stepper.moveNext();
}
