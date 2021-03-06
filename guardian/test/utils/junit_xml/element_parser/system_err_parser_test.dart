import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('SystemErrParser', () {
    const text = 'Error output';

    final parser = SystemErrParser();

    XmlElement element;

    setUpAll(() {
      element = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.textNodeXml('system-err', text),
      );
    });

    test('mapElement() should map <system-err> element', () {
      const expected = JUnitSystemErrData(text: text);

      final result = parser.mapElement(element);

      expect(result, equals(expected));
    });
  });
}
