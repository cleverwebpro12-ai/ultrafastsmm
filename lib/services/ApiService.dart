// ApiService.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = "https://cors-smmpanel.vercel.app/api";
  final String _apiKey = "7059e8eb31bad8791069713a07b5724f";

  // Fetch list of services
  Future<List<dynamic>> fetchServices() async {
    final response = await http.get(
      Uri.parse("$_baseUrl?key=$_apiKey&action=services"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load services");
    }
  }

  // Place an order
  Future<int> placeOrder({
    required int serviceId,
    required String link,
    required int quantity,
  }) async {
    try {
      // Debug: Print the request body before sending
      print(
        'Request Body - Service ID: $serviceId (Type: ${serviceId.runtimeType}), Link: $link, Quantity: $quantity (Type: ${quantity.runtimeType})',
      );

      final response = await http.post(
        Uri.parse("$_baseUrl?key=$_apiKey&action=add"),
        body: {
          "service": serviceId.toString(), // Convert serviceId to string
          "link": link,
          "quantity": quantity.toString(), // Convert quantity to string
        },
      );

      // Debug: Print the API response
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Debug: Print the decoded response data
        print('Decoded Response Data: $data');

        // Check if the response contains an error
        if (data.containsKey("error")) {
          throw Exception(
            data["error"],
          ); // Throw the error message from the API
        }

        // Ensure the response contains an order ID
        if (data["order"] == null) {
          throw Exception("Order ID not found in the response");
        }

        // Return the order ID
        return data["order"] as int;
      } else {
        throw Exception("Failed to place order: ${response.statusCode}");
      }
    } catch (e) {
      // Debug: Print the error
      print('Error in placeOrder: $e');
      throw Exception("Failed to place order: $e");
    }
  }

  // Check order status
  Future<Map<String, dynamic>> checkOrderStatus(int orderId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl?key=$_apiKey&action=status&order=$orderId"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch order status");
    }
  }

  // Check multiple orders status
  Future<Map<int, dynamic>> checkMultipleOrdersStatus(
    List<int> orderIds,
  ) async {
    final ordersParam = orderIds.join(",");
    final response = await http.get(
      Uri.parse("$_baseUrl?key=$_apiKey&action=status&orders=$ordersParam"),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map<int, dynamic>((key, value) {
        return MapEntry(int.parse(key), value);
      });
    } else {
      throw Exception("Failed to fetch multiple orders status");
    }
  }

  // Create refill
  Future<Map<String, dynamic>> createRefill(int orderId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?key=$_apiKey&action=refill"),
      body: {"order": orderId.toString()},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to create refill");
    }
  }

  // Create multiple refills
  Future<List<Map<String, dynamic>>> createMultipleRefills(
    List<Map<String, int>> refills,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?key=$_apiKey&action=refill"),
      body: json.encode(refills),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to create multiple refills");
    }
  }

  // Get refill status
  Future<Map<String, dynamic>> getRefillStatus(int refillId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl?key=$_apiKey&action=refill_status&refill=$refillId"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch refill status");
    }
  }

  // Get multiple refill statuses
  Future<List<Map<String, dynamic>>> getMultipleRefillStatuses(
    List<int> refillIds,
  ) async {
    final refillsParam = refillIds.join(",");
    final response = await http.get(
      Uri.parse(
        "$_baseUrl?key=$_apiKey&action=refill_status&refills=$refillsParam",
      ),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch multiple refill statuses");
    }
  }

  // Create cancel
  Future<List<Map<String, dynamic>>> createCancel(
    List<Map<String, int>> cancels,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?key=$_apiKey&action=cancel"),
      body: json.encode(cancels),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to create cancel");
    }
  }

  // Get user balance
  Future<Map<String, dynamic>> getAdminBalance() async {
    final response = await http.get(
      Uri.parse("$_baseUrl?key=$_apiKey&action=balance"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch user balance");
    }
  }
}
