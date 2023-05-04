import 'dart:convert';
import 'dart:typed_data';

import 'converters/base_types_tags.dart';
import 'converters/converter.dart';

typedef Decoders = Map<int, BinaryDecoder>;
typedef Encoders = Map<int, BinaryEncoder>;
typedef TagByType = int Function(dynamic);

class BinaryReader {
  int offset = 0;
  final Uint8List _data;
  final Decoders _decoders;

  BinaryReader({
    required Uint8List bytes,
    required Decoders decoders,
    required TagByType tagByType,
  })  : _decoders = decoders,
        _data = bytes;

  T read<T>() {
    final tag = _readTag();

    if(tag == BaseTypesTags.integer){
      return _readInt() as T;
    }  else if(tag == BaseTypesTags.string){
      return _readString() as T;
    } else if (tag == BaseTypesTags.list){
      return _readList() as T;
    } else if(tag == BaseTypesTags.double){
      return _readDouble() as T;
    } else if(tag == BaseTypesTags.bool){
      return _readBool() as T;
    } else if (_decoders.containsKey(tag.tag)){
      return _decoders[tag]!.decode(this);
    } else {
      throw 'Unsupported type $tag';
    }
  }

  BaseTypesTags _readTag() {
    return BaseTypesTags.fromInt(_readInt());
  }

  int _readInt() {
    final value = ByteData.sublistView(_data).getInt64(offset);
    offset += 8;

    return value;
  }

  List _readList(){
    final length = _readInt();
    final buffer = [];

    for(int i = 0; i < length; i++){
      _readInt();
      buffer.add(read());
    }

    return buffer;
  }

  String _readString(){
    final length = _readInt();
    final value = utf8.decode(_readLength(length));

    return value;
  }

  double _readDouble() {
    final value = ByteData.sublistView(_data).getFloat64(offset);
    offset += 8;

    return value;
  }

  bool _readBool() {
    final value = ByteData.sublistView(_data).getUint8(offset) == 1;
    offset += 1;

    return value;
  }

  int _readByte() {
    return _data[offset++];
  }

  Uint8List _readRest() {
    final value = _data.sublist(offset);
    offset = _data.length;

    return value;
  }

  Uint8List _readLength(int length) {
    final value = _data.sublist(offset, offset + length);
    offset += length;

    return value;
  }
}
