import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  var _button = 0;
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                trailing: const Icon(Icons.delete),
                onTap: () => setState(() {
                  _saved.remove(pair);
                  Navigator.of(context).pop();
                  _pushSaved();
                }),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[const ListTile(title: Text('No Saved Items'))];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ), // ...to here.
    );
  }

  void _buttonCount() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Stupid button'),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    _button = 0;
                    Navigator.of(context).pop();
                    _buttonCount();
                  }),
                  icon: const Icon(Icons.restore),
                  tooltip: "Reset the stupid button",
                )
              ],
            ),
            body: Center(
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 76, 244, 54))),
                child: Text(_button.toString(),
                    style: TextStyle(
                      fontSize: (_button.toDouble() + 10),
                    )),
                onPressed: () => setState(() {
                  _button = _button + 10;
                  Navigator.of(context).pop();
                  _buttonCount();
                }),
              ),
            ),
          );
        },
      ), // ...to here.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Startup name generator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
            icon: const Icon(Icons.egg),
            onPressed: _buttonCount,
            tooltip: 'Stupid Button',
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_outline_rounded,
              color: alreadySaved ? Colors.red : Colors.grey,
            ),
            onTap: () => setState(() {
              if (!alreadySaved) {
                _saved.add(_suggestions[index]);
              } else {
                _saved.remove(_suggestions[index]);
              }
            }),
          );
        },
      ),
    );
  }
}
