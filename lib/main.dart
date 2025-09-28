import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite(WordPair? pair) {
    var currentItem = pair ?? current;
    if (favorites.contains(currentItem)) {
      favorites.remove(currentItem);
    } else {
      favorites.add(currentItem);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon = appState.favorites.contains(pair)
        ? Icons.favorite
        : Icons.favorite_border;

    return Scaffold(
      appBar: AppBar(title: Text("Namer App")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scrollable favorites in a fixed-height area
            SizedBox(height: 200, child: FavoritesPage()),
            Divider(),

            // Current word
            Center(child: Text('A random awesome idea:')),
            SizedBox(height: 10),
            BigCard(pair: pair),
            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite(pair);
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    // This ListView will scroll inside the fixed SizedBox
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'You have ${appState.favorites.length} favorites:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            onTap: () {
              appState.toggleFavorite(pair);
            },
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style =
        theme.textTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ) ??
        TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
