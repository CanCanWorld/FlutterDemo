import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nicetutu/Picture.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<Vertical> list = [];
  List<Widget> widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: .7,
        ),
        children: widgets,
      ),
    );
  }

  void buildWidget(List<Vertical> pics) {
    for (var pic in pics) {
        widgets.add(Container(
          child: Image.network(pic.thumb.toString()),
        ));
      }
  }

  void getRequest() async {
    var dio = Dio();
    const path =
        "http://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical";
    var map = <String, dynamic>{};
    map["limit"] = 30;
    map["skip"] = 10;
    map["adult"] = false;
    map["first"] = 1;
    map["order"] = "new";
    var response = await dio.get(path, queryParameters: map);
    Map<String, dynamic> json = response.data;
    Picture picture = Picture.fromJson(json);
    List<Vertical> l = [];
    if (picture.res != null && picture.res?.vertical != null) {
      l.clear();
      l.addAll(picture.res!.vertical!);
      buildWidget(l);
      setState(() {
      });
    } else {}

  }
}
