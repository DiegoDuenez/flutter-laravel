class Product {
  String id;
  String nombre;
  String cantidad;
  String created_at;
  String updated_at;

  Product({required this.id, required this.nombre, required this.cantidad,required this.created_at, required this.updated_at});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      nombre: json['nombre'].toString(),
      cantidad: json['cantidad'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString()
    );
  }
}