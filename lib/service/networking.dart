import 'dart:convert';
import 'package:http/http.dart';

class NetworkHelper{

  final kBackendAppURL = "Asd";
  final kContentType = "application/json";
  final kAuthorization = "Token a76e35d839b20faf08921dd7a0f3d4796ac3ce33";

  NetworkHelper(this.url);
  final String url;

  Future getData() async{
    Response response = await get(url);

    if(response.statusCode == 200){
      var decodeData = jsonDecode(response.body);
      return decodeData;
    }else{
      print(response.statusCode);
    }
  }
  Future<bool> authorization(String token) async{
    Response response = await post(url);
    if(response.statusCode == 200){
      var decodeData = jsonDecode(response.body);
      return true;
    }else{
      print(response.statusCode);
      return false;
    }
  }

 /* Future apiRequest(String url, List<String> jsonMap) async {
    Client client = Client();
    Response response = await client.post(
        kBackendAppURL,
        body: jsonEncode(jsonMap),
        headers: {
          'Content-type': kContentType,
          'Authorization': kAuthorization,
          'X-Secret': kXSecret
        });
    if(response.statusCode == 200){
      var decodeData = jsonDecode(response.body);
      return decodeData;
    }else{
      print(response.statusCode);
    }
    client.close();
  }*/

}