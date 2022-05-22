class store {
  final String store_id;
  final String store_name;
  final String store_description;
  final String store_image;
  final String store_cat;
  final String store_number;

  store({required this.store_id,required this.store_name,required this.store_description
    ,required this.store_image,required this.store_cat,required this.store_number});

  factory store.fromJson(Map<String, dynamic> json) {
    return store(
      store_id: json['store_id'],
      store_name: json['store_name'],
      store_description: json['store_description'],
      store_image: json['store_image'],
      store_cat: json['cat'],
      store_number: json['phone_number']
    );
  }

}