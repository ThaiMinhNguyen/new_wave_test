import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:new_wave_test/logic/geolocatorUtil.dart';
import 'package:new_wave_test/logic/mapUtil.dart';
import 'package:substring_highlight/substring_highlight.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final apiKey = 'MMtg8cyEWh2OKrK0F-M3-bpWbxs7ABhXj3Ih0at-HWs';
  final searchController = TextEditingController();
  final geoUtil = GeoUtil();
  late Position position;
  bool searchCheck = false;
  String searchText = '';
  var lsItem = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchFunction);
    getPosition();
  }

  Future<void> getPosition() async {
      position = await geoUtil.getPosition();
  }

  @override
  void dispose() {
    searchController.removeListener(searchFunction);
    searchController.dispose();
    super.dispose();
  }

  void searchFunction(){
    if(searchController.text.isNotEmpty){
      setState(() {
        searchCheck = true;
      });
    } else {
      setState(() {
        searchCheck = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: SearchBar(
                controller: searchController,
                leading: Icon(Icons.search),
                hintText: 'Enter keyword',
                trailing: [
                  Visibility(
                    visible: searchCheck,
                    child: IconButton(
                        onPressed: (){
                            searchController.clear();
                            // print(position.longitude);
                        },
                        icon: Icon(Icons.clear)),
                    replacement: SizedBox(),
                  ),
                ],
                onChanged: (value) async {
                  final latitude = position.latitude;
                  final longitude = position.longitude;
                  // print(latitude);
                  // print(longitude);
                  if(searchController.text.isEmpty){
                    setState(() {
                      lsItem = [];
                    });
                  } else {
                    final url = Uri.parse(
                        'https://geocode.search.hereapi.com/v1/autosuggest?q=$value&at=$latitude,$longitude&limit=10&lang=vi&apiKey=$apiKey');
                    final response = await http.get(url);
                    // print(jsonDecode(utf8.decode(response.bodyBytes))); // lấy có dấu theo utf8
                    final ls = jsonDecode(utf8.decode(response.bodyBytes))['items'] as List;
                    setState(() {
                      lsItem = ls;
                    });
                    // print(lsItem);
                    if (searchController.text.isEmpty) {
                      setState(() {
                        lsItem = [];
                      });
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lsItem.length,
                itemBuilder: (context, index) => ListTile(
                  // title: Text(lsItem[index]['title']),
                  title: SubstringHighlight(
                    text: lsItem[index]['title'],
                    term: searchController.text,
                    textStyleHighlight: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    final lat = lsItem[index]['position']['lat'];
                    final lng = lsItem[index]['position']['lng'];
                    final des = lsItem[index]['address']['label'];
                    final des_id = lsItem[index]['id'];
                    print(lat);
                    MapUtils.openMap(des, des_id, lat, lng);
                  },
                  trailing: Icon(Icons.directions),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
