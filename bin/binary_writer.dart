import 'dart:convert';
import 'dart:typed_data';

import 'binary_reader.dart';
import 'converters/converter.dart';

class BinaryWriter {
  final Encoders _encoders;
  final TagByType _tagByType;
  final BytesBuilder _builder = BytesBuilder();

  BinaryWriter({
    required Encoders encoders,
    required TagByType tagByType,
  })  : _encoders = encoders,
        _tagByType = tagByType;

  Uint8List look() {
    return _builder.toBytes();
  }

  void write<T>(T object) {
    final tag = _tagByType(object);
    _writeTag(tag);

    final type = object.runtimeType;

    if (type == BinaryConverter) {
       _encoders[tag]!.encode(object, this);
    } else if(type == int){
       _writeInt(object as int);
    } else if(type == String){
       _writeString(object as String);
    } else if(type == double) {
       _writeDouble(object as double);
    }else if(type == List){
      _writeList(object as List);
    } else if(type == bool){
      _writeBool(object as bool);
    } else {
      throw 'Unsupported type ${object.runtimeType}';
    }
  }

  void _writeTag(int tag) {
    _writeInt(tag);
  }

  void _writeString(String str){
    _writeInt(str.length);

    _writeAll(Uint8List.fromList(utf8.encode(str)));
  }

  void _writeForList(){

  }

  void _writeList(List list){
    _writeInt(list.length);

    for (final value in list) {
      write(value);
    }
  }

  void _writeInt(int object) {
    final bytes = ByteData(8)..setInt64(0, object);

    _builder.add(bytes.buffer.asUint8List());
  }

  void _writeDouble(double object) {
    final bytes = ByteData(8)..setFloat64(0, object);

    _builder.add(bytes.buffer.asUint8List());
  }

  void _writeBool(bool object) {
    final bytes = ByteData(1)..setUint8(0, object ? 1 : 0);

    _builder.add(bytes.buffer.asUint8List());
  }

  void _writeAll(Uint8List bytes) {
    _builder.add(bytes);
  }

  Uint8List collect() {
    return _builder.toBytes();
  }
}
