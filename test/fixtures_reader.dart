import 'dart:convert';
import 'dart:io';

String _fixture(String name, String path) => File('$path$name').readAsStringSync();

extension Fixture on String {
  Map<String, dynamic> toFixture({String path = 'test/fixtures/'}) =>
      json.decode(_fixture(this, path)) as Map<String, dynamic>;
}
