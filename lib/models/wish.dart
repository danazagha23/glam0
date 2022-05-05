class wish {
  final String product_id;
  final String cust_id;
  final String prd_name;
  final String prd_price;
  final String prd_image;
  final String prd_description;
  final String date;

  wish({required this.cust_id,required this.product_id,required this.prd_name,
    required this.prd_price,required this.prd_image,required this.prd_description
    ,required this.date});

  factory wish.fromJson(Map<String, dynamic> json) {
    return wish(
        cust_id: json['cust_id'],
        product_id: json['prd_id'],
        prd_name: json['prd_name'],
        prd_price: json['prd_price'],
        prd_image: json['prd_image'],
        prd_description: json['prd_description'],
        date: json['prd_date']
    );
  }

}