import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Function getPicturesBaseUrl = () => 'http://api.iranxc.ir';

class XcPilotsApi {
  static XcPilotsApi singleton;
  static XcPilotsApi getInstance(){
    if(singleton==null){
      singleton = XcPilotsApi();
    }
    return singleton;
  }

  var scheme = 'http';
  var host = 'api.iranxc.ir';
  var restApi = '__api';
  var authentication = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRyb25fdXVpZCI6IjEyM2U0NTY3LWU4OWItMTJkMy1hNDU2LTQyNjY1NTQ0MDAwNCIsInRpdGxlIjoi2KLZgtin24wiLCJzdXJuYW1lIjoi2KLYsduM2YbigIzZvtmI2LEiLCJmaXJzdF9uYW1lIjoi2qnbjNmI2KfZhiIsIm5hdGlvbmFsX2lkIjpudWxsLCJtb2JpbGVfbnVtYmVyIjoiMDkxMjExNjE5OTgiLCJtb2JpbGVfbnVtYmVyX3ZlcmlmaWVkIjp0cnVlLCJlbWFpbF9hZGRyZXNzIjoia2FyaWFucG91ckBnbWFpbC5jb20iLCJlbWFpbF9hZGRyZXNzX3ZlcmlmaWVkIjpudWxsLCJyb2xlcyI6WyJhZG1pbiJdLCJjcmVhdGVfdGltZXN0YW1wIjoiMjAxOC0wMy0wNlQxNzozMjoyNy40MTJaIiwicHJlZmVyZW5jZXMiOnsiZGlzdHJpY3RzIjpbeyJuYW1lIjoi2KrYrNix24zYtCIsInJlZ2lvbl9uYW1lIjoi2YXZhti32YLZhyDbsSIsImRpc3RyaWN0X3V1aWQiOiIxMjNlNDU2Ny1lODliLTEyZDMtYTQ1Ni00MjY2NTU0NDAwMDUifV0sInVuaXRfZmlsZV90eXBlIjoic2FsZSJ9LCJ1c2VybmFtZSI6ImFnZW50NjE0NzQwIiwidGVsZWdyYW1fdXNlcm5hbWUiOm51bGwsInByb2ZpbGVfcGljdHVyZSI6bnVsbCwicmxzIjpbImFkbWluIl0sImFpZCI6IjEyM2U0NTY3LWU4OWItMTJkMy1hNDU2LTQyNjY1NTQ0MDAwNCIsImlhdCI6MTUyODM3MTQwMSwiZXhwIjoxNTMwOTYzNDAxfQ.-0R_i_iLKLtZMs-BiDI2e-lfPy6Sl3Tyk0qIQFzcj5Y";

  Future<List<Map>> fetchBackground({String section}) async{

    Map filter = {
      "where": {
        "section": section
      },
      "order": "created_at DESC", 
      "limit": 1
    };

    print(json.encode(filter));

    Map<String, dynamic> queryParameters = {
      'filter': json.encode(filter)
    };
    Uri uri = new Uri(scheme: scheme, host: host, pathSegments: [restApi, 'background'], queryParameters: queryParameters);
    var url = uri.toString();

    try{
      // print('fetching : $url');
      final response = await http.get(url) 
        //headers: {HttpHeaders.authorizationHeader: authentication})
        .timeout(const Duration(seconds: 30));
      if(response.statusCode == HttpStatus.ok){
        try{
          dynamic data = json.decode(response.body);
          if(data is List){
            return data.cast<Map>();
          }
        }catch(e){
          throw Exception('could not parse json data ${response.body}');
        }
        return null;
      }else{
        print(response);
        throw Exception('could not load background data');
      }
    }catch (e) {
      print(e);
      throw Exception('exception occured while fetching background data');
    }
  }


  Future<List> fetchData({String modelName, String before}) async{

    String section;
    if(modelName=='radio'){
      section = 'radio';
      modelName = 'content';
    }else if(modelName=='glide'){
      section = 'glide';
      modelName = 'content';
    }

    Map filter = {
      "where": {},
      "order": "created_at DESC", 
      "limit": 10
    };

    if(section != null){ 
      filter["where"]["section"] = section;
    }

    if(before!=null){
      filter['where']["created_at"] = {
        "lt": before
      };
    }

    print(json.encode(filter));

    Map<String, dynamic> queryParameters = {
      'filter': json.encode(filter)
    };
    Uri uri = new Uri(scheme: scheme, host: host, pathSegments: [restApi, modelName], queryParameters: queryParameters);
    var url = uri.toString();

    try{
      // print('fetching : $url');
      final response = await http.get(url, 
        //headers: {HttpHeaders.authorizationHeader: authentication}
        ).timeout(const Duration(seconds: 30));
      if(response.statusCode == HttpStatus.ok){
        try{
          dynamic data = json.decode(response.body);
          if(data is List){
            return data.cast<Map>();
          }
        }catch(e){
          throw Exception('could not parse json data ${response.body}');
        }
        return null;
      }else{
        print(response);
        throw Exception('could not load content data');
      }
    }catch (e) {
      print(e);
      throw Exception('exception occured while fetching content data from the server.');
    }
  }

//it will be depracted after radio glide refactor
  Future<Map> fetchTopFlights() async{

    Uri uri = new Uri(scheme: scheme, host: host, pathSegments: [restApi, 'flights', 'goodOnes']);
    var url = uri.toString();

    try{
      print('fetching : $url');
      final response = await http.get(url, 
        //headers: {HttpHeaders.authorizationHeader: authentication}
        ).timeout(const Duration(seconds: 30));
      if(response.statusCode == HttpStatus.ok){
        try{
          dynamic data = json.decode(response.body);
          if(data is Map){
            return data['data'];
          }
        }catch(e){
          throw Exception('could not parse json data ${response.body}');
        }
        return null;
      }else{
        print(response);
        throw Exception('could not load top flights data');
      }
    }catch (e) {
      print(e);
      throw Exception('exception occured while fetching top flights data from the server.');
    }
  }
}