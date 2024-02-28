class Character {
  final String name;
  final String gender;
  final String image;

  Character({required this.name, required this.gender, required this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      gender: json['gender'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'image': image,
    };
  }
}
