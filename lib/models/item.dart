class item {
  final String prd_id;
  final String prd_name;
  final String prd_price;
  final String prd_image;
  final String prd_description;
  final String prd_quantity;
  final String prd_color;
  final String prd_size;
  final String prd_date;
  final String cat_id;

  item({required this.prd_id,required this.prd_name,required this.prd_price,required this.prd_image,
    required this.prd_description,required this.prd_quantity,required this.prd_color,required this.prd_size,required this.prd_date,required this.cat_id});

  factory item.fromJson(Map<String, dynamic> json) {
    return item(
      prd_id: json['prd_id'],
      prd_name: json['prd_name'],
      prd_price: json['prd_price'],
      prd_image: json['prd_image'],
      prd_description: json['prd_description'],
      prd_quantity: json['prd_quantity'],
        prd_color: json['colors'],
        prd_size: json['sizes'],
      prd_date: json['prd_date'],
      cat_id: json['prd_cat_id']
    );
  }

}