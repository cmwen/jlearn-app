import 'package:flutter_test/flutter_test.dart';
import 'package:jlearn/services/sample_data_service.dart';

void main() {
  group('Sample Data Service', () {
    late SampleDataService service;

    setUp(() {
      service = SampleDataService();
    });

    test('initializeSampleData completes without errors', () async {
      // Should complete without errors and without loading any data
      await expectLater(
        service.initializeSampleData(),
        completes,
      );
    });

    test('initializeSampleData returns immediately', () async {
      final stopwatch = Stopwatch()..start();
      await service.initializeSampleData();
      stopwatch.stop();

      // Should be very fast since it does nothing
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
