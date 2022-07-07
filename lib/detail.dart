import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

Future<DetailModel> fetchDetail(id, type) async {
  String url = "";
  if (type == "story") {
    url = "https://lingoappfeeds.intoday.in/gnt/appapi/storydetail?id=" + id;
  } else if (type == "photogallery") {
    url = "https://lingoappfeeds.intoday.in/gnt/appapi/photodetail?id=" + id;
  } else if (type == "video") {
    url = "https://lingoappfeeds.intoday.in/gnt/appapi/videodetail?id=" + id;
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return jsonDecode(response.body);
    //return AlbumModel.fromJson(jsonDecode(response.body));

    //final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    //return parsed.map<AlbumModel>((json) => AlbumModel.fromMap(json)).toList();

    return DetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class DetailModel {
  final String status_code;
  final String status_message;
  final data;

  DetailModel({
    required this.status_code,
    required this.status_message,
    required this.data,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      status_code: json['status_code'],
      status_message: json['status_message'],
      data: json['data'],
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.id, required this.type})
      : super(key: key);

  final String id;
  final String type;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://akm-img-a-in.tosshub.com/lingo/gnt/resources/img/logo.png',
          fit: BoxFit.cover,
          height: 43.0,
        ),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Image.network(
              'https://akm-img-a-in.tosshub.com/lingo/gnt/resources/img/mob-header-bg.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height),
        ),
        // flexibleSpace: Image.network(
        //   'https://akm-img-a-in.tosshub.com/lingo/gnt/resources/img/mob-header-bg.png',
        //   fit: BoxFit.cover,
        // ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DetailModel>(
            future: fetchDetail(widget.id, widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.status_code == "1") {
                  var data = snapshot.data!.data;
                  return Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${data['title']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (widget.type == "story") ...[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Image.network(
                              data['large_image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Html(data: data['desc_withhtml'])
                        ],
                        if (widget.type == "photogallery")
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data['photo'].length,
                            itemBuilder: (context, index) {
                              var photo = data['photo'][index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: Image.network(photo['p_image'],
                                        fit: BoxFit.fill),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: Html(data: photo['p_caption']),
                                  )
                                ],
                              );
                            },
                          )
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ]);
            }),
      ),
    );
  }
}
