import 'package:flut_api/network/network_helper.dart';
import 'package:http/http.dart' as http;

enum RequestType{ get, put, post }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeader() => {
    'Content-Type': 'application/json'
  };

  static Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }){
    if(requestType == RequestType.get) {
      return http.get(uri, headers: headers);
    }
  }

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? queryParam,
  }) async {
    try {
    final _header = _getHeader();
    final _url = NetworkHelper.concatUrlQP(url, queryParam);

    final response = await _createRequest(
      requestType: requestType,
      uri: Uri.parse(_url),
      headers: _header,
      body: body
    );

    return response;
    } catch(e) {
      print('Error - $e');
      return null;
    }

  }

} 