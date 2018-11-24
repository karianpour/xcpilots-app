import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';

String mapToFarsi(String str){
  return str.replaceAllMapped(RegExp(r"\d"), 
    (Match m) {
      return convertDigit(m[0]);
    }
  );
}

String convertDigit(String m) {
  switch(m){
    case "1":
      return "۱";
    case "2":
      return "۲";
    case "3":
      return "۳";
    case "4":
      return "۴";
    case "5":
      return "۵";
    case "6":
      return "۶";
    case "7":
      return "۷";
    case "8":
      return "۸";
    case "9":
      return "۹";
    case "0":
      return "۰";

  }
  return m;
}

void persistState({Map state, String directory}) async {
  String stateAsString = json.encode(state);

  String fileName = 'state.json';
  final documentsDir = await getApplicationDocumentsDirectory();
  var dir = Directory('${documentsDir.path}/$directory');
  if(!await dir.exists()){
    await dir.create();
  }
  String path = '${dir.path}/$fileName';
  print('persisting state to $path');
  var file = File(path);
  if(await file.exists()){
    await file.delete();
  }

  await file.writeAsString(stateAsString);
}

Future<Map> restoreState({String directory}) async{
  String fileName = 'state.json';
  final documentsDir = await getApplicationDocumentsDirectory();
  var dir = Directory('${documentsDir.path}/$directory');
  if(!await dir.exists()){
    return null;
  }
  String path = '${dir.path}/$fileName';
  print('restoring state from $path');
  var file = File(path);
  if(!await file.exists()){
    return null;
  }

  String stateAsString = await file.readAsString();
  return json.decode(stateAsString);
}

Future<bool> isOnline() async{
  try{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
  }catch(err){

  }
  return false;
}