import 'dart:convert';
import 'dart:typed_data';

import 'package:bindart/bindart.dart';
import 'package:test/test.dart';

void main() {
  group('bindart', () {
    test('works', () {
      tid = UInt8TID();

      const initial = [
        1,
        256,
        65536,
        4294967296,
        0x7FFFFFFFFFFFFFFF,
        -1,
        -128,
        -32768,
        -2147483648,
        -0x8000000000000000,
        3.4028234663852886e+38,
        1.7976931348623157e+308,
        true,
        'Hello 🌎',
      ];

      final chunks = initial.map<BinaryChunk>((c) {
        if (c is int) {
          return switch (c) {
            >= 0 && <= 255 => BUint8(c),
            >= 0 && <= 65535 => BUint16(c),
            >= 0 && <= 4294967295 => BUint32(c),
            >= 0 && <= kMaxInt => BUint64(c),
            >= -128 && <= 127 => BInt8(c),
            >= -32768 && <= 32767 => BInt16(c),
            >= -2147483648 && <= 2147483647 => BInt32(c),
            >= kMinInt && <= kMaxInt => BInt64(c),
            _ => throw Exception('Invalid int value: $c'),
          };
        }

        if (c is double) {
          return switch (c) {
            >= -3.4028234663852886e+38 && <= 3.4028234663852886e+38 =>
              BFloat32(c),
            >= -1.7976931348623157e+308 && <= 1.7976931348623157e+308 =>
              BFloat64(c),
            _ => throw Exception('Invalid double value: $c'),
          };
        }

        if (c is String) {
          return switch (c.length) {
            <= 255 => BString255(c),
            <= 65535 => BString65535(c),
            <= 4294967295 => BString4294967295(c),
            <= kMaxInt => BString(c),
            _ => throw Exception('Invalid string length: ${c.length}'),
          };
        }

        if (c is bool) {
          return BBool(c);
        }

        throw Exception('Invalid type: $c');
      });

      final byteLength = chunks.fold<int>(0, (p, c) => p + c.$byteLength) +
          chunks.length * tid.$byteLength;

      var cursor = 0;
      final byteList = Uint8List(byteLength);

      for (final chunk in chunks) {
        chunk.$tid.writeTo(byteList.buffer.asByteData(cursor, tid.$byteLength));
        cursor += tid.$byteLength;
        chunk.writeTo(byteList.buffer.asByteData(cursor, chunk.$byteLength));
        cursor += chunk.$byteLength;
      }

      cursor = 0;
      List decoded = [];

      while (cursor < byteList.lengthInBytes) {
        final $tid = tid.read(
          byteList.buffer.asByteData(cursor, tid.$byteLength),
        );

        cursor += tid.$byteLength;

        switch ($tid.value) {
          case 1:
            final chunk = BUint8.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 2:
            final chunk = BUint16.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 3:
            final chunk = BUint32.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 4:
            final chunk = BUint64.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 5:
            final chunk = BInt8.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 6:
            final chunk = BInt16.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 7:
            final chunk = BInt32.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 8:
            final chunk = BInt64.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 9:
            final chunk = BFloat32.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 10:
            final chunk = BFloat64.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 11:
            final chunk = BBool.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          case 12:
            final chunk = BString255.read(byteList.buffer.asByteData(cursor));
            cursor += chunk.$byteLength;
            decoded.add(chunk.content);

          default:
            throw Exception('Invalid TID: $tid');
        }
      }

      expect(decoded, initial);
      print('binary size: ${byteList.lengthInBytes}');
      print('json size: ${jsonEncode(initial).length}');
    });
  });
}
