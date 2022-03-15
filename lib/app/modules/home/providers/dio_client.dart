import 'package:dio/dio.dart';

import '../models/pokemon_model.dart';
import '../models/pokemon_detail_model.dart';

class DioClient {
  final Dio dio = Dio();
  final baseUrl = 'https://pokeapi.co/api/v2/';

  Future<Pokemon> getPokemon(String? url) async {
    Response response = await dio.get(url ?? '$baseUrl/pokemon?limit=10');
    return Pokemon.fromJson(response.data);
  }

  Future<PokemonDetail> pokemonDetail(String url) async {
    Response response = await dio.get(url);
    return PokemonDetail.fromJson(response.data);
  }
}
