import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive_experimens.g.dart';

class HiveExperimentWidget extends StatefulWidget {
  const HiveExperimentWidget({Key? key}) : super(key: key);

  @override
  _HiveExperimentWidgetState createState() => _HiveExperimentWidgetState();
}

class _HiveExperimentWidgetState extends State<HiveExperimentWidget> {
  final model=HiveModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(

          child: Column(
            children: [
              ElevatedButton(
                onPressed: model.doSome,
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: model.setup,
                child: const Text('Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HiveModel{

  Future<Box<User>>? userBox;
  HiveModel(){
  }

  void setup () {
    if(!Hive.isAdapterRegistered(0)){
      Hive.registerAdapter(UserAdapter());
    }
    userBox= Hive.openBox<User>('userbox');
    userBox?.then((box) {
      box.listenable().addListener(() {
        print(box.length);
      });
    });
  }

  void doSome() async{
      final box=await userBox;
      final user=User(name: 'max',age: 19);
      await box?.add(user);

  }
}

void EncryptionExample() async{
  final secureStorage=const FlutterSecureStorage();
  final containsEncryptionKey=await secureStorage.containsKey(key: 'key');
  if(!containsEncryptionKey){
    var key=Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }
  final key=await secureStorage.read(key: 'key');
  var encriptionKey=base64Url.decode(key!);

  var encryptedBox=await Hive.openBox<String>('vaultBox',encryptionCipher: HiveAesCipher(encriptionKey));

  await encryptedBox.put('secret', 'Hive is cool');
  print(encryptedBox.get('secret'));
}



@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int age;


  User({required this.name,required this.age});

  @override
  String toString() {
    return 'name = $name age = $age' ;
  }
}

@HiveType(typeId: 1)
class Pet extends HiveObject{
  @HiveField(0)
  String name;

  Pet({required this.name});

  @override
  String toString() {
    return 'name = $name';
  }
}

// class UserAdapter extends TypeAdapter<User>{
//   @override
//   User read(BinaryReader reader) {
//     final name=reader.readString();
//     final age =reader.readInt();
//     return User(name: name,age: age);
//   }
//
//   @override
//   int get typeId => 0;
//
//   @override
//   void write(BinaryWriter writer, User obj) {
//     writer.writeString(obj.name);
//     writer.writeInt(obj.age);
//   }
//
// }
