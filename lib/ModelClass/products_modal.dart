class Product {
  int? id;
  String? name;
  String? description;
  int? price;
  String? img;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.img,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "img": img,
    };
  }
}

class ProductModel {
  int? _totalSize;
  int? _typeId;
  int? _offset;
  late List<Product> _products;

  List<Product> get products => _products;

  ProductModel({
    int? totalSize,
    int? typeId,
    int? offset,
    List<Product>? products,
  }) {
    _totalSize = totalSize;
    _typeId = typeId;
    _offset = offset;
    _products = products ?? [];
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      totalSize: json['total_size'],
      typeId: json['type_id'],
      offset: json['offset'],
      products: json['products'] != null
          ? (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_size": _totalSize,
      "type_id": _typeId,
      "offset": _offset,
      "products": _products.map((e) => e.toJson()).toList(),
    };
  }
}
