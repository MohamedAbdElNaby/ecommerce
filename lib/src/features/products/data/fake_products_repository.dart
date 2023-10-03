import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeDataRepository {
  // FakeDataRepository._();

  static FakeDataRepository instance = FakeDataRepository();
  final List<Product> _products = kTestProducts;
  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  Future<List<Product>> fetchProductList() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception("Connection Failed");
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductList() async* {
    await Future.delayed(const Duration(seconds: 2));
    // return Stream.value(_products);
    yield (_products);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList()
        .map((products) => products.firstWhere((product) => product.id == id));
    // return Stream.value(getProduct(id));
  }
}

final productRepositoryProvider = Provider<FakeDataRepository>((ref) {
  return FakeDataRepository.instance;
});

final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductList();
});
final productListFetchProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductList();
});
final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // debugPrint("create product provider with id: $id");
  // ref.onDispose(() { debugPrint("dispose product provider");});
  // final link=ref.keepAlive();
  // Timer(const Duration(seconds: 10), () {
  //   link.close();
  // });
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProduct(id);
});
