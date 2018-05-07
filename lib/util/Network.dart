import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Network {



    String _urlToFetch(String service) {
      String _SERVICE_END_POINT_URL='http://www.bajeli.com/app/infoscuolapp';
      String _SERVICE_END_POINT_PROVIDER='json-ServicesDebug.php';
      //SERVICE_END_POINT_URL
      String _uri='$_SERVICE_END_POINT_URL/$_SERVICE_END_POINT_PROVIDER?serviceName=$service';
      print(_uri);
      return _uri;
    }



    Future  getDataTask(String data,String serviceName) async {
      var httpClient = new HttpClient();
      String result;
      try {
      //var request = await httpClient.getUrl(Uri.parse(_urlToFetch('dologn')));
        var response;
        response = await httpClient.postUrl(Uri.parse(_urlToFetch(serviceName)))
            .then((HttpClientRequest request) async {
          request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
          request.contentLength = data.length;

          print(data);
          request.write(data);
          return await request.close();
        }
        );

        if (response.statusCode == HttpStatus.OK) {
          var jsonString = await response.transform(utf8.decoder).join();
          print(jsonString);
          result = jsonString;
        } else {
          result =
          'Error getting IP address:\nHttp status ${response.statusCode}';
        }
      } catch (exception) {
        result = 'Failed getting IP address'+exception;
      }
      return result;
    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.

/*
  if (!mounted) return;

  setState(() {
    print(result);
    //ResponseEnvelop i= new ResponseEnvelop.fromJson(json.decode(result));

    _ipAddress = result;
  });*/
}



}
