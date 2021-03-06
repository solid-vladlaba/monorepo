import 'package:ci_integration/destination/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/destination/firestore/config/parser/firestore_destination_config_parser.dart';
import 'package:ci_integration/destination/firestore/party/firestore_destination_party.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationParty", () {
    final firestoreDestinationParty = FirestoreDestinationParty();

    test(
      "should use FirestoreDestinationClientFactory as a client factory",
      () {
        final clientFactory = firestoreDestinationParty.clientFactory;

        expect(clientFactory, isA<FirestoreDestinationClientFactory>());
      },
    );

    test("should use FirestoreConfigParser as a config parser", () {
      final configParser = firestoreDestinationParty.configParser;

      expect(configParser, isA<FirestoreDestinationConfigParser>());
    });
  });
}
