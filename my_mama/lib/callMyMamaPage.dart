import 'package:flutter/material.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:my_mama/dataModels.dart';
import 'scheduler.dart';

class CallMyMamaPage extends StatefulWidget {
  final Map<String, dynamic> dataQueries;
  CallMyMamaPage({Key key, this.dataQueries}) : super(key: key);

  @override
  _CallMyMamaPageState createState() =>
      _CallMyMamaPageState(dataQueries: dataQueries);
}

class _CallMyMamaPageState extends State<CallMyMamaPage> {
  final Map<String, dynamic> dataQueries;
  _CallMyMamaPageState({this.dataQueries});

  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    super.initState();

    controller.disableEditingWhenNoneSelected = true;
    //controller.set(mainList.length);
  }

  void getHelpFromMama() async {
    // configs cal borrar ConfigActivityFreeHour
    List<ConfigActivity> configs = await dataQueries["consultaConfigs"]();
    List<ConfigActivityFreeHour> recom = [];
    List<ConfigActivity> rest = [];

    for (ConfigActivity c in configs) {
      if (c is ConfigActivityFreeHour)
        recom.add(c);
      else
        rest.add(c);
    }

    List<ConfigActivityFreeHour> selection = [];
    for (int idx in controller.selectedIndexes) {
      selection.add(recom[idx]);
    }
    List<Activity> newToAddSchedule = callMyMama(rest, selection);
    List<ConfigActivity> newConfigs = [];
    for (int i = 0; i < newToAddSchedule.length; i++) {
      ConfigActivity c = newToAddSchedule[i].config;
      if (c is ConfigActivityFreeHour) {
        newConfigs.add(ConfigActivityOneTime(
            name: c.name,
            span: c.span,
            genre: c.genre,
            whenMinut: newToAddSchedule[i].start,
            whenDia: DateTime.now().weekday - 1));
      } else
        newConfigs.add(c);
    }
    for (int idx=0; idx<recom.length; idx++) {
      if (!controller.selectedIndexes.contains(idx)) {
        newConfigs.add(recom[idx]);
      }
    }
    dataQueries["saveConfigs"](newConfigs);
  }

  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //block app from quitting when selecting
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        return before;
      },
      child: new Scaffold(
        appBar: new AppBar(
          title:
              new Text(
                'Selected ${controller.selectedIndexes.length} tasks',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
          backgroundColor: Color(0xFFfafafa),
          elevation: 0,
          backwardsCompatibility: true,
          bottomOpacity: 0,
        ),
        body: FutureBuilder(
          future: dataQueries["consultaConfigs"](),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<ConfigActivity> configs = snapshot.data;
              List<ConfigActivityFreeHour> recom = [];
              for (ConfigActivity c in configs) {
                if (c is ConfigActivityFreeHour) recom.add(c);
              }

              return ListView.builder(
                itemCount: recom.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        borderRadius: new BorderRadius.circular(16.0),
                        onTap: () {},
                        child: MultiSelectItem(
                          isSelecting: controller.isSelecting,
                          onSelected: () {
                            setState(() {
                              controller.toggle(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: ListTile(
                              title: new Text("${recom[index].name}"),
                              subtitle: new Text(
                                  "Duration: for ${recom[index].span} minutes"),
                            ),
                            decoration: controller.isSelected(index)
                                ? new BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius:
                                        new BorderRadius.circular(16.0))
                                : new BoxDecoration(),
                          ),
                        ),
                      ));
                },
              );
            } else {
              print(snapshot.error);
              return Placeholder();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new ElevatedButton(
          onPressed: getHelpFromMama,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Schedule",
                style: TextStyle(color: Colors.white, fontSize: 45),
              )),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
        ),
      ),
    );
  }
}
