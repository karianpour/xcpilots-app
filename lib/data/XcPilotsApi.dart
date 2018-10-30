import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:xcpilots/data/mock/news.dart';

Function getPicturesBaseUrl = () => 'http://api.iranxc.ir';

class XcPilotsApi {
  static XcPilotsApi singleton;
  static getInstance(){
    if(singleton==null){
      singleton = XcPilotsApi();
    }
    return singleton;
  }

  var scheme = 'http';
  var host = 'api.iranxc.ir';
  var restApi = '__api';
  var authentication = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRyb25fdXVpZCI6IjEyM2U0NTY3LWU4OWItMTJkMy1hNDU2LTQyNjY1NTQ0MDAwNCIsInRpdGxlIjoi2KLZgtin24wiLCJzdXJuYW1lIjoi2KLYsduM2YbigIzZvtmI2LEiLCJmaXJzdF9uYW1lIjoi2qnbjNmI2KfZhiIsIm5hdGlvbmFsX2lkIjpudWxsLCJtb2JpbGVfbnVtYmVyIjoiMDkxMjExNjE5OTgiLCJtb2JpbGVfbnVtYmVyX3ZlcmlmaWVkIjp0cnVlLCJlbWFpbF9hZGRyZXNzIjoia2FyaWFucG91ckBnbWFpbC5jb20iLCJlbWFpbF9hZGRyZXNzX3ZlcmlmaWVkIjpudWxsLCJyb2xlcyI6WyJhZG1pbiJdLCJjcmVhdGVfdGltZXN0YW1wIjoiMjAxOC0wMy0wNlQxNzozMjoyNy40MTJaIiwicHJlZmVyZW5jZXMiOnsiZGlzdHJpY3RzIjpbeyJuYW1lIjoi2KrYrNix24zYtCIsInJlZ2lvbl9uYW1lIjoi2YXZhti32YLZhyDbsSIsImRpc3RyaWN0X3V1aWQiOiIxMjNlNDU2Ny1lODliLTEyZDMtYTQ1Ni00MjY2NTU0NDAwMDUifV0sInVuaXRfZmlsZV90eXBlIjoic2FsZSJ9LCJ1c2VybmFtZSI6ImFnZW50NjE0NzQwIiwidGVsZWdyYW1fdXNlcm5hbWUiOm51bGwsInByb2ZpbGVfcGljdHVyZSI6bnVsbCwicmxzIjpbImFkbWluIl0sImFpZCI6IjEyM2U0NTY3LWU4OWItMTJkMy1hNDU2LTQyNjY1NTQ0MDAwNCIsImlhdCI6MTUyODM3MTQwMSwiZXhwIjoxNTMwOTYzNDAxfQ.-0R_i_iLKLtZMs-BiDI2e-lfPy6Sl3Tyk0qIQFzcj5Y";

  Future<List> fetchBackground({String section}) async{

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
    print(url);

    try{
      final response = await http.get(url, 
        headers: {HttpHeaders.authorizationHeader: authentication});
      if(response.statusCode == HttpStatus.ok){
        return json.decode(response.body);
      }else{
        print(response);
        throw new Error();//todo
      }
    }catch (e) {
      print(e);
      throw new Error();//todo
    }
  }


  Future<List> fetchNewsData({String modelName, String before}) async{

    // return [
    //   sampleNews(),
    //   sampleNews(),
    // ];

    // 'news?filter=%7B%22order%22%3A%20%22created_at%20DESC%22%2C%20%22limit%22%3A%203%7D';
    // {"order": "created_at DESC", "limit": 3, "where": {"created_at": {"lt": "2018-09-14T18:55:19.729Z"}}}

    Map filter = {
      "order": "created_at DESC", 
      "limit": 3      
    };

    if(before!=null){
      filter['where'] = {
        "created_at": {
          "lt": before
        }
      };
    }

    print(json.encode(filter));

    Map<String, dynamic> queryParameters = {
      'filter': json.encode(filter)
    };
    Uri uri = new Uri(scheme: scheme, host: host, pathSegments: [restApi, modelName], queryParameters: queryParameters);
    var url = uri.toString();
    print(url);

    try{
      final response = await http.get(url, 
        headers: {HttpHeaders.authorizationHeader: authentication});
      if(response.statusCode == HttpStatus.ok){
        return json.decode(response.body);
      }else{
        print(response);
        throw new Error();//todo
      }
    }catch (e) {
      print(e);
      throw new Error();//todo
    }
  }
}