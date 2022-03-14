import 'package:flutter/material.dart';
import 'package:pokemarvel/models/pokemon.dart';
import 'package:pokemarvel/models/pokemondetail.dart';
import 'package:pokemarvel/services/remote.dart';

import '../models/pokemonList.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  PokemonList? pokemons;
  Pokemon? pokemon;
  var isLoaded = false;

  @override
  void initState(){
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async{
    //pokemon = await RemoteService.getPokemon(21);
    pokemons = await RemoteService.getPokemonsList();
    if(pokemons != null){
      setState(() {
        isLoaded = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pokémons')
        ),
        body: Visibility(
          visible: isLoaded, 
          child: ListView.builder(
            itemCount: pokemons!.results!.length,
            itemBuilder: (context, index){
            return GestureDetector(
              onTap: () => noClique(pokemons!.results[index].url),
              child: Card(
                child: ListTile(
                  leading: SizedBox (child: Text(pokemons!.results[index].name),
                  //width: 50,
                  height: 50),
              )));
            },
            
          ) , 
        replacement: const Center(child: CircularProgressIndicator(),), 
    ));
  }

  noClique(String url){
    var valores = url.split('/');
    var id = valores[valores.length-2];
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PokemonDetail(id: id)));              
    //print(id);
  }
}