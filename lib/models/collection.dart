class Collection {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Collection({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
