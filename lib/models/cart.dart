class cart {
  final String product_id;
  final String cust_id;
  final String prd_name;
  final String prd_price;
  final String prd_image;
  final String prd_description;
  final String quantity;
  final String color;
  final String size;
  final String date;

  cart({required this.cust_id,required this.product_id,required this.prd_name,
    required this.prd_price,required this.prd_image,required this.prd_description,
    required this.quantity,required this.color,
    required this.size,required this.date});

  factory cart.fromJson(Map<String, dynamic> json) {
    return cart(
        cust_id: json['cust_id'],
        product_id: json['product_id'],
        prd_name: json['prd_name'],
        prd_price: json['prd_price'],
        prd_image: json['image_id'],
        prd_description: json['prd_description'],
        quantity: json['quantity'],
        color: json['color'],
        size: json['size'],
        date: json['prd_date']
    );
  }

}