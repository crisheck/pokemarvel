import 'package:flutter/material.dart';
import 'package:pokemarvel/models/pokemon.dart';

import '../services/remote.dart';

class PokemonDetail extends StatefulWidget {
  final String? id;
  const PokemonDetail({ Key? key, this.id }) : super(key: key);

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  Pokemon? pokemon;
  var isLoaded = false;

  @override
  void initState(){
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async{
    pokemon = await RemoteService.getPokemon(widget.id);
    if(pokemon != null){
      setState(() {
        isLoaded = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(pokemon!.name),),
      body: Visibility(
          visible: isLoaded, 
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                Image.network(pokemon!.sprites!.frontDefault),
                const SizedBox(
                  height: 10,
                ),
                Text('Poke-ID:' + pokemon!.id.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                const SizedBox(
                  height: 10,
                ),
                Text('Altura: ' + pokemon!.height.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                const SizedBox(
                  height: 10,
                ),
                Text('Peso: ' + pokemon!.weight.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ],)
          ],   
      ),
      replacement: const Center(child: CircularProgressIndicator(),), 
    )
    );
  }
}