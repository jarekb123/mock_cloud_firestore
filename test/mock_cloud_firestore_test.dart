import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:mock_cloud_firestore/mock_types.dart';
import 'package:test/test.dart';

void main() {
  String source;
  MockCloudFirestore mcf;
  setUp(() {
    source = """
{
  "goal": {
    "1": {
      "id":"1",
      "taskId": "1",
      "projectId": "2"
    }
  },
  "projects": {
    "1": {
      "id": "1",
      "title": "test project 1"
    },
    "2": {
      "id": "2",
      "title": "test project 2"
    }    
  },
  "tasks": {
    "1": {
      "id": "1",
      "description": "test description 1"
    },
    "2": {
      "id": "2",
      "description": "test description 2"
    }
  }
}
    """;
    mcf = MockCloudFirestore(source);
  });

  test('construct', () {
    expect(mcf, isNotNull);
  });

  test('loads json', () {
    expect(mcf.sourceParsed, isNotNull );
  });

  test('get collection', (){
    MockCollectionReference col = mcf.collection("projects");
    expect(col, isNotNull);
  });
  test('get not exist collection', (){
    MockCollectionReference col = mcf.collection("not exists");
    expect(col, isNotNull);
  });
  test('get document from collection', () async{
    MockCollectionReference col = mcf.collection("projects");
    expect(col, isNotNull);
    MockDocumentReference doc = col.document("1");
    expect(doc, isNotNull);
    MockDocumentSnapshot docSnapshot = await doc.get();
    expect(docSnapshot.data["id"], "1");
    expect(docSnapshot.data["title"], "test project 1");
  });

  test('get not exist document from collection', () async{
    MockCollectionReference col = mcf.collection("projects");
    expect(col, isNotNull);
    MockDocumentReference doc = col.document("not exists");
    expect(doc, isNotNull);
    MockDocumentSnapshot docSnapshot = await doc.get();
    expect(docSnapshot, isNotNull);
    expect(docSnapshot.data, isNull);
  });

  test('get document snaphots from collection', () async{
    MockCollectionReference col = mcf.collection("projects");
    expect(col, isNotNull);
    Stream<QuerySnapshot> snaphosts = col.snapshots();
    expect(snaphosts, isNotNull);
    QuerySnapshot first = await snaphosts.first;
    expect(first, isNotNull);
    MockDocumentChange docChange = first.documentChanges[0];
    expect(docChange.document.data["id"], "1");

    MockDocumentSnapshot docSnap = first.documents[0];
    expect(docSnap.data["id"], "1");
  });

}