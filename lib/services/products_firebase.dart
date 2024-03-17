import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsFirebase {
  final util = FirebaseFirestore.instance;
  CollectionReference? _productsColecction;
  
  ProductsFirebase() {
    _productsColecction = util.collection('productos');
  }

  Stream<QuerySnapshot> consular() {
    return _productsColecction!.snapshots();
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    _productsColecction!.doc().set(data);
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) async {
    _productsColecction!.doc(id).update(data);
  }

  Future<void> eliminar(String id) async {
    _productsColecction!.doc(id).delete();
  }
}
