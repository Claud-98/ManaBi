import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/models/kaku_data_required_for_build.dart';
import 'package:manabi/providers.dart';
import 'package:manabi/screens/error_screen.dart';
import 'package:manabi/screens/kaku_game_.dart';


class KakuMatchingGameScreen extends ConsumerWidget {
  final int unit;
  final int level;

  KakuMatchingGameScreen({Key key, this.unit, this.level}): super(key: key);


  @override
  Widget build(BuildContext context, watch) {
    var levelInfoRef = watch(levelInfoProvider);
    levelInfoRef.setLevelInfos(unit, level, false);
    AsyncValue<KakuDataRequiredForBuild> kakuData = watch(kakuResponseProvider);
    return Scaffold(
      body: kakuData.when(
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (error, stack) =>  ErrorScreen(errorMessage: error.toString()),
        data: (yomuData) {
          print('sono in data');
          levelInfoRef.setGameKanjiList(yomuData.kanjiLevelList);
          levelInfoRef.setKunAndOnYomiList(yomuData.kunAndOnYomi);
          print(yomuData.kunAndOnYomi);
          if(levelInfoRef.callBackScore == null)
            levelInfoRef.setBestScore(yomuData.bestScore);
          levelInfoRef.setRomaji(yomuData.romaji);
          context.read(matchProvider).initKakuGame(yomuData.kunAndOnYomi,
              yomuData.kanjiLevelList);
          levelInfoRef.computeAddAndSubMatch();
          watch(gameOverProvider).gameOver;

          return Center(child: KakuGameStateless());
        },
      ),
    );
  }
}
