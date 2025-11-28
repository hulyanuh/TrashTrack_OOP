class UserPoints {
  final int points;

  UserPoints({required this.points});

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(points: json['user_points'] ?? 0);
  }
}
