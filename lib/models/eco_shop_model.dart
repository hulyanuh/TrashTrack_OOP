class EcoShop {
  final String shopId;
  final String shopName;
  final String shopCategory;
  final String shopLink;
  final String imageUrl;
  final String contactNum;

  EcoShop({
    required this.shopId,
    required this.shopName,
    required this.shopCategory,
    required this.shopLink,
    required this.imageUrl,
    required this.contactNum,
  });

  factory EcoShop.fromJson(Map<String, dynamic> json) {
    return EcoShop(
      shopId: json['shop_id'],
      shopName: json['shop_name'],
      shopCategory: json['shop_category'],
      shopLink: json['shop_link'],
      imageUrl: json['image_url'],
      contactNum: json['contact_num'],
    );
  }
}