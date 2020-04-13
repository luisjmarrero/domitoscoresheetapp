import 'package:domitoscoresheetapp/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scoreThemText = TextEditingController();
  final scoreUsText = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isButtonDisabled = false;
  List<List<int>> scores = [];
  int _totalThem = 0;
  int _totalUs = 0;
  double sideLength = 50;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    scoreThemText.dispose();
    scoreUsText.dispose();
    super.dispose();
  }

  void _resetEverything() {
    setState(() {
      scores = [];
      _totalThem = 0;
      _totalUs = 0;
      scoreThemText.clear();
      scoreUsText.clear();
      _isButtonDisabled = false;
    });
  }

  // alerts
  void _showAlert(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
              content: Text('Y los puntos pa\' cuando?'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('Mala mia..'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }

  void _anunceWinner(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
              content: Text(
                '${_totalThem > _totalUs ? 'Ganaron Ellos 😭' : 'Ganamos Nostros 😁!'}',
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText(
                    'Juevo Nuevo',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _resetEverything();
                  },
                ),
                PlatformDialogAction(
                  child: PlatformText(
                    'Cerrar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _askConfirmation(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
              content: Text(
                'Segur@ que deseas realizar esta acción?',
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text(
                    'Si',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetEverything();
                  },
                ),
                PlatformDialogAction(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  // game flow
  void _addRound() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      if (scoreThemText.text.isEmpty && scoreUsText.text.isEmpty) {
        _showAlert(context);
      } else {
        if (scoreThemText.text.isEmpty) scoreThemText.text = '0';
        if (scoreUsText.text.isEmpty) scoreUsText.text = '0';

        var a = int.parse(scoreThemText.text);
        var b = int.parse(scoreUsText.text);

        _totalThem += a;
        _totalUs += b;

        scores.add([a, b]);

        scoreThemText.clear();
        scoreUsText.clear();
        _isButtonDisabled = false;

        _scrollController.animateTo(0.0,
            duration: Duration(milliseconds: 100), curve: Curves.easeOutCirc);
      }

      // check for winners
      if (_totalThem >= 200 || _totalUs >= 200) {
        _anunceWinner(context);
        _isButtonDisabled = true;
      }
    });
  }

  void _deleteRound(index) {
    setState(() {
      setState(() {
        _totalThem -= scores[index][0];
        _totalUs -= scores[index][1];
        scores.removeAt(index);
        if (_totalThem <= 200 && _totalUs <= 200) {
          _isButtonDisabled = false;
        }
      });
    });
  }

  void _newGame() async {
    setState(() {
      _askConfirmation(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Stack(
          children: <Widget>[
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0.0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Ellos',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        _totalThem.toString(),
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                      'VS',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Nosotros',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        _totalUs.toString(),
                        style: Theme.of(context).textTheme.subtitle,
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
                              hintText: '0',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: scoreThemText,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '0',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: scoreUsText,
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
                            color: Theme.of(context).buttonColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Juego Nuevo',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: _newGame,
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
                                  Icons.add,
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
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            sideLength == 50
                                ? sideLength = 100
                                : sideLength = 50;
                          });
                        },
                        child: Scrollbar(
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              reverse: true,
                              controller: _scrollController,
                              itemCount: scores.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                  background: slideRightBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    setState(() {
                                      _totalThem -= scores[index][0];
                                      _totalUs -= scores[index][1];
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
                                          'P${index + 1}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        VerticalDivider(),
                                        Text(
                                          '${scores[index][0]}',
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                        VerticalDivider(),
                                        Text(
                                          '${scores[index][1]}',
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                        VerticalDivider(),
                                        IconButton(
                                          onPressed: () {
                                            _deleteRound(index);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
