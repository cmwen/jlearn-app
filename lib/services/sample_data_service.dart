/// Service for initializing sample data (currently empty)
/// This was previously used to populate sample vocabulary on first run
/// but has been removed to start with a clean slate
class SampleDataService {
  /// Initialize sample data (currently does nothing)
  /// This method is kept for backward compatibility
  Future<void> initializeSampleData() async {
    // No sample data is loaded anymore
    // Users should generate their own content using LLM integration
  }
}
