import 'package:flut_api/models/article_model.dart';
import 'package:flut_api/network/network_enums.dart';
import 'package:flut_api/network/network_helper.dart';
import 'package:flut_api/network/network_service.dart';
import 'package:flut_api/static/static_value.dart';
import 'package:flut_api/widgets/article_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'network/query_param.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Consume Rest API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Articles'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            // final json = snapshot.data;

            final List<Article> articles = snapshot.data as List<Article>;

            return ListView.builder(
              itemBuilder: (context, index){
                return Semantics(
                  label: 'Article widget Title ${articles[index].title}',
                    child: ArticleWidget(article: articles[index]));
              },
              itemCount: articles.length,
            );
          }else if(snapshot.hasError){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(height: 10,),
                  Text('Something Went Wrong')
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Future<List<Article>?> getData() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.get, 
      url: StaticValues.apiURl, 
      queryParam: QP.apiQP(
        apiKey: StaticValues.apiKey, country: StaticValues.apiCountry
      )
      );

      print(response?.statusCode);

      return NetworkHelper.filterResponse(
        callBack: _listOfArticlesFromJson, 
        response: response, 
        parameterName: CallBackParameterName.articles,
        onFailureCallBackWithMessage: (errorType, msg) {
          print('Error type-$errorType - Message $msg');
          return null;
        }
        );
  }

  List<Article> _listOfArticlesFromJson(json) => (json as List)
    .map((e) => Article.fromJson(e as Map<String, dynamic>))
    .toList();
}