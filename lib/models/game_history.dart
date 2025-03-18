class GameHistory {
  final String gameId;
  final DateTime playedAt;

  GameHistory({
    required this.gameId,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory GameHistory.fromMap(Map<String, dynamic> map) {
    return GameHistory(
      gameId: map['gameId'],
      playedAt: DateTime.parse(map['playedAt']),
    );
  }
} 