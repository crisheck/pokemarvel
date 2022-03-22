// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pokemarvel/models/pokemonList.dart';
import 'package:pokemarvel/models/pokemondetail.dart';
import 'package:pokemarvel/services/remote.dart';

class Pokemon extends StatefulWidget {
  const Pokemon({Key? key}) : super(key: key);

  @override
  State<Pokemon> createState() => _PokemonState();
}

class _PokemonState extends State<Pokemon> {
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
    pokemons ??= await RemoteService.getPokemonsList();
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
        // ignore: prefer_const_literals_to_create_immutables
        bottomNavigationBar: BottomNavigationBar(currentIndex: 0, items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/img/pokemon.png", height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/img/marvelDisable.png", height: 30),
            label: '',
          ),
        ]),
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
                Row(
                  children: [
                    ElevatedButton(
                        style: style,
                        onPressed: () => changePage(1),
                        child: const Text('Anterior')),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          _showToast();
                        }, //debugPrint("Gotta Catch 'Em All!"),
                        child: Image.asset("assets/img/pokeball.png",
                            width: 50, height: 50)),
                    Spacer(),
                    ElevatedButton(
                        style: style,
                        onPressed: () => changePage(2),
                        //onPressed: next,
                        child: const Text('Próximo'))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  noClique(String name, String url, String id) {
    debugPrint(id);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PokemonDetail(id: id, name: name)));
    //print(id);
  }

  changePage(int op) async {
    String url = "";
    if (op == 1) {
      url = pokemons!.previous.toString();
    } else {
      url = pokemons!.next.toString();
    }
    if (url != "" && url != "null") {
      pokemons = await RemoteService.getPokemonsListLink(url);
      if (pokemons != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  next() async {
    String url = pokemons!.next.toString();
    pokemons = await RemoteService.getPokemonsListLink(url);
    if (pokemons != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  teste() {
    debugPrint('movieTitle:"teste"');
  }

  listaPokemon() {
    return ListView.builder(
      itemCount: pokemons?.results.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => noClique(pokemons!.results[index].name,
                pokemons!.results[index].url, pokemons!.results[index].id),
            child: Card(
                child: SizedBox(
              height: 50,
              child: Center(
                  child: Text(pokemons!.results[index].name.toUpperCase(),
                      textAlign: TextAlign.center)),
            )));
      },
    );
  }

  _showToast() {
    return ScaffoldMessenger(
      child: const Text('Added to favorite'),
    );
  }
}
