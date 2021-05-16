import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/models/kaku_data_required_for_build.dart';
import 'package:manabi/models/yomu_data_required_for_build.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

/*Model that update the score*/
class ScoreNotifier extends ChangeNotifier {
  final Reader _reader;
  int _score = 0;
  int _addAfterMatch;
  int _subAfterNotMatch;
  bool _perfect = true;

  ScoreNotifier(this._reader);

  int get score => _score;

  void incrementScore() {
    _reader(audioProvider).playMatchesSound();
    if (_reader(matchProvider).length == 1 && _perfect)
      _score = 100;
    else
      _score += _addAfterMatch;
    notifyListeners();
  }

  void decrementScore() {
    _reader(audioProvider).playNotMatchesSound();
    _perfect = false;
    _score -= _subAfterNotMatch;
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    _perfect = true;
    notifyListeners();
  }

  void setAddAndSubMatch(int addMatch, int subNotMatch) {
    _addAfterMatch = addMatch;
    _subAfterNotMatch = subNotMatch;
  }
}

/*Model that updates the data after a match*/
class MatchNotifier<T> extends ChangeNotifier {
  final Reader _reader;
  List<T> _dataList;

  /*Must be or Yomukanji or String */
  List<dynamic> _dragItems;
  List<T> _dragTargetItems;
  int _length;

  MatchNotifier(this._reader);

  List<dynamic> get dragItems => _dragItems;

  List<T> get dragTargetItems => _dragTargetItems;

  int get length => _length;

  void initYomuGame(List<T> list) {
    if (list == null) return;
    _dataList = list;
    print(list);
    _length = list.length;
    setGameLists();
  }

  void setGameLists() {
    _dragItems = List<T>.from(_dataList);
    _dragItems.shuffle();
    _dragTargetItems = List<T>.from(_dataList);
    _dragTargetItems.shuffle();
  }

  void matchesForYomuGame(T kanji) {
    _length--;
    _dragItems.remove(kanji);
    _dragTargetItems.remove(kanji);
    if (_length == 0) {
      _reader(gameOverProvider).isGameOver(true);
    }
    notifyListeners();
  }

  void initKakuGame(List<String> kunAndOnYomi, List<T> kanjiList) {
    if (kanjiList == null) return;
    kunAndOnYomi.shuffle();
    _dragTargetItems = kanjiList;
    _dragItems = List.from(kunAndOnYomi);
    _length = kunAndOnYomi.length;
  }

  void matchesForKakuGame(String receivedItem) {
    _length--;
    _dragItems.remove(receivedItem);
    if (_length == 0) {
      _reader(gameOverProvider).isGameOver(false);
    }
    notifyListeners();
  }
}

/*Model that notify the end of the game level, save the bestScore and resets the game*/
class GameOverNotifier extends ChangeNotifier {
  final Reader _reader;
  bool _gameOver = false;
  bool _appBarVisibility = true;

  GameOverNotifier(this._reader);

  bool get gameOver => _gameOver;

  bool get appBarVisibility => _appBarVisibility;

  void isGameOver(bool isYomu) {
    _gameOver = true;
    int score = _reader(scoreProvider).score;
    setAppBarVisibility(false);
    if (score > _reader(levelInfoProvider).bestScore)
      saveBestScore(score, isYomu);
    notifyListeners();
  }

  void saveBestScore(int score, bool isYomu) {
    var levelInfoProviderRef = _reader(levelInfoProvider);
    int unit = levelInfoProviderRef.unit;
    int level = levelInfoProviderRef.level;
    if (isYomu) {
      bool translation = levelInfoProviderRef.translate;
      KanjiRepository.updateYomuLevelBestScore(score, unit, level, translation);
    } else {
      KanjiRepository.updateKakuLevelBestScore(score, unit, level);
    }
    _reader(levelInfoProvider).setBestScore(score);
    _reader(levelInfoProvider).setCallBestScore(score);
  }

  void setAppBarVisibility(bool visibility) {
    _appBarVisibility = visibility;
  }

  void reset() {
    _gameOver = false;
    notifyListeners();
  }
}

/*Model that stores the number of the unit, level, bestScore translation, and romaji state */
class LevelInfoNotifier<T> extends ChangeNotifier {
  final Reader _reader;
  List<T> _gameKanjiList;
  List<String> _kunAndOnYomi;
  int _unit;
  int _level;
  int _bestScore;
  int _callBackScore;
  int _listLength;
  bool _translate;
  bool _romaji;

  LevelInfoNotifier(this._reader);

  List<T> get gameKanjiList => _gameKanjiList;

  List<String> get kunAndOnYomi => _kunAndOnYomi;

  int get unit => _unit;

  int get level => _level;

  int get bestScore => _bestScore;

  int get callBackScore => _callBackScore;

  int get listLength => _listLength;

  bool get translate => _translate;

  bool get romaji => _romaji;

  void setLevelInfos(int unit, int level, bool translation) {
    _unit = unit;
    _level = level;
    _translate = translation;
  }

  void setGameKanjiList(List<T> kanjiList) {
    _gameKanjiList = kanjiList;
    _listLength = kanjiList.length;
  }

  void setKunAndOnYomiList(List<String> list) {
    _kunAndOnYomi = list;
    _listLength = list.length;
  }

  void setRomaji(bool romaji) {
    _romaji = romaji;
  }

  void setBestScore(int bestScore) {
    _bestScore = bestScore;
  }

  void setCallBestScore(int bestScore) {
    _callBackScore = bestScore;
  }

  void computeAddAndSubMatch() {
    print(_listLength);
    int addMatch = (100 / _listLength).round();
    int subNotMatch = (addMatch / 2).round();
    _reader(scoreProvider).setAddAndSubMatch(addMatch, subNotMatch);
  }
}

class RefreshProvider extends ChangeNotifier {
  void forceRefreshGraphics(BuildContext context) {
    context.refresh(averageLevelScore(0));
    context.refresh(averageLevelScore(1));
    context.refresh(averageLevelScore(2));
  }
}

class AudioNotifier extends ChangeNotifier {
  //final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  final alarmCorrectAudioPath = "assets/audios/correct_answer.mp3";
  final alarmWrongAudioPath = "assets/audios/wrong_answer.mp3";
  final test = "audios/videoplayback.m4a";

  void playMatchesSound() async {
    playLocalAsset(alarmWrongAudioPath);
  }

  void playNotMatchesSound() async {
   playLocalAsset(alarmWrongAudioPath);
  }

  void playLocalAsset(String path) async {
    /*assetsAudioPlayer.open(
      Audio(path),
      autoStart: true,
    );
     */
  }

    @override dispose() {
    super.dispose();
  }
}

final repositoryProvider = Provider((ref) => KanjiRepository());

final gameOverProvider =
    Provider.autoDispose((ref) => GameOverNotifier(ref.read));

final levelInfoProvider =
    Provider.autoDispose((ref) => LevelInfoNotifier(ref.read));

final scoreProvider =
    ChangeNotifierProvider.autoDispose((ref) => ScoreNotifier(ref.read));

final responseProvider =
    FutureProvider.autoDispose<YomuDataRequiredForBuild>((ref) async {
  final repoInstance = ref.read(repositoryProvider);
  final infoProvider = ref.read(levelInfoProvider);
  int unit = infoProvider.unit;
  int level = infoProvider.level;
  bool translate = infoProvider.translate;
  return await repoInstance.fetchAllYomuData(unit, level, translate);
});

final kakuResponseProvider =
    FutureProvider.autoDispose<KakuDataRequiredForBuild>((ref) async {
  final repoInstance = ref.read(repositoryProvider);
  final infoProvider = ref.read(levelInfoProvider);
  int unit = infoProvider.unit;
  int level = infoProvider.level;
  return await repoInstance.fetchAllKakuData(unit, level);
});

final averageLevelScore =
    FutureProvider.family.autoDispose<double, int>((ref, index) async {
  final repoInstance = ref.read(repositoryProvider);
  final allLevelScore = await repoInstance.getAllLevelNumber(index);
  final sumOfBestScores = await repoInstance.getSumOfAllBestScore(index);
  return (sumOfBestScores / allLevelScore) / 100;
});

final matchProvider =
    ChangeNotifierProvider.autoDispose((ref) => MatchNotifier(ref.read));

final updateAverageProvider = Provider((ref) => RefreshProvider());

final audioProvider = Provider.autoDispose((ref) => AudioNotifier());
