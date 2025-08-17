import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductProvider with ChangeNotifier {
  Products? product;
  String? selectedColor;
  int quantity = 1;

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse('https://klinq.com/rest/V1/productdetails/6701/253620?lang=en&store=KWD'));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        log('api res$data');

        if (data != null && data.containsKey('data')) {
          final Map<String, dynamic>? productData = data['data'];
          // log('des${productData?['configurable_option']}');

          if (productData != null && productData.containsKey('description')) {
            final String description = productData['description'] ?? '';
            final RegExp colorRegExp = RegExp(r'Color: ([^<]+)');
            final Match? match = colorRegExp.firstMatch(description);

            if (match != null) {
              final String colorDescription = match.group(1)!;
              final List<String> colors = colorDescription.split(', ').map((color) => color.trim()).toList();
              final List<String> imageUrls = [
                'https://klinq.com/media/catalog/product/8/8/8809579837961-1_1pmzzkspggjyzljy.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579838296-1_mj8bpalcovgwf41a.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579836643-1_sullpgqme8fupjnh.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579836971-1_xu9s7p80mfcpdosr.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579837305-1_bwru4w2axn0p7oxk.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579836315-1_znolbd6nztyo1kgh.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579839286-1_5n2zw8uzxyjf3snh.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579837633-1_8mynlutwuo1ydcxv.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579838623-1_ftndjcne0cdu3vb0.jpg',
                'https://klinq.com/media/catalog/product/8/8/8809579838951-1_622nnwzx4bm66d1e.jpg',
              ];
              // final List imageUrls = productData['image'] ?? '';
              final String sku = productData['sku'] ?? '';
              final String name = productData['name'] ?? '';
              final String brand_name = productData['brand_name'] ?? '';
              final double price = double.parse(productData['price']?.toString() ?? '0.0');
              final int quantity = 1;
              // print('colorslist$colors');

              final product = Products(
                imageUrls: imageUrls,
                sku: sku,
                name: name,
                brand_name: brand_name,
                description: description,
                price: price,
                colors: colors,
                quantity: quantity,
              );

              setProduct(product);
            }
          }
        }
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void setProduct(Products newProduct) {
    product = newProduct;
    selectedColor = newProduct.colors.isNotEmpty ? newProduct.colors[0] : null;
    notifyListeners();
  }

  void selectColor(String color) {
    selectedColor = color;
    notifyListeners();
  }

  void setQuantity(int quantity) {
    quantity = quantity;
    notifyListeners();
  }
}