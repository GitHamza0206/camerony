import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task.dart';

import 'circular_widget.dart';

class OverviewBox extends StatefulWidget {
  @override
  _OverviewBoxState createState() => _OverviewBoxState();
}

class _OverviewBoxState extends State<OverviewBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[100],
        body: SingleChildScrollView(
            child: Wrap(
          children: [OverViewWidget(), CardWidget()],
        )));
  }
}

class OverViewWidget extends StatelessWidget {
  DateTime date = DateTime.now();
  String nbtask;
  OverViewWidget({this.nbtask});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: Colors.purple[200],
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        CircularImage(
                          path: "assets/images/profile_image.jpg",
                          width: 50.0,
                          height: 60.0,
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Text("Hello, Camerony.",
                            style: Theme.of(context).textTheme.body1),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text("Looks like feel good.",
                            style: Theme.of(context).textTheme.body2),
                      ],
                    ),
                  ),
                  // Toobar,

                  SizedBox(height: 25.0),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width -
                                Size(280.0, 350.0).width) /
                            2),
                    child: Text(
                      'Today | ' + DateFormat.yMd().format(date),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ],
          ),
        ));
  }
}

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 25.0),
      child: Container(
        height: 300,
        child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: 50,
            ),
            CardWidgetInsideTaskDone(),
            SizedBox(
              width: 50,
            ),
            CardWidgetInsideUndoneTask(),
            SizedBox(
              width: 50,
            ),
            CardWidgetInsideAmountWon(),
            SizedBox(
              width: 50,
            ),
            CardWidgetInsideAmountLost(),
            SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidgetInsideTaskDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 250,
        child: Card(
          elevation: 10.0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                ),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Task Done '),
                ),
              ),
              LeftWonTaskWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidgetInsideAmountWon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
              ),
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Amount won '),
              ),
            ),
            LeftWonAmountWidget()
          ],
        ),
      ),
    );
  }
}

class CardWidgetInsideAmountLost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
              ),
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Amount Lost '),
              ),
            ),
            LeftLostAmountWidget(),
          ],
        ),
      ),
    );
  }
}

class CardWidgetInsideUndoneTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
              ),
              child: ListTile(
                leading: Icon(Icons.notification_important),
                title: Text(
                  'Undone tasks ',
                ),
              ),
            ),
            UndoneTaskWidget(),
          ],
        ),
      ),
    );
  }
}

class TopCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).getNbTask(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {},
                  child: Container(
                    width: 300,
                    height: 100,
                    child: Text(snapshot.hasData == true
                        ? 'You have currently ' +
                            snapshot.data.documents.length.toString() +
                            ' tasks'
                        : 'No tasks'),
                  ),
                ),
              );
            // You can reach your snapshot.data['url'] in here
          }
        });
  }
}

class LeftWonTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).getDoneTask(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length >= 5
                          ? 5
                          : snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(snapshot.data.documents[index]['description'])
                          ],
                        );
                      },
                    )),
              );
            // You can reach your snapshot.data['url'] in here
          }
        });
  }
}

class UndoneTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<TaskProvider>(context, listen: false).getPendingTask(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length >= 5
                          ? 5
                          : snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(snapshot.data.documents[index]['description'])
                          ],
                        );
                      },
                    )),
              );
            // You can reach your snapshot.data['url'] in here
          }
        });
  }
}

class LeftWonAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<TaskProvider>(context, listen: false).getWonAmount(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Container(
                width: 150,
                height: 50,
                child: Text(snapshot.hasData == true
                    ? 'You have won  ' + snapshot.data.toString() + '\$ '
                    : '0 \$ '),
              );
            // You can reach your snapshot.data['url'] in here
          }
        });
  }
}

class LeftLostAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<TaskProvider>(context, listen: false).getWonAmount(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Container(
                width: 150,
                height: 50,
                child: Text(snapshot.hasData == true
                    ? 'You have Lost  ' + snapshot.data.toString() + '\$ '
                    : '0 \$ '),
              );
            // You can reach your snapshot.data['url'] in here
          }
        });
  }
}
