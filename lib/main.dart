import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Picture.dart';
import 'Category.dart';

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
  List<CategoryX> categories = [];
  List<Widget> gridViews = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PageView(
        onPageChanged: (int index) {
          print('$index');
        },
        children: gridViews,
      ),
    );
  }

  void getCategory() async {
    String path = "http://service.picasso.adesk.com/v1/vertical/category";
    var map = <String, dynamic>{};
    map["adult"] = false;
    map["first"] = 1;
    Dio dio = Dio();
    var response = await dio.get(path, queryParameters: map);
    Map<String, dynamic> json = response.data;
    Category category = Category.fromJson(json);
    if (category.res != null && category.res?.category != null) {
      setState(() {
        categories.clear();
        categories.addAll(category.res!.category!);
      });
      buildGridView();
    }
  }

  void buildGridView() {
    List<Widget> g = [];
    for (var category in categories) {
      g.add(MyGridViewWidget(category: category.id.toString()));
    }
    setState(() {
      gridViews = g;
    });
  }
}

class MyGridViewWidget extends StatefulWidget {
  const MyGridViewWidget({Key? key, required this.category}) : super(key: key);

  final String? category;

  @override
  State<MyGridViewWidget> createState() => _MyGridViewWidgetState();
}

class _MyGridViewWidgetState extends State<MyGridViewWidget> {
  ScrollController scrollController = ScrollController();
  List<Vertical> pics = [];
  List<Widget> widgets = [];
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
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: .6,
            ),
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            children: widgets,
          )),
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

  void getRequest() async {
    int random = Random.secure().nextInt(1000);
    print('random: $random');
    var dio = Dio();
    String path =
        "http://service.picasso.adesk.com/v1/vertical/category/${widget.category}/vertical";
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
          pics.clear();
        }
        pics.addAll(picture.res!.vertical!);
      });
      buildWidget();
    } else {}
  }

  void buildWidget() {
    List<Widget> w = [];
    w.clear();
    for (var pic in pics) {
      w.add(Material(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(pic.img.toString()),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pushNamed("pic", arguments: pic.img);
            },
          ),
        ),
        // Ink(
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.of(context).pushNamed("pic", arguments: pic.img);
        //     },
        //     child: Container(
        //       alignment: Alignment.center,
        //       child: Ink.image(
        //         image: NetworkImage(pic.img.toString()),
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        // ),
      ));
    }
    setState(() {
      widgets = w;
    });
  }
}

class PicPageWidget extends StatefulWidget {
  const PicPageWidget({Key? key}) : super(key: key);

  @override
  State<PicPageWidget> createState() => _PicPageWidgetState();
}

class _PicPageWidgetState extends State<PicPageWidget> {
  @override
  Widget build(BuildContext context) {
    String? path = ModalRoute.of(context)?.settings.arguments.toString();
    if (path != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(path),
              fit: BoxFit.cover,
            ),
          ),
          child: MaterialButton(
            minWidth: double.infinity,
            height: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
            },
            onLongPress: () {

            },
          ),
        ),
        endDrawer: MaterialButton(
          onPressed: (){},
          color: Colors.green,
        ),
      );
    } else {
      return Container();
    }
  }
}
