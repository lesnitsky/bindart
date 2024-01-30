import 'dart:convert';
import 'dart:typed_data';

sealed class TID {
  const TID();
  int get $byteLength;
  TIDBox from(int value);
  TIDBox read(ByteData data);
}

class UInt8TID extends TID {
  const UInt8TID();
  @override
  TIDBox from(int value) {
    return UInt8TIDBox(value);
  }

  @override
  int get $byteLength => 1;

  @override
  TIDBox read(ByteData data) {
    return UInt8TIDBox(data.getUint8(0));
  }
}

class UInt16TID extends TID {
  const UInt16TID();
  @override
  TIDBox from(int value) {
    return UInt16TIDBox(value);
  }

  @override
  int get $byteLength => 2;

  @override
  TIDBox read(ByteData data) {
    return UInt16TIDBox(data.getUint16(0));
  }
}

class UInt32TID extends TID {
  const UInt32TID();
  @override
  TIDBox from(int value) {
    return UInt32TIDBox(value);
  }

  @override
  int get $byteLength => 4;

  @override
  TIDBox read(ByteData data) {
    return UInt32TIDBox(data.getUint32(0));
  }
}

class UInt64TID extends TID {
  const UInt64TID();
  @override
  TIDBox from(int value) {
    return UInt64TIDBox(value);
  }

  @override
  int get $byteLength => 8;

  @override
  TIDBox read(ByteData data) {
    return UInt64TIDBox(data.getUint64(0));
  }
}

abstract class TIDBox {
  final int value;
  const TIDBox(this.value);

  void writeTo(ByteData data);
}

class UInt8TIDBox extends TIDBox {
  const UInt8TIDBox(super.value);

  @override
  void writeTo(ByteData data) {
    data.setUint8(0, value);
  }
}

class UInt16TIDBox extends TIDBox {
  const UInt16TIDBox(super.value);

  @override
  void writeTo(ByteData data) {
    data.setUint16(0, value);
  }
}

class UInt32TIDBox extends TIDBox {
  const UInt32TIDBox(super.value);

  @override
  void writeTo(ByteData data) {
    data.setUint32(0, value);
  }
}

class UInt64TIDBox extends TIDBox {
  const UInt64TIDBox(super.value);

  @override
  void writeTo(ByteData data) {
    data.setUint64(0, value);
  }
}

abstract class BinaryChunk<T> {
  TIDBox get $tid;
  int get $byteLength;
  T get content;

  void writeTo(ByteData data);
}

late final TID tid;

class BUint8 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(1);
  @override
  final int content;

  static BUint8 read(ByteData data) {
    return BUint8(data.getUint8(0));
  }

  BUint8(this.content) : assert(content >= 0 && content <= 255);

  @override
  int get $byteLength => 1;

  @override
  void writeTo(ByteData data) {
    data.setUint8(0, content);
  }
}

class BUint16 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(2);
  @override
  final int content;

  static BUint16 read(ByteData data) {
    return BUint16(data.getUint16(0));
  }

  BUint16(this.content) : assert(content >= 0 && content <= 65535);

  @override
  int get $byteLength => 2;

  @override
  void writeTo(ByteData data) {
    data.setUint16(0, content);
  }
}

class BUint32 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(3);
  @override
  final int content;

  static BUint32 read(ByteData data) {
    return BUint32(data.getUint32(0));
  }

  BUint32(this.content) : assert(content >= 0 && content <= 4294967295);

  @override
  int get $byteLength => 4;

  @override
  void writeTo(ByteData data) {
    data.setUint32(0, content);
  }
}

const kMaxInt = 0x7FFFFFFFFFFFFFFF;
const kMinInt = -0x8000000000000000;

class BUint64 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(4);
  @override
  final int content;

  static BUint64 read(ByteData data) {
    return BUint64(data.getUint64(0));
  }

  BUint64(this.content) : assert(content >= 0 && content <= kMaxInt);

  @override
  int get $byteLength => 8;

  @override
  void writeTo(ByteData data) {
    data.setUint64(0, content);
  }
}

class BInt8 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(5);

  @override
  final int content;

  static BInt8 read(ByteData data) {
    return BInt8(data.getInt8(0));
  }

  BInt8(this.content) : assert(content >= -128 && content <= 127);

  @override
  int get $byteLength => 1;

  @override
  void writeTo(ByteData data) {
    data.setInt8(0, content);
  }
}

class BInt16 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(6);

  @override
  final int content;

  static BInt16 read(ByteData data) {
    return BInt16(data.getInt16(0));
  }

  BInt16(this.content) : assert(content >= -32768 && content <= 32767);

  @override
  int get $byteLength => 2;

  @override
  void writeTo(ByteData data) {
    data.setInt16(0, content);
  }
}

class BInt32 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(7);

  @override
  final int content;

  static BInt32 read(ByteData data) {
    return BInt32(data.getInt32(0));
  }

  BInt32(this.content)
      : assert(content >= -2147483648 && content <= 2147483647);

  @override
  int get $byteLength => 4;

  @override
  void writeTo(ByteData data) {
    data.setInt32(0, content);
  }
}

class BInt64 implements BinaryChunk<int> {
  @override
  TIDBox get $tid => tid.from(8);

  @override
  final int content;

  static BInt64 read(ByteData data) {
    return BInt64(data.getInt64(0));
  }

  BInt64(this.content) : assert(content >= kMinInt && content <= kMaxInt);

  @override
  int get $byteLength => 8;

  @override
  void writeTo(ByteData data) {
    data.setInt64(0, content);
  }
}

class BFloat32 implements BinaryChunk<double> {
  @override
  TIDBox get $tid => tid.from(9);

  @override
  final double content;

  static BFloat32 read(ByteData data) {
    return BFloat32(data.getFloat32(0));
  }

  BFloat32(this.content);

  @override
  int get $byteLength => 4;

  @override
  void writeTo(ByteData data) {
    data.setFloat32(0, content);
  }
}

class BFloat64 implements BinaryChunk<double> {
  @override
  TIDBox get $tid => tid.from(10);

  @override
  final double content;

  static BFloat64 read(ByteData data) {
    return BFloat64(data.getFloat64(0));
  }

  BFloat64(this.content);

  @override
  int get $byteLength => 8;

  @override
  void writeTo(ByteData data) {
    data.setFloat64(0, content);
  }
}

class BBool implements BinaryChunk<bool> {
  @override
  TIDBox get $tid => tid.from(11);

  @override
  final bool content;

  static BBool read(ByteData data) {
    return BBool(data.getUint8(0) == 1);
  }

  BBool(this.content);

  @override
  int get $byteLength => 1;

  @override
  void writeTo(ByteData data) {
    data.setUint8(0, content ? 1 : 0);
  }
}

class BString255 implements BinaryChunk<String> {
  @override
  TIDBox get $tid => tid.from(12);

  @override
  final String content;

  static BString255 read(ByteData data) {
    final length = data.getUint8(0);
    final encoded = data.buffer.asUint8List(data.offsetInBytes + 1, length);
    final content = utf8.decode(encoded);

    return BString255(content);
  }

  late final encoded = utf8.encode(content);

  BString255(this.content) : assert(content.length <= 255);

  @override
  int get $byteLength => 1 + encoded.length;

  @override
  void writeTo(ByteData data) {
    data.setUint8(0, encoded.length);

    for (var i = 0; i < encoded.length; i++) {
      data.setUint8(1 + i, encoded[i]);
    }
  }
}

class BString65535 implements BinaryChunk<String> {
  @override
  TIDBox get $tid => tid.from(13);

  @override
  final String content;

  static BString65535 read(ByteData data) {
    final length = data.getUint16(0);
    final encoded = data.buffer.asUint8List(data.offsetInBytes + 2, length);
    final content = utf8.decode(encoded);

    return BString65535(content);
  }

  late final encoded = utf8.encode(content);

  BString65535(this.content) : assert(content.length <= 65535);

  @override
  int get $byteLength => 2 + encoded.length;

  @override
  void writeTo(ByteData data) {
    data.setUint16(0, encoded.length);

    for (var i = 0; i < encoded.length; i++) {
      data.setUint8(2 + i, encoded[i]);
    }
  }
}

class BString4294967295 implements BinaryChunk<String> {
  @override
  TIDBox get $tid => tid.from(14);

  @override
  final String content;

  static BString4294967295 read(ByteData data) {
    final length = data.getUint32(0);
    final encoded = data.buffer.asUint8List(data.offsetInBytes + 4, length);
    final content = utf8.decode(encoded);

    return BString4294967295(content);
  }

  late final encoded = utf8.encode(content);

  BString4294967295(this.content) : assert(content.length <= 4294967295);

  @override
  int get $byteLength => 4 + encoded.length;

  @override
  void writeTo(ByteData data) {
    data.setUint32(0, encoded.length);

    for (var i = 0; i < encoded.length; i++) {
      data.setUint8(4 + i, encoded[i]);
    }
  }
}

class BString implements BinaryChunk<String> {
  @override
  TIDBox get $tid => tid.from(15);

  @override
  final String content;

  static BString read(ByteData data) {
    final length = data.getUint64(0);
    final encoded = data.buffer.asUint8List(data.offsetInBytes + 8, length);
    final content = utf8.decode(encoded);

    return BString(content);
  }

  late final encoded = utf8.encode(content);

  BString(this.content);

  @override
  int get $byteLength => 8 + encoded.length;

  @override
  void writeTo(ByteData data) {
    data.setUint64(0, encoded.length);

    for (var i = 0; i < encoded.length; i++) {
      data.setUint8(8 + i, encoded[i]);
    }
  }
}
