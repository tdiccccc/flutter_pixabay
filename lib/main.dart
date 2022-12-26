import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  void fetchImages(String text) async {
    Response response = await Dio().get(
      'https://pixabay.com/api/?key=27974076-f6e3e3dcff4b569e37badd9b6&q=$text&image_type=photo&pretty=true&per_page=100'
      );
    hits = response.data['hits'];
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    //最初に一度だけ呼ばれる。
    fetchImages('亀');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: '亀',
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled:true,
          ),
          onFieldSubmitted: (text) {
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: hits.length,
        itemBuilder: (context, index){
          Map<String, dynamic> hit = hits[index];
          return InkWell(
            onTap: () async {
              //1. URLから画像をダウンロード
              Response response = await Dio().get(
                hit['webformatURL'],
                options: Options(responseType: ResponseType.bytes),
              );

              //2. ダウンロードしたデータをファイルに保存
              Directory dir = await getTemporaryDirectory();
              File file = await File('${dir.path}/image.png').writeAsBytes(response.data);

              //3. Shareパッケージを呼び出して共有
              Share.shareFiles([file.path]);
              // Share.shareFiles([file.path]);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  hit['previewURL'],
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                        ),
                        Text('${hit['likes']}'),
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
