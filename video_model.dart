class VideoModel {
  final String id;
  final String name;
  final String pic;
  final String type;
  final String remarks;
  final String actor;
  final String director;
  final String desc;
  final List<PlaySource> playSources;

  VideoModel({
    required this.id,
    required this.name,
    required this.pic,
    required this.type,
    required this.remarks,
    this.actor = '',
    this.director = '',
    this.desc = '',
    this.playSources = const [],
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    List<PlaySource> sources = [];
    if (json['vod_play_from'] != null && json['vod_play_url'] != null) {
      List<String> fromList = json['vod_play_from'].split('\$\$\$');
      List<String> urlList = json['vod_play_url'].split('\$\$\$');
      
      for (var i = 0; i < fromList.length; i++) {
        if (i < urlList.length) {
          sources.add(PlaySource(
            name: fromList[i],
            episodes: urlList[i].split('#').map((e) {
              List<String> parts = e.split('\$');
              return Episode(
                name: parts[0],
                url: parts.length > 1 ? parts[1] : '',
              );
            }).toList(),
          ));
        }
      }
    }

    return VideoModel(
      id: json['vod_id'].toString(),
      name: json['vod_name'] ?? '',
      pic: json['vod_pic'] ?? '',
      type: json['type_name'] ?? '',
      remarks: json['vod_remarks'] ?? '',
      actor: json['vod_actor'] ?? '',
      director: json['vod_director'] ?? '',
      desc: json['vod_content'] ?? '',
      playSources: sources,
    );
  }
}

class PlaySource {
  final String name;
  final List<Episode> episodes;

  PlaySource({
    required this.name,
    required this.episodes,
  });
}

class Episode {
  final String name;
  final String url;

  Episode({
    required this.name,
    required this.url,
  });
}
