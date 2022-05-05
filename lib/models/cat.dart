class cat {
  final String cat_id;
  final String cat_name;
  final String cat_description;
  final String cat_image;

  cat({required this.cat_id,required this.cat_name,required this.cat_description,required this.cat_image});

  factory cat.fromJson(Map<String, dynamic> json) {
    return cat(
      cat_id: json['cat_id'],
      cat_name: json['cat_name'],
      cat_description: json['cat_description'],
      cat_image: json['cat_image'],
    );
  }

}