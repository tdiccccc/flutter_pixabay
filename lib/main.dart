import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {

  //初期値は空
  List hits = [];

  void fetchImages() async {
    Response response = await Dio().get(
      'https://pixabay.com/api/?key=27974076-f6e3e3dcff4b569e37badd9b6&q=yellow+flowers&image_type=photo&pretty=true'
      );
    hits = response.data['hits'];
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    //最初に一度だけ呼ばれる。
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: hits.length,
        itemBuilder: (context, index){
          Map<String, dynamic> hit = hits[index];
          return Image.network(hit['previewURL']);
        },
      ),
    );
  }
}
