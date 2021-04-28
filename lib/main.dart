import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/custom_colors.dart';
import 'package:manabi/l10n/l10n.dart';
import 'package:manabi/screens/home_screen.dart';
import 'package:manabi/screens/game_level_menu.dart';
import 'package:manabi/screens/settings_screen.dart';
import 'package:manabi/services/dbhelper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manabi/strings.dart' as strings;


void main() async {
  await DBHelper().initDatabase();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/Home_Background.png"), context);
    return MaterialApp(
      title: 'Manabi',
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.nezumihiro,
        primarySwatch: CustomColors.createMaterialColor(Color(0xFFDE3A5D)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: strings.homeRoute,
      routes: {
        strings.homeRoute: (context) => HomeScreen(),
        strings.yomuMenuRoute: (context) =>
            GameLevelMenu(numberOfLevels: [7, 4, 5, 3, 2, 4, 5],
                units: 7, type: strings.yomu),
        strings.kakuMenuRoute: (context) =>
            GameLevelMenu(numberOfLevels: [4, 4, 4, 5, 2, 4, 5],
                units: 7, type: strings.kaku),
        strings.settingsRoute: (context) => Settings(),
      },
    );
  }
}

/*
class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<YomuKanji>> future;
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
*/