import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/models/yomu_data_required_for_build.dart';
import 'package:manabi/providers.dart';
import 'package:manabi/screens/yomu_game_.dart';

class YomuMatchingGameScreen extends ConsumerWidget {
  final int unit;
  final int level;
  final bool translation;

  YomuMatchingGameScreen({Key key, this.unit, this.level, this.translation});


  @override
  Widget build(BuildContext context, watch) {
    var levelInfoRef = watch(levelInfoProvider);
    levelInfoRef.setLevelInfos(unit, level, translation);
    AsyncValue<YomuDataRequiredForBuild> yomuData = watch(responseProvider);
    return Scaffold(
      body: yomuData.when(
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (error, stack) => const Text('Oops'),
        data: (yomuData) {
          levelInfoRef.setGameKanjiList(yomuData.kanjiLevelList);
          if(levelInfoRef.callBackScore == null)
            levelInfoRef.setBestScore(yomuData.bestScore);
          levelInfoRef.setRomaji(yomuData.romaji);
          levelInfoRef.computeAddAndSubMatch();
          context.read(matchProvider).setList(yomuData.kanjiLevelList);
          watch(gameOverProvider).gameOver;

          return Center(child: YomuGame(translation: translation,));
          },
      ),
    );
  }
}
