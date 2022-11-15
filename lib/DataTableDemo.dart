import 'package:flutter/material.dart';
import 'Services.dart';
import 'Products.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = "Actividad 2";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<Product> _products;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late Product _selectedProduct;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _products = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getProducts();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _addProduct() {
    if (_firstNameController.text
        .trim()
        .isEmpty ||
        _lastNameController.text
            .trim()
            .isEmpty) {
      print("Campos vacios");
      return;
    }
    _showProgress('Agregando Producto...');
    Services.addProduct(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if (result) {
        _getProducts();
      }
      _clearValues();
    });
  }

  _getProducts() {
    _showProgress('Cargando Productos...');
    Services.getProducts().then((products) {
      setState(() {
        _products = products;
      });
      _showProgress(widget.title);
      print("Length: ${products.length}");
    });
  }

  _deleteProduct(Product product) {
    _showProgress('Eliminando Producto...');
    Services.deleteProduct(product.id).then((result) {
      if (result) {
        setState(() {
          _products.remove(product);
        });
        _getProducts();
      }
    });
  }

  _updateProduct(Product product) {
    _showProgress('Actualizando Producto...');
    Services.updateProduct(
        product.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if (result) {
        _getProducts();
        setState(() {
          _isUpdating = false;
        });
        _firstNameController.text = '';
        _lastNameController.text = '';
      }
    });
  }

  _setValues(Product product) {
    _firstNameController.text = product.nombre;
    _lastNameController.text = product.cantidad;
    setState(() {
      _isUpdating = true;
    });
  }

  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataTextStyle: TextStyle(color: Colors.black),
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          dataRowColor: MaterialStateColor.resolveWith((Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? Colors.white
              : Colors.white
          ),
          columns: [
            DataColumn(
                label: Text("ID"),
                numeric: false,
                tooltip: "Id"),
            DataColumn(
                label: Text(
                  "NOMBRE",
                ),
                numeric: false,
                tooltip: "Nombre"),
            DataColumn(
                label: Text("CANTIDAD"),
                numeric: false,
                tooltip: "Cantidad"),
            DataColumn(
                label: Text("ELIMINAR"),
                numeric: false,
                tooltip: "Eliminar"),
          ],
          rows: _products.map(
                (product) =>
                DataRow(
                  cells: [
                    DataCell(
                      Text(product.id),
                      onTap: () {
                        print("Tapped " + product.nombre);
                        _setValues(product);
                        _selectedProduct = product;
                      },
                    ),
                    DataCell(
                      Text(
                        product.nombre.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + product.nombre);
                        _setValues(product);
                        _selectedProduct = product;
                      },
                    ),
                    DataCell(
                      Text(
                        product.cantidad.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + product.nombre);
                        _setValues(product);
                        _selectedProduct = product;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete,color: Colors.redAccent,),
                        onPressed: () {
                          _deleteProduct(product);
                        },
                      ),
                      onTap: () {
                        print("Tapped " + product.nombre);
                      },
                    ),
                  ],
                ),
          )
              .toList(),
        ),
      ),
    );
  }

  // showSnackBar(context, message) {
  //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(_titleProgress),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getProducts();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: "Nombre del producto",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: "Cantidad del productos",
                ),
              ),
            ),
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlinedButton(
                  child: Text('Actualizar'),
                  onPressed: () {
                    _updateProduct(_selectedProduct);
                  },
                ),
                OutlinedButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            Expanded(
              child: _dataBody(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProduct();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}