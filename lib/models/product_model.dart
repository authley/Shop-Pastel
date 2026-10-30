// Model hasil mapping response https://dummyjson.com/products

double _d(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
int _i(dynamic v, [int def = 0]) => (v as num?)?.toInt() ?? def;

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({this.width = 0, this.height = 0, this.depth = 0});

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        width: _d(json['width']),
        height: _d(json['height']),
        depth: _d(json['depth']),
      );
}

class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    this.rating = 0,
    this.comment = '',
    this.date = '',
    this.reviewerName = '',
    this.reviewerEmail = '',
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: _i(json['rating']),
        comment: json['comment']?.toString() ?? '',
        date: json['date']?.toString() ?? '',
        reviewerName: json['reviewerName']?.toString() ?? '',
        reviewerEmail: json['reviewerEmail']?.toString() ?? '',
      );
}

class Meta {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  Meta({
    this.createdAt = '',
    this.updatedAt = '',
    this.barcode = '',
    this.qrCode = '',
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
        barcode: json['barcode']?.toString() ?? '',
        qrCode: json['qrCode']?.toString() ?? '',
      );
}

class Category {
  final String slug;
  final String name;
  final String url;

  Category({required this.slug, required this.name, required this.url});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        slug: json['slug']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
      );
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.price = 0,
    this.discountPercentage = 0,
    this.rating = 0,
    this.stock = 0,
    this.tags = const [],
    this.brand = '',
    this.sku = '',
    this.weight = 0,
    Dimensions? dimensions,
    this.warrantyInformation = '',
    this.shippingInformation = '',
    this.availabilityStatus = '',
    this.reviews = const [],
    this.returnPolicy = '',
    this.minimumOrderQuantity = 1,
    Meta? meta,
    this.thumbnail = '',
    this.images = const [],
  })  : dimensions = dimensions ?? Dimensions(),
        meta = meta ?? Meta();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _i(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: _d(json['price']),
      discountPercentage: _d(json['discountPercentage']),
      rating: _d(json['rating']),
      stock: _i(json['stock']),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      brand: json['brand']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      weight: _d(json['weight']),
      dimensions: Dimensions.fromJson(
          (json['dimensions'] as Map?)?.cast<String, dynamic>() ?? {}),
      warrantyInformation: json['warrantyInformation']?.toString() ?? '',
      shippingInformation: json['shippingInformation']?.toString() ?? '',
      availabilityStatus: json['availabilityStatus']?.toString() ?? '',
      reviews: (json['reviews'] as List?)
              ?.map((e) => Review.fromJson((e as Map).cast<String, dynamic>()))
              .toList() ??
          [],
      returnPolicy: json['returnPolicy']?.toString() ?? '',
      minimumOrderQuantity: _i(json['minimumOrderQuantity'], 1),
      meta: Meta.fromJson((json['meta'] as Map?)?.cast<String, dynamic>() ?? {}),
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class ProductsResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['products'] as List?) ?? [];
    return ProductsResponse(
      products: list
          .map((e) => Product.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      total: _i(json['total'], list.length),
      skip: _i(json['skip']),
      limit: _i(json['limit']),
    );
  }
}
