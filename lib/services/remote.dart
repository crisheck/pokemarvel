import 'package:pokemarvel/models/pokemon.dart';
import 'package:pokemarvel/models/pokemonList.dart';
import 'package:http/http.dart' as http;

class RemoteService{
  static Future<PokemonList>? getPokemonsList() async {
    
    var client = http.Client();
    var uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/?offset=0&limit=151');
    var response = await client.get(uri);
    if(response.statusCode == 200){
      var json = response.body;
      return pokemonListFromJson(json);
    } else {
      return PokemonList(results: new List.empty());
    }  
  }

  static Future<Pokemon>? getPokemon(var number) async {
    var client = http.Client();
    var uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/'+number.toString());
    var response = await client.get(uri);
    if(response.statusCode == 200){
      var json = response.body;
      return pokemonFromJson(json);
    } else {
      return Pokemon(weight: -1, height: -1, id: -1, name: 'noName');
    }
  }
}