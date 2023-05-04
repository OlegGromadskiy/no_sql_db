import 'dart:convert';
import 'dart:typed_data';

import 'binary_reader.dart';
import 'converters/converter.dart';

class BinaryWriter {
  final Encoders _encoders;
  final TagByType _tagByType;

  BinaryWriter({
    required Encoders encoders,
    required TagByType tagByType,
  })  : _encoders = encoders,
        _tagByType = tagByType;

  Uint8List write<T>(T object) {
    final tag = _tagByType(object);
    final builder = BytesBuilder();

    builder.add(_writeTag(tag));

    final type = object.runtimeType;

    if (type == BinaryConverter) {
      builder.add(_encoders[tag]!.encode(object, this));
    } else if (type == int) {
      builder.add(_writeInt(object as int));
    } else if (type == String) {
      builder.add(_writeString(object as String));
    } else if (type == double) {
      builder.add(_writeDouble(object as double));
    } else if (type == List) {
      builder.add(_writeList(object as List));
    } else if (type == bool) {
      builder.add(_writeBool(object as bool));
    } else {
      throw 'Unsupported type ${object.runtimeType}';
    }

    return builder.takeBytes();
  }

  Uint8List _writeTag(int tag) {
    return _writeInt(tag);
  }

  Uint8List _writeString(String str) {
    final builder = BytesBuilder();

    builder.add(_writeInt(str.length));

    builder.add(utf8.encode(str));

    return builder.toBytes();
  }

  Uint8List _writeList(List list) {
    final builder = BytesBuilder();

    builder.add(_writeInt(list.length));

    for (final value in list) {
      final bytes = write(value);
      builder.add(_writeInt(bytes.length));
      builder.add(bytes);
    }

    return builder.toBytes();
  }

  Uint8List _writeInt(int object) {
    final bytes = ByteData(8)..setInt64(0, object);

    return bytes.buffer.asUint8List();
  }

  Uint8List _writeDouble(double object) {
    final bytes = ByteData(8)..setFloat64(0, object);

    return bytes.buffer.asUint8List();
  }

  Uint8List _writeBool(bool object) {
    final bytes = ByteData(1)..setUint8(0, object ? 1 : 0);

    return bytes.buffer.asUint8List();
  }
}
