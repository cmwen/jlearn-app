import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  TtsService._internal();

  /// Alias for initialize() for compatibility
  Future<void> init() => initialize();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage("ja-JP");
      await _flutterTts.setSpeechRate(0.4);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isInitialized = true;
    } catch (e) {
      // print('TTS initialization error: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      // print('TTS speak error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      // print('TTS stop error: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    // Convert ISO 639-1 codes to TTS locale codes
    final ttsLocale = _getLocaleForLanguage(language);
    try {
      await _flutterTts.setLanguage(ttsLocale);
    } catch (e) {
      // print('TTS setLanguage error: $e');
    }
  }

  /// Map language codes to TTS locale codes
  String _getLocaleForLanguage(String language) {
    const localeMap = {
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh': 'zh-CN',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
      'th': 'th-TH',
      'vi': 'vi-VN',
    };
    return localeMap[language] ?? language;
  }

  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      // print('TTS setSpeechRate error: $e');
    }
  }

  Future<List<dynamic>> getLanguages() async {
    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      // print('TTS getLanguages error: $e');
      return [];
    }
  }

  Future<bool> isLanguageAvailable(String language) async {
    try {
      final languages = await getLanguages();
      return languages.contains(language);
    } catch (e) {
      // print('TTS isLanguageAvailable error: $e');
      return false;
    }
  }
}
