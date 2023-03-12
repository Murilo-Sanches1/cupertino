import 'package:flutter/foundation.dart' as foundation;

import 'product.dart';
import 'products_repository.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends foundation.ChangeNotifier {
  // + todos os produtos
  List<Product> _availableProducts = [];

  // + a categoria atual escolhida
  Category _selectedCategory = Category.all;

  // + ids e a quantidade de produtos no carrinho
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // + item total de produtos no carrinho
  int get totalCartQuantity {
    // + fold === reduce (quase)
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  // + preço total dos itens no carrinho
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // + (shirt.price) 50 dól * (Map<id, qntd>) qntd
      return getProductById(id).price * _productsInCart[id]!;
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // + frete para os itens no carrinho
  double get shippingCost {
    // + _shippingCostPerItem = 7
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  // + imposto sobre vendas para os itens no carrinho
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  // + custo total para pedir tudo no carrinho
  double get totalCost {
    return subtotalCost + shippingCost + tax;
  }

  // + retorna uma cópia da lista dos produtos disponiveis filtrado por categoria
  List<Product> getProducts() {
    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts.where((product) {
        return product.category == _selectedCategory;
      }).toList();
    }
  }

  // + pesquisar pelo produto
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // + adicionar um produto ao carrinho
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  // + remover um produto do carrinho
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = _productsInCart[productId]! - 1;
      }
    }

    notifyListeners();
  }

  // + retorna a instância do produto que é igual ao id
  Product getProductById(int id) {
    return _availableProducts.firstWhere((product) => product.id == id);
  }

  // + remove tudo do carrinho
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // + carrega a lista dos produtos disponíveis
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
