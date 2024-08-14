class Profile {
  Profile({
    required this.id,
    required this.pseudo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      pseudo: json['pseudo'] as String,
    );
  }

  final String id;
  final String pseudo;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pseudo': pseudo,
    };
  }
}
