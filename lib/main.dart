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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void deleteFavourites(var word){
    favorites.remove(word);
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var extended = false;
  @override
  Widget build(BuildContext context) {
   
    Widget page;
   switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
    case 1:
      page = FavoritesPage();
    case 2:
      page = UserPage();
    default:
      throw UnimplementedError('no widget for $selectedIndex');
   }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: extended,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
               ],

              trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              extended = !extended;
                            });
                          }),
                    )
                  )
              ),
              selectedIndex: selectedIndex, 
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                }
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigName(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
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
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asPascalCase),
            trailing: IconButton(icon:Icon(Icons.delete, semanticLabel: 'Delete'),
            onPressed: (){
              appState.deleteFavourites(pair);
            },),
            
          ),
      ],
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(children: [
      CircleAvatar(
        backgroundImage: NetworkImage("https://images.pexels.com/photos/346529/pexels-photo-346529.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
        radius: 140,
      ),
      Row(
        children: [
          SizedBox(width: 15),
          Column(
            children: [
              Text(
                'Ayushi Mehta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Text(
                'ayushim22@iitk.ac.in',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'City : Kanpur',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 30),
                  Icon(Icons.work, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Roll No. : 220275',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      )
    ]));
  }
}


class BigName extends StatelessWidget {
  const BigName({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    ); 
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asPascalCase, style:style),
      ),
    );
  }
}