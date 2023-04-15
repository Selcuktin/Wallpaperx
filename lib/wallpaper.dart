import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends StatefulWidget {

  @override
  _WallpaperState createState() => _WallpaperState();

}
class _WallpaperState extends State<Wallpaper> {
  List images =[];
  int page=1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }
  fetchapi()async{
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'), //pexels api fonksiyonu
        headers:{
          'Authorization':
          'GCChxxA6yElanA58QKbqNqF1A17vRKraPpjQmnbLxKAsQdf7vayUoX5r'
        }).then((value){
      print(value.body);
      Map result =jsonDecode(value.body);
      setState(() {
        images =result['photos'];
      });
      print(images[0]);
    });
  }
    loadmore()async{             //loadmore fonksiyonu
setState(() {
  page= page +1;
});
String url = 'https://api.pexels.com/v1/curated?per_page=80&page='+page.toString();
await http.get(Uri.parse(url), //pexels api fonksiyonu
    headers:{
      'Authorization':
      'GCChxxA6yElanA58QKbqNqF1A17vRKraPpjQmnbLxKAsQdf7vayUoX5r'
    }).then((value){
        Map result=jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      children: [
       Expanded(
         child: Container(
           child: GridView.builder(
               itemCount: images.length,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 2,crossAxisCount: 3,childAspectRatio: 2/3,
               mainAxisSpacing: 2),
               itemBuilder: (context,index){
             return Container(color: Colors.white,
             child: Image.network(images[index]['src']
             ['original'],fit: BoxFit.cover,),); //pexels dokümasyonundan original tiny=(hızlı yükleme) boyutunda resim
               }),

         ),),
        InkWell( //loadmore tıklandığında yükleme
          onTap: (){
            loadmore();
          },
          child: Container(          //anasayfa uzunluk color ve loadmore yazısı
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: Text('Load More',
                style:TextStyle(fontSize: 20,color: Colors.white),),
            ),),
        )
      ],
    ),

    );
  }
}
