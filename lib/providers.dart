import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/models/yomu_data_required_for_build.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/repositories/kanji_repository.dart';

class ScoreNotifier extends ChangeNotifier{
  final Reader _reader;
  int _score = 0;
  int _addAfterMatch;
  int _subAfterNotMatch;
  bool _perfect = true;

  ScoreNotifier(this._reader);

  int get score => _score;

  void incrementScore(int value){
    if (_reader(matchProvider).length == 1 && _perfect)
      _score = 100;
    else
      _score += _addAfterMatch;
    notifyListeners();
  }

  void decrementScore(int value){
    _perfect = false;
    _score -= _subAfterNotMatch;
    notifyListeners();
  }

  void resetScore(){
    _score = 0;
    _perfect = true;
    notifyListeners();
  }

  void setAddAndSubMatch(int addMatch, int subNotMatch){
    _addAfterMatch = addMatch;
    _subAfterNotMatch = subNotMatch;
  }
}



class MatchNotifier extends ChangeNotifier{
  final Reader _reader;
  List<YomuKanji> _dataList;
  List<YomuKanji> _dragItems;
  List<YomuKanji> _dragTargetItems;
  int _length;

  MatchNotifier(this._reader);

  List<YomuKanji> get dragItems => _dragItems;
  List<YomuKanji> get dragTargetItems => _dragTargetItems;
  int get length => _length;

  void setList(List<YomuKanji> list){
    if(list == null) return;
    _dataList = list;
    print(list);
    _length = list.length;
    setGameLists();
  }

  void setGameLists(){
      _dragItems = List<YomuKanji>.from(_dataList);
      _dragItems.shuffle();
      _dragTargetItems = List<YomuKanji>.from(_dataList);
      _dragTargetItems.shuffle();
  }

  void match(YomuKanji kanji){
    _length--;
    _dragItems.remove(kanji);
    _dragTargetItems.remove(kanji);
    if(_length == 0) {
      _reader(gameOverProvider).isGameOver();
    }
    notifyListeners();
  }
  
}
/*Model that notify and resets the game*/
class GameOverNotifier extends ChangeNotifier{
  final Reader _reader;
  bool _gameOver = false;
  bool _appBarVisibility = true;

  GameOverNotifier(this._reader);

  bool get gameOver => _gameOver;
  bool get appBarVisibility => _appBarVisibility;

  void isGameOver(){
    _gameOver = true;
    int score = _reader(scoreProvider).score;
    setAppBarVisibility(false);
    if(score > _reader(levelInfoProvider).bestScore)
      saveBestScore(score);
    notifyListeners();
  }

  void saveBestScore(int score){
    var levelInfoProviderRef = _reader(levelInfoProvider);
    int unit = levelInfoProviderRef.unit;
    int level = levelInfoProviderRef.level;
    bool translation = levelInfoProviderRef.translate;
    KanjiRepository.updateYomuLevelBestScore(score, unit, level, translation);
    _reader(levelInfoProvider).setBestScore(score);
    _reader(levelInfoProvider).setCallBestScore(score);
  }

  void setAppBarVisibility(bool visibility) {
    _appBarVisibility = visibility;
  }

  void reset(){
    _gameOver = false;
    notifyListeners();
  }

}


/*Model that stores the number of the unit, level, translation, and romaji state */
class LevelInfoNotifier extends ChangeNotifier{
  final Reader _reader;
  List<YomuKanji> _gameKanjiList;
  int _unit;
  int _level;
  int _bestScore;
  int _callBackScore;
  int _listLength;
  bool _translate;
  bool _romaji;


  LevelInfoNotifier(this._reader);

  List<YomuKanji> get gameKanjiList => _gameKanjiList;
  int get unit => _unit;
  int get level => _level;
  int get bestScore => _bestScore;
  int get callBackScore => _callBackScore;
  int get listLength => _listLength;
  bool get translate => _translate;
  bool get romaji => _romaji;


  void setLevelInfos(int unit, int level, bool translation)  {
    _unit = unit;
    _level = level;
    _translate = translation;
  }

  void setGameKanjiList(List<YomuKanji> kanjiList){
    _gameKanjiList = kanjiList;
    _listLength = kanjiList.length;
  }

  void setRomaji(bool romaji)  {
    _romaji = romaji;
  }

  void setBestScore(int bestScore) {
    _bestScore = bestScore;
  }

  void setCallBestScore(int bestScore) {
    _callBackScore = bestScore;
  }

  void computeAddAndSubMatch(){
    int addMatch = (100/_listLength).round();
    int subNotMatch = (addMatch/2).round();
    _reader(scoreProvider).setAddAndSubMatch(addMatch, subNotMatch);
  }



}


final repositoryProvider = Provider((ref) => KanjiRepository());

final gameOverProvider = Provider.autoDispose((ref) => GameOverNotifier(ref.read));

final levelInfoProvider = Provider.autoDispose((ref) => LevelInfoNotifier(ref.read));

final scoreProvider = ChangeNotifierProvider.autoDispose((ref) => ScoreNotifier(ref.read));

  final responseProvider = FutureProvider.autoDispose<YomuDataRequiredForBuild>((ref) async {
    final repoInstance = ref.read(repositoryProvider);
    final infoProvider = ref.read(levelInfoProvider);
    int unit = infoProvider.unit;
    int level = infoProvider.level;
    bool  translate = infoProvider.translate;
    return await repoInstance.fetchAllYomuData(unit, level, translate);
  });

final matchProvider = ChangeNotifierProvider.autoDispose((ref) => MatchNotifier(ref.read));







