// * This is like post.dart

class Listing {
  Listing({
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.odometer,
  });

  Listing.fromJson(Map<String, Object?> json)
      : this(
            make: json['make'] as String,
            model: json['model'] as String,
            year: json['year'] as int,
            price: json['price'] as int,
            odometer: json['odometer'] as int);
  String make;
  String model;
  int year;
  int price;
  int odometer;

  Map<String, Object?> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'odometer': odometer,
    };
  }
}
