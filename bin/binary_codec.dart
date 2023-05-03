import 'dart:typed_data';

import 'binary_writer.dart';
import 'converters/base_types_tags.dart';
import 'binary_reader.dart';
import 'converters/converter.dart';

final binaryCodec = BinaryCodec();

class BinaryCodec {
  final _registeredConverters = <int, BinaryConverter>{};

  int tagByType(dynamic object) {
    if (object is int) {
      return BaseTypesTags.integer.tag;
    } else if (object is String) {
      return BaseTypesTags.string.tag;
    } else if (object is List) {
      return BaseTypesTags.list.tag;
    } else if(object is bool){
      return BaseTypesTags.bool.tag;
    }else if (object is BinaryConverter) {
      return object.tag;
    } else {
      throw 'Type [${object.runtimeType}] no registered';
    }
  }

  Uint8List encodeObject<T>(T object) {
    final writer = BinaryWriter(
      encoders: _registeredConverters,
      tagByType: tagByType,
    );

    writer.write(object);

    return writer.collect();
  }

  T decodeBytes<T>(Uint8List bytes) {
    final reader = BinaryReader(
      bytes: bytes,
      tagByType: tagByType,
      decoders: _registeredConverters,
    );

    return reader.read<T>();
  }

  //Uint8List encode(dynamic object, BinaryWriter writer){
  //  int tag = tagByType(object);
//
  //  return _registeredConverters[tag]!.encode(object, writer);
  //}
//
  //Object decode (BinaryReader reader){
  //  final typeTag = reader.readTag();
//
  //  return _registeredConverters[typeTag.tag]!.decode(reader);
  //}

  void registerConverter(BinaryConverter converter) {
    _registeredConverters[converter.tag] = converter;
  }
}
