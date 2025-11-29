import 'package:flutter/material.dart';
import '../models/vocabulary_item.dart';
import '../models/review_record.dart';
import '../models/srs_card.dart';
import '../models/weak_point.dart';
import '../services/ml/sm2_algorithm.dart';
import '../services/ml/weak_point_detector.dart';
import '../data/database/app_database.dart';
import '../data/repositories/learning_repository.dart';
import 'dart:math';

class MLPoCScreen extends StatefulWidget {
  const MLPoCScreen({super.key});

  @override
  State<MLPoCScreen> createState() => _MLPoCScreenState();
}

class _MLPoCScreenState extends State<MLPoCScreen> {
  final _repository = LearningRepository(AppDatabase.instance);
  final _sm2 = SM2Algorithm();
  final _weakPointDetector = WeakPointDetector();
  
  List<VocabularyItem> _vocabulary = [];
  List<ReviewRecord> _reviews = [];
  List<WeakPoint> _weakPoints = [];
  Map<String, dynamic>? _insights;
  SRSCard? _currentCard;
  VocabularyItem? _currentVocab;
  bool _isLoading = true;
  Map<String, int> _stats = {};
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    _vocabulary = await _repository.getAllVocabulary();
    _reviews = await _repository.getRecentReviews(1000);
    _stats = await _repository.getStatistics();
    
    _weakPoints = _weakPointDetector.detectWeakPoints(_vocabulary, _reviews);
    _insights = _weakPointDetector.generateInsights(_weakPoints);
    
    await _loadNextCard();
    
    setState(() => _isLoading = false);
  }

  Future<void> _loadNextCard() async {
    final dueCards = await _repository.getDueCards();
    
    if (dueCards.isNotEmpty) {
      _currentCard = dueCards.first;
      _currentVocab = await _repository.getVocabularyById(_currentCard!.vocabularyId);
    } else if (_vocabulary.isNotEmpty) {
      final randomVocab = _vocabulary[Random().nextInt(_vocabulary.length)];
      _currentCard = await _repository.getOrCreateSRSCard(randomVocab.id);
      _currentVocab = randomVocab;
    }
  }

  Future<void> _submitReview(int quality) async {
    if (_currentCard == null || _currentVocab == null) return;
    
    final responseTime = Random().nextInt(3000) + 2000;
    
    final updatedCard = _sm2.updateCard(_currentCard!, quality, responseTimeMs: responseTime);
    await _repository.saveSRSCard(updatedCard);
    
    final record = ReviewRecord(
      id: 0,
      vocabularyId: _currentCard!.vocabularyId,
      reviewDate: DateTime.now(),
      quality: quality,
      repetitionNumber: updatedCard.repetitionNumber,
      easinessFactor: updatedCard.easinessFactor,
      intervalDays: updatedCard.intervalDays,
      nextReviewDate: updatedCard.nextReviewDate,
      responseTimeMs: responseTime,
    );
    
    await _repository.saveReviewRecord(record);
    
    await _loadData();
  }

  Future<void> _generateSampleReviews() async {
    final random = Random();
    
    for (final vocab in _vocabulary) {
      final card = await _repository.getOrCreateSRSCard(vocab.id);
      
      final reviewCount = random.nextInt(5) + 3;
      
      var currentCard = card;
      for (var i = 0; i < reviewCount; i++) {
        int quality;
        if (vocab.category == 'verbs' && random.nextDouble() < 0.6) {
          quality = random.nextInt(3);
        } else if (vocab.category == 'adjectives' && random.nextDouble() < 0.4) {
          quality = random.nextInt(3);
        } else {
          quality = random.nextInt(3) + 3;
        }
        
        final responseTime = random.nextInt(5000) + 1000;
        
        currentCard = _sm2.updateCard(currentCard, quality, responseTimeMs: responseTime);
        
        final record = ReviewRecord(
          id: 0,
          vocabularyId: vocab.id,
          reviewDate: DateTime.now().subtract(Duration(days: reviewCount - i)),
          quality: quality,
          repetitionNumber: currentCard.repetitionNumber,
          easinessFactor: currentCard.easinessFactor,
          intervalDays: currentCard.intervalDays,
          nextReviewDate: currentCard.nextReviewDate,
          responseTimeMs: responseTime,
        );
        
        await _repository.saveReviewRecord(record);
      }
      
      await _repository.saveSRSCard(currentCard);
    }
    
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML POC - SRS & Weak Point Detection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  _buildCurrentCardSection(),
                  const SizedBox(height: 16),
                  _buildWeakPointsSection(),
                  const SizedBox(height: 16),
                  _buildInsightsSection(),
                  const SizedBox(height: 16),
                  _buildActionsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Words', _stats['totalVocabulary'] ?? 0),
                _buildStatItem('Reviews', _stats['totalReviews'] ?? 0),
                _buildStatItem('Due Now', _stats['dueCards'] ?? 0),
                _buildStatItem('Mastered', _stats['masteredCards'] ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCurrentCardSection() {
    if (_currentVocab == null || _currentCard == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No cards to review!'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Review', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    _currentVocab!.word,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _currentVocab!.reading,
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentVocab!.meaning,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('SRS Info:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSRSInfo(),
            const SizedBox(height: 16),
            Text('Rate your recall:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQualityButton(0, 'Total Blackout', Colors.red[900]!),
                _buildQualityButton(1, 'Wrong', Colors.red),
                _buildQualityButton(2, 'Hard', Colors.orange),
                _buildQualityButton(3, 'Good', Colors.lightGreen),
                _buildQualityButton(4, 'Easy', Colors.green),
                _buildQualityButton(5, 'Perfect', Colors.green[700]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSRSInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repetitions: ${_currentCard!.repetitionNumber}'),
        Text('Easiness: ${_currentCard!.easinessFactor.toStringAsFixed(2)}'),
        Text('Interval: ${_currentCard!.intervalDays} days'),
        Text('Consecutive Correct: ${_currentCard!.consecutiveCorrect}'),
        Text('Consecutive Incorrect: ${_currentCard!.consecutiveIncorrect}'),
        Text('Average Quality: ${_currentCard!.averageQuality.toStringAsFixed(2)}'),
        Text('Total Reviews: ${_currentCard!.totalReviews}'),
      ],
    );
  }

  Widget _buildQualityButton(int quality, String label, Color color) {
    return ElevatedButton(
      onPressed: () => _submitReview(quality),
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text('$quality\n$label', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildWeakPointsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weak Points Detected (${_weakPoints.length})', 
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (_weakPoints.isEmpty)
              const Text('No weak points detected yet. Great job!')
            else
              ..._weakPoints.take(5).map((wp) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildWeakPointItem(wp),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildWeakPointItem(WeakPoint wp) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSeverityColor(wp.severity).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getSeverityColor(wp.severity)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${wp.category} (JLPT N${wp.jlptLevel})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(wp.severity),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Severity: ${(wp.severity * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Error Rate: ${(wp.errorRate * 100).toStringAsFixed(1)}%'),
          Text('Total Attempts: ${wp.totalAttempts}'),
          Text('Failed: ${wp.failedAttempts}'),
          Text('Avg Response Time: ${(wp.averageResponseTime / 1000).toStringAsFixed(1)}s'),
          Text('Struggling Words: ${wp.strugglingVocabularyIds.length}'),
        ],
      ),
    );
  }

  Color _getSeverityColor(double severity) {
    if (severity >= 0.7) return Colors.red;
    if (severity >= 0.5) return Colors.orange;
    return Colors.yellow[700]!;
  }

  Widget _buildInsightsSection() {
    if (_insights == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Insights', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Overall Status: ${_insights!['overallStatus']}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if ((_insights!['weakCategories'] as List).isNotEmpty) ...[
              const Text('Weak Categories:'),
              ...(_insights!['weakCategories'] as List).map((cat) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('• $cat'),
                  )),
              const SizedBox(height: 8),
            ],
            const Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...(_insights!['recommendations'] as List).map((rec) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• $rec'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _generateSampleReviews,
              icon: const Icon(Icons.science),
              label: const Text('Generate Sample Review Data'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Analysis'),
            ),
          ],
        ),
      ),
    );
  }
}
