import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

double width = 0;
double height = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domino Double Six Assistant',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(
              144, 224, 238, 0.25) // Set background color here
          ),
      home: const DominoForm(),
    );
  }
}

class Tile {
  String name;
  final int x;
  final int y;
  final int s;
  String m;

  Tile(this.name, this.x, this.y, this.s, this.m);
}

class DominoForm extends StatefulWidget {
  const DominoForm({super.key});

  @override
  State<DominoForm> createState() => _DominoFormState();
}

class _DominoFormState extends State<DominoForm> {
  double iconWidth = width / 8.0;
  double iconHeight = width * 1.5 / 8.0;
  double boxWidth = 50.0;
  double boxHeight = 40.0;

  int testScore = 0;

  List<Tile> bones = [
    Tile('0-0', 0, 0, 0, ""),
    Tile('1-0', 1, 0, 0, ""),
    Tile('1-1', 1, 1, 2, ""),
    Tile('2-0', 2, 0, 0, ""),
    Tile('2-1', 2, 1, 0, ""),
    Tile('2-2', 2, 2, 4, ""),
    Tile('3-0', 3, 0, 0, ""),
    Tile('3-1', 3, 1, 0, ""),
    Tile('3-2', 3, 2, 0, ""),
    Tile('3-3', 3, 3, 6, ""),
    Tile('4-0', 4, 0, 0, ""),
    Tile('4-1', 4, 1, 0, ""),
    Tile('4-2', 4, 2, 0, ""),
    Tile('4-3', 4, 3, 0, ""),
    Tile('4-4', 4, 4, 8, ""),
    Tile('5-0', 5, 0, 0, ""),
    Tile('5-1', 5, 1, 0, ""),
    Tile('5-2', 5, 2, 0, ""),
    Tile('5-3', 5, 3, 0, ""),
    Tile('5-4', 5, 4, 0, ""),
    Tile('5-5', 5, 5, 10, ""),
    Tile('6-0', 6, 0, 0, ""),
    Tile('6-1', 6, 1, 0, ""),
    Tile('6-2', 6, 2, 0, ""),
    Tile('6-3', 6, 3, 0, ""),
    Tile('6-4', 6, 4, 0, ""),
    Tile('6-5', 6, 5, 0, ""),
    Tile('6-6', 6, 6, 12, ""),
  ];

  List<Tile> table = [
    Tile('0', 0, 0, 0, ""),
    Tile('1', 1, 0, 1, ""),
    Tile('2', 2, 0, 2, ""),
    Tile('3', 3, 0, 3, ""),
    Tile('4', 4, 0, 4, ""),
    Tile('5', 5, 0, 5, ""),
    Tile('6', 6, 0, 6, ""),
    Tile('0-0', 0, 0, 0, ""),
    Tile('1-1', 1, 1, 2, ""),
    Tile('2-2', 2, 2, 4, ""),
    Tile('3-3', 3, 3, 6, ""),
    Tile('4-4', 4, 4, 8, ""),
    Tile('5-5', 5, 5, 10, ""),
    Tile('6-6', 6, 6, 12, ""),
  ];

  Tile? north, south, west, center, east;

  Tile result = Tile('', 0, 0, 0, "");
  int maxScore = 0;
  String pos = '';
  List<Tile> matchList = [];
  List<Tile> tiles = [];
  int topLength = 0, bottomLength = 0;
  bool _visibleResults = false;
  String c = "center", n = "north", s = "south", e = "east", w = "west";

  void _addPile(Tile tile) {
    if (!tiles.contains(tile)) {
      tiles.add(tile);
      tile.m = "s";
      if (tiles.length <= 11) {
        topLength = tiles.length;
        bottomLength = 0;
      } else {
        topLength = 11;
        bottomLength = tiles.length - 11;
      }
      setState(() {});
    }
  }

  void _deletePile(Tile tile) {
    tiles.remove(tile);
    if (tiles.length <= 11) {
      topLength = tiles.length;
      bottomLength = 0;
    } else {
      topLength = 11;
      bottomLength = tiles.length - 11;
    }
    setState(() {});
  }

  void _addEndX(int t, Tile? p, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s;
      } else {
        testScore = tiles[t].x + p!.s;
      }
      _addResult(t, m);
    }
  }

  void _addEndY(int t, Tile? p, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s;
      } else {
        testScore = tiles[t].y + p!.s;
      }
      _addResult(t, m);
    }
  }

  void _addEndX2(int t, Tile? p, Tile? q, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s + q!.s;
      } else {
        testScore = tiles[t].x + p!.s + q!.s;
      }
      _addResult(t, m);
    }
  }

  void _addEndY2(int t, Tile? p, Tile? q, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s + q!.s;
      } else {
        testScore = tiles[t].y + p!.s + q!.s;
      }
      _addResult(t, m);
    }
  }

  void _addEndX3(int t, Tile? p, Tile? q, Tile? r, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s + q!.s + r!.s;
      } else {
        testScore = tiles[t].x + p!.s + q!.s + r!.s;
      }
      _addResult(t, m);
    }
  }

  void _addEndY3(int t, Tile? p, Tile? q, Tile? r, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      if (tiles[t].s > 0) {
        testScore = tiles[t].s + p!.s + q!.s + r!.s;
      } else {
        testScore = tiles[t].y + p!.s + q!.s + r!.s;
      }
      _addResult(t, m);
    }
  }

  void _addX(int t, Tile? p, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].x + p!.s;
      _addResult(t, m);
    }
  }

  void _addY(int t, Tile? p, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].y + p!.s;
      _addResult(t, m);
    }
  }

  void _addX2(int t, Tile? p, Tile? q, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].x + p!.s + q!.s;
      _addResult(t, m);
    }
  }

  void _addY2(int t, Tile? p, Tile? q, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].y + p!.s + q!.s;
      _addResult(t, m);
    }
  }

  void _addX3(int t, Tile? p, Tile? q, Tile? r, Tile? m) {
    if (tiles[t].y == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].x + p!.s + q!.s + r!.s;
      _addResult(t, m);
    }
  }

  void _addY3(int t, Tile? p, Tile? q, Tile? r, Tile? m) {
    if (tiles[t].x == m?.x) {
      _matchAdd(t);
      testScore = tiles[t].y + p!.s + q!.s + r!.s;
      _addResult(t, m);
    }
  }

  void _addResult(int t, Tile? p) {
    if (testScore % 5 == 0 && testScore > maxScore) {
      maxScore = testScore;
      result = tiles[t];
      pos = p!.m;
    }
  }

  void _matchAdd(int t) {
    if (!matchList.contains(tiles[t])) {
      matchList.add(tiles[t]);
    }
  }

  void _solve() {
    result = Tile('', 0, 0, 0, "");
    pos = '';
    maxScore = 0;
    matchList = [];

    if (center != null) {
      if (west == null && east == null && north == null && south == null) {
        // center

        for (int t = 0; t < tiles.length; t++) {
          _addY(t, center, center);
          _addX(t, center, center);
        }
      } else if (west != null &&
          east == null &&
          north == null &&
          south == null) {
        // center + west

        for (int t = 0; t < tiles.length; t++) {
          _addY(t, west, center);
          _addX(t, west, center);

          _addEndY(t, center, west);
          _addEndX(t, center, west);
        }
      } else if (west == null &&
          east != null &&
          north == null &&
          south == null) {
        // center + east

        for (int t = 0; t < tiles.length; t++) {
          _addY(t, east, center);
          _addX(t, east, center);

          _addEndY(t, center, east);
          _addEndX(t, center, east);
        }
      } else if (west == null &&
          east == null &&
          north != null &&
          south == null) {
        // center + north

        for (int t = 0; t < tiles.length; t++) {
          _addY(t, north, center);
          _addX(t, north, center);

          _addEndY(t, center, north);
          _addEndX(t, center, north);
        }
      } else if (west == null &&
          east == null &&
          north == null &&
          south != null) {
        // center + south

        for (int t = 0; t < tiles.length; t++) {
          _addY(t, south, center);
          _addX(t, south, center);

          _addEndY(t, center, south);
          _addEndX(t, center, south);
        }
      } else if (west == null &&
          east == null &&
          north != null &&
          south != null) {
        // center + north + south

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, north, south, center);
          _addX2(t, north, south, center);

          _addEndY(t, south, north);
          _addEndX(t, south, north);

          _addEndY(t, north, south);
          _addEndX(t, north, south);
        }
      } else if (west != null &&
          east != null &&
          north == null &&
          south == null) {
        // center + west + east

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, west, east, center);
          _addX2(t, west, east, center);

          _addEndY(t, east, west);
          _addEndX(t, east, west);

          _addEndY(t, west, east);
          _addEndX(t, west, east);
        }
      } else if (west != null &&
          east == null &&
          north != null &&
          south == null) {
        // center + north + west

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, west, north, center);
          _addX2(t, west, north, center);

          _addEndY(t, north, west);
          _addEndX(t, north, west);

          _addEndY(t, west, north);
          _addEndX(t, west, north);
        }
      } else if (west == null &&
          east != null &&
          north != null &&
          south == null) {
        // center + north + east

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, east, north, center);
          _addX2(t, east, north, center);

          _addEndY(t, north, east);
          _addEndX(t, north, east);

          _addEndY(t, east, north);
          _addEndX(t, east, north);
        }
      } else if (west != null &&
          east == null &&
          north == null &&
          south != null) {
        // center + south + west

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, west, south, center);
          _addX2(t, west, south, center);

          _addEndY(t, south, west);
          _addEndX(t, south, west);

          _addEndY(t, west, south);
          _addEndX(t, west, south);
        }
      } else if (west == null &&
          east != null &&
          north == null &&
          south != null) {
        // center + south + east

        for (int t = 0; t < tiles.length; t++) {
          _addY2(t, east, south, center);
          _addX2(t, east, south, center);

          _addEndY(t, south, east);
          _addEndX(t, south, east);

          _addEndY(t, east, south);
          _addEndX(t, east, south);
        }
      } else if (west != null &&
          east == null &&
          north != null &&
          south != null) {
        // center + north + south + west

        for (int t = 0; t < tiles.length; t++) {
          _addY3(t, north, west, south, center);
          _addX3(t, north, west, south, center);

          _addEndY2(t, west, south, north);
          _addEndX2(t, west, south, north);

          _addEndY2(t, north, south, west);
          _addEndX2(t, north, south, west);

          _addEndY2(t, north, west, south);
          _addEndX2(t, north, west, south);
        }
      } else if (west == null &&
          east != null &&
          north != null &&
          south != null) {
        // center + north + south + east
        for (int t = 0; t < tiles.length; t++) {
          _addY3(t, north, east, south, center);
          _addX3(t, north, east, south, center);

          _addEndY2(t, east, south, north);
          _addEndX2(t, east, south, north);

          _addEndY2(t, north, south, east);
          _addEndX2(t, north, south, east);

          _addEndY2(t, north, east, south);
          _addEndX2(t, north, east, south);
        }
      } else if (west != null &&
          east != null &&
          north == null &&
          south != null) {
        // center + west + south + east
        for (int t = 0; t < tiles.length; t++) {
          _addY3(t, east, west, south, center);
          _addX3(t, east, west, south, center);

          _addEndY2(t, east, west, south);
          _addEndX2(t, east, west, south);

          _addEndY2(t, south, west, east);
          _addEndX2(t, south, west, east);

          _addEndY2(t, south, east, west);
          _addEndX2(t, south, east, west);
        }
      } else if (west != null &&
          east != null &&
          north != null &&
          south == null) {
        // center + west + north + east
        for (int t = 0; t < tiles.length; t++) {
          _addY3(t, east, west, north, center);
          _addX3(t, east, west, north, center);

          _addEndY2(t, east, west, north);
          _addEndX2(t, east, west, north);

          _addEndY2(t, east, north, west);
          _addEndX2(t, east, north, west);

          _addEndY2(t, west, north, east);
          _addEndX2(t, west, north, east);
        }
      } else if (west != null &&
          east != null &&
          north != null &&
          south != null) {
        // center + north + south + west + east

        for (int t = 0; t < tiles.length; t++) {
          _addEndY3(t, north, east, south, west);
          _addEndX3(t, north, east, south, west);

          _addEndY3(t, west, east, south, north);
          _addEndX3(t, west, east, south, north);

          _addEndY3(t, north, west, south, east);
          _addEndX3(t, north, west, south, east);

          _addEndY3(t, north, east, west, south);
          _addEndX3(t, north, east, west, south);
        }
      }
    }

    _visibleResults = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('DB\'r Domino Solver'),
          foregroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(14, 110, 140, 0.5)),
      body: Column(
        children: [
          const Divider(
            height: 10,
            thickness: 0,
            indent: 5,
            endIndent: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: bones[index].m == "s"
                      ? const SizedBox.shrink()
                      : Image.asset("assets/${bones[index].name}.png",
                          height: iconHeight, width: iconWidth),
                  onPressed: () async {
                    _addPile(bones[index]);
                  },
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: bones[index + 7].m == "s"
                      ? const SizedBox.shrink()
                      : Image.asset("assets/${bones[index + 7].name}.png",
                          height: iconHeight, width: iconWidth),
                  onPressed: () async {
                    _addPile(bones[index + 7]);
                  },
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: bones[index + 14].m == "s"
                      ? const SizedBox.shrink()
                      : Image.asset("assets/${bones[index + 14].name}.png",
                          height: iconHeight, width: iconWidth),
                  onPressed: () async {
                    _addPile(bones[index + 14]);
                  },
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: bones[index + 21].m == "s"
                      ? const SizedBox.shrink()
                      : Image.asset("assets/${bones[index + 21].name}.png",
                          height: iconHeight, width: iconWidth),
                  onPressed: () async {
                    _addPile(bones[index + 21]);
                  },
                ),
              );
            }),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () async {
              _solve();
            },
            child: const Text('Solve'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(topLength, (inx) {
              return Container(
                  padding: const EdgeInsets.all(0.0),
                  width: iconWidth,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset("assets/${tiles[inx].name}.png",
                        height: iconHeight, width: iconWidth),
                    onPressed: () {
                      _deletePile(tiles[inx]);
                    },
                  ));
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bottomLength, (inx) {
              return Container(
                  padding: const EdgeInsets.all(0.0),
                  width: iconWidth,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset("assets/${tiles[inx + 11].name}.png",
                        height: iconHeight, width: iconWidth),
                    onPressed: () {
                      _deletePile(tiles[inx]);
                    },
                  ));
            }),
          ),
          const Divider(
            color: Colors.blue,
            height: 5,
            thickness: 0,
            indent: 5,
            endIndent: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Tile>(
                    value: north,
                    iconSize: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.yellow),
                    dropdownColor: Colors.blue,
                    items: table.map((Tile val) {
                      return DropdownMenuItem<Tile>(
                        value: val,
                        child: Center(child: Text(val.name)),
                      );
                    }).toList(),
                    onChanged: (Tile? newValue) {
                      setState(() {
                        north = newValue!;
                        north?.m = n;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Tile>(
                      value: west,
                      iconSize: 0,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.yellow),
                      dropdownColor: Colors.blue,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          west = newValue!;
                          west?.m = w;
                        });
                      }),
                ),
              ),
              Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Tile>(
                      value: center,
                      iconSize: 0,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.yellow),
                      dropdownColor: Colors.blue,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          center = newValue!;
                          center?.m = c;
                        });
                      }),
                ),
              ),
              Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Tile>(
                      value: east,
                      iconSize: 0,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.yellow),
                      dropdownColor: Colors.blue,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          east = newValue!;
                          east?.m = e;
                        });
                      }),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Tile>(
                      value: south,
                      iconSize: 0,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.yellow),
                      dropdownColor: Colors.blue,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          south = newValue!;
                          south?.m = s;
                        });
                      }),
                ),
              )
            ],
          ),
          Visibility(
            visible: _visibleResults,
            child: Column(
              children: [
                const Divider(
                  color: Colors.blue,
                  height: 5,
                  thickness: 0,
                  indent: 5,
                  endIndent: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(matchList.length, (index) {
                    return Center(
                      child: SizedBox(
                          width: iconWidth,
                          height: iconHeight,
                          child: Image.asset(
                              'assets/${matchList[index].name}.png',
                              fit: BoxFit.contain)),
                    );
                  }),
                ),
                Text(
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                  ' Score $maxScore - $pos',
                ),
                Center(
                  child: result.name != ''
                      ? SizedBox(
                          width: iconWidth,
                          height: iconHeight,
                          child: Image.asset('assets/${result.name}.png',
                              fit: BoxFit.contain))
                      : const Text(
                          style: TextStyle(fontSize: 20, color: Colors.green),
                          ' No Scoring moves ',
                        ),
                ),
              ],
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
