// * This is like post.dart

class NewListing {
  final String make;
  final String model;
  final String year;
  final int odometer;
  final int price;

  NewListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
  });

  factory NewListing.fromJson(Map<String, dynamic> json) => NewListing(
        make: json['make'],
        model: json['model'],
        year: json['year'],
        odometer: json['odometer'],
        price: json['price'],
      );
}
