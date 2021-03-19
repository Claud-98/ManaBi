import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/repositories/dbhelper.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/screens/home_screen.dart';


void main() async {
  //path dove salvare i file del DB - Path è IOS =/ Android.
  // la richiesta con il path provider è asincrona
  //WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<YomuKanji>> future;
  //YomuKanji kanji= YomuKanji('学ぶ', 'まなぶ' , 'manabu'  , 'studiare' , 1);
  Future<List<YomuKanji>> kanjiFetched = KanjiRepository.getAllYomuKanji();

  List<Widget> buildListWidget(List<YomuKanji> elements){
    List<Widget> widgets = [];
    for(int i=0; i<elements.length; i++)
      widgets.add(
        Text(elements[i].toString())
      );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<YomuKanji>>(
        future: kanjiFetched,
        builder: (context, snapshot){
          if(snapshot.hasData)
            return HomeScreen();
          else if(snapshot.hasError)
            return Text('Error');
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }


  }
