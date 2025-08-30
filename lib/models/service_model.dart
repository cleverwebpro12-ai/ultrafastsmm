// service_model.dart
class Service {
  final String serviceId; // Change 'id' to 'serviceId'
  final String name;
  final String category;
  final double rate;
  final int min;
  final int max;

  Service.fromJson(Map<String, dynamic> json)
    : serviceId = json['service'], // Map JSON 'service' to 'serviceId'
      name = json['name'],
      category = json['category'],
      rate = double.parse(json['rate']),
      min = int.parse(json['min']),
      max = int.parse(json['max']);
}
