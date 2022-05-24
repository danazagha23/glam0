class MyBanner {

  final String imageCode;

  MyBanner({required this.imageCode});

  factory MyBanner.fromJson(Map<String, dynamic> json) {
    return MyBanner(
      imageCode: json['image_code'] as String,
    );
  }

}