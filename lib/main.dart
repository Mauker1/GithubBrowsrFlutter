import 'package:flutter/material.dart';
import 'package:libraries/libraries.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Org Browser',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Browsr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentOrgsSort = SortingState.descending;
  var currentFilter = "";
  late SearchBar searchBar;

  _MyHomePageState() {
    this.searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        clearOnSubmit: false,
        onSubmitted: (text) {
          setState(() {
            currentFilter = text;
          });
        },
        onChanged: (text) {
          setState(() {
            currentFilter = text;
          });
        },
        onCleared: () {
          setState(() {
            currentFilter = "";
          });
        },
        onClosed: () {});
  }

  @override
  Widget build(BuildContext context) {
    var sdk = Libraries();

    Future<List<dynamic>> orgs = sdk.getOrgs();

    orgs.then((items) => {
          items.forEach((org) {
            print(org['login']);
            print(org['isFav']);
          })
        });

    return Scaffold(
      appBar: searchBar.build(context),
      body: FutureBuilder(
          future: orgs,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _getListData(snapshot.data, sdk),
              );
            }
            return Container();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentOrgsSort == SortingState.descending) {
            setState(() {
              currentOrgsSort = SortingState.ascending;
            });
          } else {
            setState(() {
              currentOrgsSort = SortingState.descending;
            });
          }
        },
        tooltip: 'Sort',
        child: Icon(Icons.sort_by_alpha),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text(widget.title),
      actions: [searchBar.getSearchAction(context)],
    );
  }

  List<Widget> _getListData(List<dynamic>? orgs, Libraries sdk) {
    List<Widget> widgets = [];
    if (orgs != null) {
      List<dynamic> filteredOrgs = [];
      if (currentFilter == "") {
        filteredOrgs.addAll(orgs);
      } else {
        for (int i = 0; i < orgs.length; i++) {
          if (orgs[i]['login'].toLowerCase().startsWith(currentFilter.toLowerCase())) {
            filteredOrgs.add(orgs[i]);
          }
        }
      }

      if (currentOrgsSort == SortingState.ascending) {
        filteredOrgs.sort((a, b) =>
            a['login'].toLowerCase().compareTo(b['login'].toLowerCase()));
      } else {
        filteredOrgs.sort((b, a) =>
            a['login'].toLowerCase().compareTo(b['login'].toLowerCase()));
      }

      for (int i = 0; i < filteredOrgs.length; i++) {
        widgets.add(GestureDetector(
          onTap: () {
            print('Item ${i + 1} tapped');
            print('Item name: ${filteredOrgs[i]['login']}');
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(
                  filteredOrgs[i]['avatarUrl'],
                  width: 48.0,
                  height: 48.0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                  child: Text(filteredOrgs[i]['login']),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      if (filteredOrgs[i]['isFav']) {
                        sdk.removeFavoriteOrg(filteredOrgs[i]['id']);
                      } else {
                        sdk.setFavoriteOrg(filteredOrgs[i]['id']);
                      }

                      setState(() {
                        filteredOrgs[i]['isFav'] = !filteredOrgs[i]['isFav'];
                      });
                    },
                    icon: Icon(filteredOrgs[i]['isFav']
                        ? Icons.star
                        : Icons.star_border))
              ],
            ),
          ),
        ));
      }
      return widgets;
    } else {
      return [];
    }
  }
}

enum SortingState { ascending, descending }
