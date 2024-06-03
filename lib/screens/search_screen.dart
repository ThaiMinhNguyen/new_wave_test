import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:new_wave_test/logic/geolocatorUtil.dart';

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
        child: Container(
            child: Column(
              children: [
                // SizedBox(height: 20,),
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
                      await Future.delayed(Duration(seconds: 1));
                      final latitude = position.latitude;
                      final longitude = position.longitude;
                      print(latitude);
                      print(longitude);
                      final url = Uri.parse('https://geocode.search.hereapi.com/v1/autosuggest?q=$value&at=$latitude,$longitude&limit=2&lang=vi&apiKey=$apiKey');
                      final response = await http.get(url);
                      // print(response.body);
                    },
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}
