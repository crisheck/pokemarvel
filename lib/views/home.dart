import 'package:flutter/material.dart';
import 'package:pokemarvel/models/pokemon.dart';
import 'package:pokemarvel/models/pokemondetail.dart';
import 'package:pokemarvel/services/remote.dart';

import '../models/pokemonList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final pokeIdValueHolder = TextEditingController();
  PokemonList? pokemons;
  Pokemon? pokemon;
  var isLoaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String result = '';
  @override
  void initState() {
    super.initState();
    //fetch data from API
    getData();
  }

  getTextInputData() {
    setState(() {
      result = pokeIdValueHolder.text;
    });
    debugPrint('PokeID: ' + result);
  }

  getData() async {
    //pokemon = await RemoteService.getPokemon(21);
    pokemons = await RemoteService.getPokemonsList();
    if (pokemons != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
        appBar: AppBar(title: const Text('Pokémons')),
        body: Visibility(
          visible: isLoaded,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                    key: _formKey,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: pokeIdValueHolder,
                            textAlign: TextAlign.center,
                            //onChanged: teste(),
                            decoration: const InputDecoration(
                              hintText: "Poke-ID",
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: style,
                            onPressed: getTextInputData,
                            child: const Text('Pesquisar'))
                      ],
                    )),
                const Divider(),
                Expanded(child: listaPokemon()),
              ],
            ),
          ),
        ));
  }

  noClique(String name, String url) {
    var valores = url.split('/');
    var id = valores[valores.length - 2];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PokemonDetail(id: id, name: name)));
    //print(id);
  }

  teste() {
    debugPrint('movieTitle:"teste"');
  }

  listaPokemon() {
    return ListView.builder(
      itemCount: pokemons?.results.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => noClique(
                pokemons!.results[index].name, pokemons!.results[index].url),
            child: Card(
                child: ListTile(
              leading: SizedBox(
                  child: Text(pokemons!.results[index].name),
                  //width: 50,
                  height: 50),
            )));
      },
    );
  }
}
