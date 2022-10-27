import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nicetutu/Picture.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: const HomePageWidget(),
      routes: <String, WidgetBuilder>{
        "pic": (context) => const PicPageWidget(),
      },
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
// Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<Vertical> list = [];
  List<Widget> widgets = [];
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getRequest();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('bottom');
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: .7,
          ),
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          children: widgets,
        ),
      ),
    );
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        page = 1;
      });
      getRequest();
    });
  }

  Future getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1), () {
        print('more');
        setState(() {
          page++;
          isLoading = false;
        });
        getRequest();
      });
    }
  }

  void buildWidget() {
    List<Widget> w = [];
    w.clear();
    for (var pic in list) {
      w.add(Material(
        child: Ink(
          child: InkWell(
            onTap: () {
              // Navigator.of(context).pushNamed("pic");
            },
            child: Container(
              alignment: Alignment.center,
              child: Ink.image(
                image: NetworkImage(pic.img.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ));
    }
    setState(() {
      widgets = w;
    });
  }

  void getRequest() async {
    int random = Random.secure().nextInt(1000);
    print('random: $random');
    var dio = Dio();
    const path =
        "http://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical";
    var map = <String, dynamic>{};
    map["limit"] = 30;
    map["skip"] = random;
    map["adult"] = false;
    map["first"] = 1;
    map["order"] = "new";
    var response = await dio.get(path, queryParameters: map);
    Map<String, dynamic> json = response.data;
    Picture picture = Picture.fromJson(json);
    if (picture.res != null && picture.res?.vertical != null) {
      setState(() {
        if (page == 1) {
          list.clear();
        }
        list.addAll(picture.res!.vertical!);
      });
      buildWidget();
    } else {}
  }
}

class PicPageWidget extends StatefulWidget {
  const PicPageWidget({Key? key}) : super(key: key);

  @override
  State<PicPageWidget> createState() => _PicPageWidgetState();
}

class _PicPageWidgetState extends State<PicPageWidget> {
  String path = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.yellow,
      ),
    );
  }
}
