import 'dart:io';

import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/cli/parties/supported_destination_parties.dart';
import 'package:ci_integration/cli/parties/supported_integration_parties.dart';
import 'package:ci_integration/cli/parties/supported_source_parties.dart';
import 'package:ci_integration/destination/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/destination/firestore/config/parser/firestore_destination_config_parser.dart';
import 'package:ci_integration/destination/firestore/party/firestore_destination_party.dart';
import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';
import 'package:ci_integration/source/jenkins/party/jenkins_source_party.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:firedart/firedart.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/mock/mocks.dart';
import '../test_util/stub/logger_stub.dart';
import '../test_util/test_data/config_test_data.dart';

void main() {
  group(
    "SyncCommand",
    () {
      const configFileContent = ConfigTestData.configFileContent;
      final syncConfig = ConfigTestData.syncConfig;
      final integrationConfig = ConfigTestData.integrationConfig;

      final supportedSourceParties = SupportedSourceParties();
      final supportedDestinationParties = SupportedDestinationParties();

      final fileMock = FileMock();
      final _firebaseAuthMock = _FirebaseAuthMock();
      final ciIntegrationMock = _CiIntegrationMock();
      final sourceClientMock = SourceClientMock();
      final destinationClientMock = DestinationClientMock();
      final sourcePartiesMock = PartiesMock<SourceParty>();
      final destinationPartiesMock = PartiesMock<DestinationParty>();

      final loggerStub = LoggerStub();
      final syncCommand = SyncCommandStub(
        loggerStub,
        SupportedIntegrationParties(
          sourceParties: sourcePartiesMock,
          destinationParties: destinationPartiesMock,
        ),
        fileMock,
        ciIntegrationMock,
      );

      setUp(() {
        loggerStub.clearLogs();
        syncCommand.reset();
        reset(fileMock);
        reset(ciIntegrationMock);
        reset(sourceClientMock);
        reset(destinationClientMock);
        reset(sourcePartiesMock);
        reset(destinationPartiesMock);
        reset(_firebaseAuthMock);
      });

      PostExpectation<Future<InteractionResult>> whenRunSync() {
        when(sourcePartiesMock.parties)
            .thenReturn(supportedSourceParties.parties);
        when(destinationPartiesMock.parties)
            .thenReturn([_FirestoreDestinationPartyStub(_firebaseAuthMock)]);
        when(_firebaseAuthMock.signIn(any, any))
            .thenAnswer((_) => Future.value(User.fromMap({})));
        when(fileMock.existsSync()).thenReturn(true);
        when(fileMock.readAsStringSync()).thenReturn(configFileContent);
        return when(ciIntegrationMock.sync(syncConfig));
      }

      test("should have the 'config-file' option", () {
        final argParser = syncCommand.argParser;
        final options = argParser.options;

        expect(options, contains('config-file'));
      });

      test("has the command name equal to 'sync'", () {
        final name = syncCommand.name;

        expect(name, equals('sync'));
      });

      test("has a non-empty description", () {
        final description = syncCommand.description;

        expect(description, isNotEmpty);
      });

      test(
        ".parseConfigFileContent() parses the config file content",
        () {
          final expected = integrationConfig;
          when(fileMock.readAsStringSync()).thenReturn(configFileContent);

          final result = syncCommand.parseConfigFileContent(fileMock);

          expect(result, equals(expected));
        },
      );

      test(
        ".getParty() throws an UnimplementedError if the given parties are empty",
        () {
          when(sourcePartiesMock.parties).thenReturn([]);

          expect(
            () => syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              sourcePartiesMock,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() throws an UnimplementedError if the given parties do not contain an appropriate party",
        () {
          final parties = supportedDestinationParties;

          expect(
            () => syncCommand.getParty(
              integrationConfig.sourceConfigMap,
              parties,
            ),
            throwsUnimplementedError,
          );
        },
      );

      test(
        ".getParty() returns the appropriate party instance for the given config map",
        () {
          final parties = supportedSourceParties;

          final result = syncCommand.getParty(
            integrationConfig.sourceConfigMap,
            parties,
          );

          expect(result, isA<JenkinsSourceParty>());
        },
      );

      test(
        ".parseConfig() returns null if the given party cannot parse the given config",
        () {
          final party = JenkinsSourceParty();

          final result = syncCommand.parseConfig(
            integrationConfig.destinationConfigMap,
            party,
          );

          expect(result, isNull);
        },
      );

      test(
        ".parseConfig() returns the SourceConfig instance matching the given source config map",
        () {
          final party = JenkinsSourceParty();
          final jenkinsConfig = ConfigTestData.jenkinsSourceConfig;

          final result = syncCommand.parseConfig(
            ConfigTestData.integrationConfig.sourceConfigMap,
            party,
          );

          expect(result, equals(jenkinsConfig));
        },
      );

      test(
        ".parseConfig() returns the DestinationConfig instance matching the given destination config map",
        () {
          final party = FirestoreDestinationParty();
          final firestoreConfig = ConfigTestData.firestoreConfig;

          final result = syncCommand.parseConfig(
            ConfigTestData.integrationConfig.destinationConfigMap,
            party,
          );

          expect(result, equals(firestoreConfig));
        },
      );

      test(
        ".run() logs an error if the given config file does not exist",
        () async {
          when(fileMock.existsSync()).thenReturn(false);

          await syncCommand.run();

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".run() does not run sync if the given config file does not exist",
        () async {
          when(fileMock.existsSync()).thenReturn(false);

          await syncCommand.run();

          verifyNever(ciIntegrationMock.sync(any));
        },
      );

      test(".run() calls dispose once", () async {
        whenRunSync().thenAnswer((_) => Future.value(any));

        await syncCommand.run();

        expect(syncCommand.disposeCallCount, equals(1));
      });

      test(".run() calls dispose once if sync throws", () async {
        whenRunSync().thenThrow(Exception());

        await syncCommand.run();

        expect(syncCommand.disposeCallCount, equals(1));
      });

      test(".run() logs an error if sync throws", () async {
        when(destinationPartiesMock.parties).thenReturn([]);
        whenRunSync().thenThrow(Exception());

        await syncCommand.run();

        expect(loggerStub.errorLogsNumber, equals(1));
      });

      test(
        ".run() runs sync on the given config",
        () async {
          whenRunSync().thenAnswer((_) => Future.value(any));

          await syncCommand.run();

          verify(ciIntegrationMock.sync(syncConfig)).called(1);
        },
      );

      test(
        ".sync() prints a message if a sync result is a success",
        () async {
          const interactionResult = InteractionResult.success();

          when(ciIntegrationMock.sync(syncConfig))
              .thenAnswer((_) => Future.value(interactionResult));

          await syncCommand.sync(
            syncConfig,
            sourceClientMock,
            destinationClientMock,
          );

          expect(loggerStub.messageLogsNumber, equals(1));
        },
      );

      test(
        ".sync() prints an error message if a sync result is an error",
        () async {
          const interactionResult = InteractionResult.error();

          when(ciIntegrationMock.sync(syncConfig))
              .thenAnswer((_) => Future.value(interactionResult));

          await syncCommand.sync(
            syncConfig,
            sourceClientMock,
            destinationClientMock,
          );

          expect(loggerStub.errorLogsNumber, equals(1));
        },
      );

      test(
        ".dispose() disposes the given source client",
        () async {
          final syncCommand = SyncCommand(loggerStub);

          await syncCommand.dispose(
            sourceClientMock,
            destinationClientMock,
          );

          verify(sourceClientMock.dispose()).called(1);
        },
      );

      test(
        ".dispose() disposes the given destination client",
        () async {
          final syncCommand = SyncCommand(loggerStub);

          await syncCommand.dispose(
            sourceClientMock,
            destinationClientMock,
          );

          verify(destinationClientMock.dispose()).called(1);
        },
      );
    },
  );
}

class _CiIntegrationMock extends Mock implements CiIntegration {}

class _FirebaseAuthMock extends Mock implements FirebaseAuth {}

/// A stub class for a [FirestoreDestinationParty] class providing test
/// implementation for fields.
class _FirestoreDestinationPartyStub implements FirestoreDestinationParty {
  final FirebaseAuth firebaseAuth;

  @override
  final FirestoreDestinationClientFactory clientFactory;

  @override
  final FirestoreDestinationConfigParser configParser =
      const FirestoreDestinationConfigParser();

  /// Creates this stub class with the given [firebaseAuth] that is used to create
  /// [FirestoreDestinationClientFactory] allowing to mock authentication related
  /// functionality.
  _FirestoreDestinationPartyStub(this.firebaseAuth)
      : clientFactory = FirestoreDestinationClientFactory(firebaseAuth);
}

/// A stub class for a [SyncCommand] class providing test implementation for
/// methods.
class SyncCommandStub extends SyncCommand {
  /// A config file mock to use for testing purposes.
  final FileMock fileMock;

  /// A CI integration mock to use for testing purposes.
  final _CiIntegrationMock ciIntegrationMock;

  /// A counter used to save the number of times the [dispose] method called.
  int _disposeCallCount = 0;

  int get disposeCallCount => _disposeCallCount;

  SyncCommandStub(
    Logger logger,
    SupportedIntegrationParties supportedParties,
    this.fileMock,
    this.ciIntegrationMock,
  ) : super(logger, supportedParties: supportedParties);

  /// Resets this stub to ensure tests run independently.
  void reset() {
    _disposeCallCount = 0;
  }

  @override
  File getConfigFile(String configFilePath) {
    return fileMock;
  }

  @override
  CiIntegration createCiIntegration(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) {
    return ciIntegrationMock;
  }

  @override
  dynamic getArgumentValue(String name) {
    return 'config.yaml';
  }

  @override
  Future<void> dispose(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    _disposeCallCount += 1;
  }
}
