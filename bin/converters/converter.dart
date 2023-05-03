import 'dart:typed_data';

import '../binary_reader.dart';
import '../binary_writer.dart';

abstract class BinaryEncoder<T> {
  Uint8List encode(T object, BinaryWriter writer);
}

abstract class BinaryDecoder<T> {
  T decode(BinaryReader reader);
}

abstract class BinaryConverter<T> implements BinaryEncoder<T>, BinaryDecoder<T> {
  const BinaryConverter();

  int get tag;

  @override
  Uint8List encode(T object, BinaryWriter writer);

  @override
  T decode(BinaryReader reader);
}
