// To parse this JSON data, do
//
//     final kakuKanji = kakuKanjiFromJson(jsonString);

import 'dart:convert';

KakuKanji kakuKanjiFromJson(String str) => KakuKanji.fromJson(json.decode(str));

String kakuKanjiToJson(KakuKanji data) => json.encode(data.toJson());

class KakuKanji {
  KakuKanji({
    this.kanji,
    this.radical,
    this.references,
    this.examples,
  });

  Kanji kanji;
  Radical radical;
  References references;
  List<Example> examples;

  factory KakuKanji.fromJson(Map<String, dynamic> json) => KakuKanji(
    kanji: Kanji.fromJson(json["kanji"]),
    radical: Radical.fromJson(json["radical"]),
    references: References.fromJson(json["references"]),
    examples: List<Example>.from(json["examples"].map((x) => Example.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "kanji": kanji.toJson(),
    "radical": radical.toJson(),
    "references": references.toJson(),
    "examples": List<dynamic>.from(examples.map((x) => x.toJson())),
  };
}

class Example {
  Example({
    this.japanese,
    this.meaning,
    this.audio,
  });

  String japanese;
  Meaning meaning;
  Audio audio;

  factory Example.fromJson(Map<String, dynamic> json) => Example(
    japanese: json["japanese"],
    meaning: Meaning.fromJson(json["meaning"]),
    audio: Audio.fromJson(json["audio"]),
  );

  Map<String, dynamic> toJson() => {
    "japanese": japanese,
    "meaning": meaning.toJson(),
    "audio": audio.toJson(),
  };
}

class Audio {
  Audio({
    this.opus,
    this.aac,
    this.ogg,
    this.mp3,
  });

  String opus;
  String aac;
  String ogg;
  String mp3;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    opus: json["opus"],
    aac: json["aac"],
    ogg: json["ogg"],
    mp3: json["mp3"],
  );

  Map<String, dynamic> toJson() => {
    "opus": opus,
    "aac": aac,
    "ogg": ogg,
    "mp3": mp3,
  };
}

class Meaning {
  Meaning({
    this.english,
  });

  String english;

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
    english: json["english"],
  );

  Map<String, dynamic> toJson() => {
    "english": english,
  };
}

class Kanji {
  Kanji({
    this.character,
    this.meaning,
    this.strokes,
    this.onyomi,
    this.kunyomi,
    this.video,
  });

  String character;
  Meaning meaning;
  Strokes strokes;
  Onyomi onyomi;
  Kunyomi kunyomi;
  Video video;

  factory Kanji.fromJson(Map<String, dynamic> json) => Kanji(
    character: json["character"],
    meaning: Meaning.fromJson(json["meaning"]),
    strokes: Strokes.fromJson(json["strokes"]),
    onyomi: Onyomi.fromJson(json["onyomi"]),
    kunyomi: Kunyomi.fromJson(json["kunyomi"]),
    video: Video.fromJson(json["video"]),
  );

  Map<String, dynamic> toJson() => {
    "character": character,
    "meaning": meaning.toJson(),
    "strokes": strokes.toJson(),
    "onyomi": onyomi.toJson(),
    "kunyomi": kunyomi.toJson(),
    "video": video.toJson(),
  };
}

class Kunyomi {
  Kunyomi({
    this.romaji,
    this.hiragana,
  });

  String romaji;
  String hiragana;

  factory Kunyomi.fromJson(Map<String, dynamic> json) => Kunyomi(
    romaji: json["romaji"],
    hiragana: json["hiragana"],
  );

  Map<String, dynamic> toJson() => {
    "romaji": romaji,
    "hiragana": hiragana,
  };
}

class Onyomi {
  Onyomi({
    this.romaji,
    this.katakana,
  });

  String romaji;
  String katakana;

  factory Onyomi.fromJson(Map<String, dynamic> json) => Onyomi(
    romaji: json["romaji"],
    katakana: json["katakana"],
  );

  Map<String, dynamic> toJson() => {
    "romaji": romaji,
    "katakana": katakana,
  };
}

class Strokes {
  Strokes({
    this.count,
    this.timings,
    this.images,
  });

  int count;
  List<double> timings;
  List<String> images;

  factory Strokes.fromJson(Map<String, dynamic> json) => Strokes(
    count: json["count"],
    timings: List<double>.from(json["timings"].map((x) => x.toDouble())),
    images: List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "timings": List<dynamic>.from(timings.map((x) => x)),
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}

class Video {
  Video({
    this.poster,
    this.mp4,
    this.webm,
  });

  String poster;
  String mp4;
  String webm;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    poster: json["poster"],
    mp4: json["mp4"],
    webm: json["webm"],
  );

  Map<String, dynamic> toJson() => {
    "poster": poster,
    "mp4": mp4,
    "webm": webm,
  };
}

class Radical {
  Radical({
    this.character,
    this.strokes,
    this.image,
    this.position,
    this.name,
    this.meaning,
    this.animation,
  });

  String character;
  int strokes;
  String image;
  Position position;
  Kunyomi name;
  Meaning meaning;
  List<String> animation;

  factory Radical.fromJson(Map<String, dynamic> json) => Radical(
    character: json["character"],
    strokes: json["strokes"],
    image: json["image"],
    position: Position.fromJson(json["position"]),
    name: Kunyomi.fromJson(json["name"]),
    meaning: Meaning.fromJson(json["meaning"]),
    animation: List<String>.from(json["animation"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "character": character,
    "strokes": strokes,
    "image": image,
    "position": position.toJson(),
    "name": name.toJson(),
    "meaning": meaning.toJson(),
    "animation": List<dynamic>.from(animation.map((x) => x)),
  };
}

class Position {
  Position({
    this.hiragana,
    this.romaji,
    this.icon,
  });

  String hiragana;
  String romaji;
  String icon;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    hiragana: json["hiragana"],
    romaji: json["romaji"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "hiragana": hiragana,
    "romaji": romaji,
    "icon": icon,
  };
}

class References {
  References({
    this.grade,
    this.kodansha,
    this.classicNelson,
  });

  int grade;
  String kodansha;
  String classicNelson;

  factory References.fromJson(Map<String, dynamic> json) => References(
    grade: json["grade"],
    kodansha: json["kodansha"],
    classicNelson: json["classic_nelson"],
  );

  Map<String, dynamic> toJson() => {
    "grade": grade,
    "kodansha": kodansha,
    "classic_nelson": classicNelson,
  };
}
