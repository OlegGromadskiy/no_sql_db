/*
import 'dart:convert';
import 'dart:typed_data';
import '../binary_codec.dart';
import '../binary_writer.dart';
import 'base_types_tags.dart';
import '../binary_reader.dart';
import 'converter.dart';

class IntConverter implements BinaryConverter<int> {
  const IntConverter();

  @override
  int get tag => BaseTypesTags.integer.tag;

  @override
  int decode(BinaryReader reader) {
    return reader.readInt();
  }

  @override
  Uint8List encode(int object, BinaryWriter writer) {
    writer.writeTag(BaseTypesTags.integer.tag);
    writer.writeInt(object);

    return writer.collect();
  }
}

class StringConverter implements BinaryConverter<String> {
  const StringConverter();

  @override
  int get tag => BaseTypesTags.string.tag;

  @override
  String decode(BinaryReader reader) {
    final length = reader.readInt();

    return utf8.decode(reader.readLength(length));
  }

  @override
  Uint8List encode(String object, BinaryWriter writer) {
    writer.writeTag(BaseTypesTags.string.tag);
    writer.writeInt(object.length);
    writer.writeAll(Uint8List.fromList(utf8.encode(object)));

    return writer.collect();
  }
}

class ListConverter implements BinaryConverter<List> {
  const ListConverter();

  @override
  int get tag => BaseTypesTags.string.tag;

  @override
  List decode(BinaryReader reader) {
    final list = [];

    final length = reader.readInt();

    for (int i = 0; i < length; i++) {
      //read size
      //reader.readInt();
      list.add(binaryCodec.decode(reader));
    }

    return list;
  }

  @override
  Uint8List encode(List object, BinaryWriter writer) {
    writer.writeTag(BaseTypesTags.list.tag);
    writer.writeInt(object.length);

    for (var value in object) {
      final bytes = binaryCodec.encode(value, writer);
     // writer.writeInt(bytes.length);
    }

    return writer.collect();
  }
}
*/
