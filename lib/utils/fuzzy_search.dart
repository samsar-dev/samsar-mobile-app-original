import 'dart:math';

class FuzzySearch {
  /// Calculate Levenshtein distance between two strings
  static int levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    // Initialize first row and column
    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    // Fill the matrix
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1].toLowerCase() == s2[j - 1].toLowerCase() ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce(min);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Calculate similarity score between two strings (0.0 to 1.0)
  static double similarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final maxLength = max(s1.length, s2.length);
    final distance = levenshteinDistance(s1, s2);
    return 1.0 - (distance / maxLength);
  }

  /// Check if query matches text with fuzzy logic
  static bool fuzzyMatch(String query, String text, {double threshold = 0.6}) {
    if (query.isEmpty) return true;
    if (text.isEmpty) return false;

    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();

    // Exact match
    if (textLower.contains(queryLower)) return true;

    // Check if query words match text words
    final queryWords = queryLower
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final textWords = textLower.split(' ').where((w) => w.isNotEmpty).toList();

    for (final queryWord in queryWords) {
      bool wordMatched = false;

      for (final textWord in textWords) {
        // Direct substring match
        if (textWord.contains(queryWord)) {
          wordMatched = true;
          break;
        }

        // Fuzzy match for individual words
        if (similarity(queryWord, textWord) >= threshold) {
          wordMatched = true;
          break;
        }

        // Check if query word is a substring of text word with typos
        if (queryWord.length >= 3 && textWord.length >= 3) {
          final sim = similarity(queryWord, textWord);
          if (sim >= threshold) {
            wordMatched = true;
            break;
          }
        }
      }

      if (!wordMatched) return false;
    }

    return true;
  }

  /// Get similarity score for ranking search results
  static double getRelevanceScore(
    String query,
    String title,
    String description,
  ) {
    if (query.isEmpty) return 0.0;

    final queryLower = query.toLowerCase();
    final titleLower = title.toLowerCase();
    final descLower = description.toLowerCase();

    double score = 0.0;

    // Exact matches get highest score
    if (titleLower.contains(queryLower)) {
      score += 1.0;
    } else if (descLower.contains(queryLower)) {
      score += 0.8;
    }

    // Fuzzy matching for individual words
    final queryWords = queryLower
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final titleWords = titleLower
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final descWords = descLower.split(' ').where((w) => w.isNotEmpty).toList();

    for (final queryWord in queryWords) {
      double bestTitleMatch = 0.0;
      double bestDescMatch = 0.0;

      // Check title words
      for (final titleWord in titleWords) {
        final sim = similarity(queryWord, titleWord);
        bestTitleMatch = max(bestTitleMatch, sim);
      }

      // Check description words
      for (final descWord in descWords) {
        final sim = similarity(queryWord, descWord);
        bestDescMatch = max(bestDescMatch, sim);
      }

      // Add weighted scores
      score += bestTitleMatch * 0.8; // Title matches are more important
      score += bestDescMatch * 0.4; // Description matches are less important
    }

    return score / queryWords.length; // Normalize by number of query words
  }

  /// Extract search suggestions from a list of items
  static List<String> generateSuggestions(
    String query,
    List<String> allTexts, {
    int maxSuggestions = 5,
    double threshold = 0.3,
  }) {
    if (query.isEmpty || query.length < 2) return [];

    final suggestions = <String, double>{};
    final queryLower = query.toLowerCase();

    for (final text in allTexts) {
      final textLower = text.toLowerCase();

      // Skip if already exact match
      if (textLower == queryLower) continue;

      // Check for partial matches and fuzzy matches
      final words = textLower.split(' ').where((w) => w.isNotEmpty).toList();

      for (final word in words) {
        if (word.startsWith(queryLower)) {
          suggestions[word] = 1.0;
        } else if (word.contains(queryLower)) {
          suggestions[word] = 0.8;
        } else {
          final sim = similarity(queryLower, word);
          if (sim >= threshold) {
            suggestions[word] = sim;
          }
        }
      }
    }

    // Sort by relevance and return top suggestions
    final sortedSuggestions = suggestions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedSuggestions.take(maxSuggestions).map((e) => e.key).toList();
  }
}
