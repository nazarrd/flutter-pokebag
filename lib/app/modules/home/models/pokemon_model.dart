class Pokemon {
  int? count;
  String? next, previous;
  List<Results>? results;

  Pokemon({this.count, this.next, this.previous, this.results});

  Pokemon.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
  }
}

class Results {
  String? name, url, image;

  Results({this.name, this.url, this.image});

  Results.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    url = json['url'];
    image = json['url']?.replaceAll('/', '').replaceAll(
            'https:pokeapi.coapiv2pokemon',
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/') +
        '.png';
  }
}
