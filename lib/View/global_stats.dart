import 'package:covid_tracker/Model/world_states_model.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class GlobalStats extends StatefulWidget {
  const GlobalStats({
    Key? key,
  }) : super(key: key);

  @override
  State<GlobalStats> createState() => _GlobalStatsState();
}

class _GlobalStatsState extends State<GlobalStats>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa268),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    StatesServices statesServices = StatesServices();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            SizedBox(
              height: mq.height * 0.01,
            ),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecord(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        controller: _controller,
                        size: 50,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            'Total':
                                double.parse(snapshot.data!.cases!.toString()),
                            'Critical': double.parse(
                                snapshot.data!.recovered.toString()),
                            'Deaths':
                                double.parse(snapshot.data!.deaths.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          chartRadius: 100,
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          animationDuration: const Duration(milliseconds: 1000),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                        Card(
                          child: Column(
                            children: [
                              ReusableRow(
                                  title: 'Total Deaths',
                                  value: snapshot.data!.cases.toString()),
                              ReusableRow(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths.toString()),
                              ReusableRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered.toString()),
                              ReusableRow(
                                  title: 'Active',
                                  value: snapshot.data!.active.toString()),
                              ReusableRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical.toString()),
                              ReusableRow(
                                  title: 'Todays Deaths',
                                  value: snapshot.data!.todayDeaths.toString()),
                              ReusableRow(
                                  title: 'Todays Recovered',
                                  value:
                                      snapshot.data!.todayRecovered.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.09,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CountryListScreen()),
                          ),
                          child: Hero(tag: 'Country',
                            child: Container(
                              height: mq.height * 0.07,
                              width: mq.width * 0.7,
                              decoration: BoxDecoration(
                                color: const Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Align(
                                  alignment: Alignment.center,
                                  child: Text('Track Countries')),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ]),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReusableRow extends StatelessWidget {
  late String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
