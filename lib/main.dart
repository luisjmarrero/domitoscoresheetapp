import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Domino Score Sheet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Dominito'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scoreAController = TextEditingController();
  final scoreBController = TextEditingController();
  bool _isButtonDisabled = false;
  List<List<int>> scores = [];
  int _totalA = 0;
  int _totalB = 0;
  double sideLength = 50;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    scoreAController.dispose();
    scoreBController.dispose();
    super.dispose();
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('Y los puntos pa\' cuando?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Mala mia..'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _anunceWinner(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                  '${_totalA > _totalB ? 'Ganaron Ellos 😭' : 'Ganamos Nostros 😁!'}'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Juego Nuevo'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetEverything();
                  },
                ),
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _addRound() async {
    setState(() {
      if (scoreAController.text.isEmpty && scoreBController.text.isEmpty) {
        _showAlert(context);
      } else {
        if (scoreAController.text.isEmpty) scoreAController.text = '0';
        if (scoreBController.text.isEmpty) scoreBController.text = '0';

        var a = int.parse(scoreAController.text);
        var b = int.parse(scoreBController.text);

        _totalA += a;
        _totalB += b;

        scores.add([a, b]);

        scoreAController.clear();
        scoreBController.clear();
        _isButtonDisabled = false;
      }

      // check for winners
      if (_totalA >= 200 || _totalB >= 200) {
        _anunceWinner(context);
        _isButtonDisabled = true;
      }
    });
  }

  void deleteRound() {
    setState(() {});
  }

  void _resetEverything() {
    setState(() {
      scores = [];
      _totalA = 0;
      _totalB = 0;
      scoreAController.clear();
      scoreBController.clear();
      _isButtonDisabled = false;
    });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Borrar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Borrar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Ellos',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      _totalA.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Nosotros',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      _totalB.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 150, 5, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Ellos',
                            hintStyle: TextStyle(color: Colors.grey[900]),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 3),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 3),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: scoreAController,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Nosotros',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 3),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: scoreBController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: RaisedButton(
                          disabledColor: Colors.grey,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Juego Nuevo',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: _resetEverything,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: RaisedButton(
                          disabledColor: Colors.grey,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Agregar Ronda',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.library_add,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: _isButtonDisabled ? null : _addRound,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 370,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          sideLength == 50 ? sideLength = 100 : sideLength = 50;
                        });
                      },
                      child: ListView.builder(
                          itemCount: scores.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              key: Key(scores[index].toString()),
                              onDismissed: (direction) {
                                setState(() {
                                  _totalA -= scores[index][0];
                                  _totalB -= scores[index][1];
                                  scores.removeAt(index);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '${scores[index][0]}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      '${scores[index][1]}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
