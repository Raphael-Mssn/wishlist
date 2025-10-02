class Profile {
  Profile({
    required this.id,
    required this.pseudo,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      pseudo: json['pseudo'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  final String id;
  final String pseudo;
  final String? avatarUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pseudo': pseudo,
      'avatar_url': avatarUrl,
    };
  }
}
