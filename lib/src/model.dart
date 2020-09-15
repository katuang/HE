import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModelHE {

  ModelHE();
  
  Stream<QuerySnapshot> categoryStream = Firestore.instance.collection('categoryHE').snapshots();
  CollectionReference categoryCollection = Firestore.instance.collection('categoryHE');
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // static Future handleSignIn() async {
  //   final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: 'katuang29@gmail.com', password: 'trojanassasin');
  //   final FirebaseUser user = result.user;
  //   print(user);
  //   return user;
  // }

  static Future<List<dynamic>> getIdCategoryDocument() async {
    // await handleSignIn();
    List<dynamic> tempDocument = [];
    QuerySnapshot categoryDocument = await Firestore.instance.collection('categoryHE').where('name', isEqualTo: 'Earth Works').getDocuments();
    List<DocumentSnapshot> documentList = categoryDocument.documents;
    documentList.forEach((DocumentSnapshot singleDocument) { 
    tempDocument.add(singleDocument.documentID);
    String chooseValue = singleDocument.documentID;
    
    });
    // List<dynamic> temporaryDocument = documentList.map((DocumentSnapshot singleDocument) => singleDocument['name']).toList();
    return tempDocument;
  }

  static Future getCategory() async {
    List<dynamic> listDocument = [];
    QuerySnapshot categoryDocumentSnapshot = await Firestore.instance.collection('categoryHE').getDocuments();
    List<DocumentSnapshot>  listDocumentSnapshot = categoryDocumentSnapshot.documents;
    listDocumentSnapshot.forEach((DocumentSnapshot document) {
      listDocument.add(document['name']);
    });
    return listDocument;
  }

  static Future getSubCategory(String documentId) async {
    List listDocument = [];
    QuerySnapshot subCategoryDocumentSnapshot = await Firestore.instance.collection('categoryHE').document(documentId).collection('subCategoryHE').getDocuments();
    List<DocumentSnapshot> listDocumentSnapshot = subCategoryDocumentSnapshot.documents;
    listDocumentSnapshot.forEach((DocumentSnapshot document) {
      listDocument.add(document['name']);
    });

    return listDocument;
  }

  static Future getProduct(String documentId, String subDocumentId) async {
    List listProduct = [];
    QuerySnapshot productSnapshot = await Firestore.instance.collection('categoryHE').document(documentId).collection('subCategoryHE').document(subDocumentId).collection('productHE').getDocuments();
    List<DocumentSnapshot> listProductSnapshot = productSnapshot.documents;
    listProductSnapshot.forEach((DocumentSnapshot document) {
      listProduct.add(document['name']);
    });

    return listProduct;
  }

  static Future addProduct() async {
    var productData = {
      'location': 'bali',
      'name': 'volvo',
      'transport': true,
      'type': 'large',
      'year': 2013
    };

    await Firestore.instance.collection('categoryHE').document('0').collection('subCategoryHE').document('1').collection('productHE').add(productData);

  }
  
}