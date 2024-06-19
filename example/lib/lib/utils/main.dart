import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:sample/utils/common/app_bar/common_app_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<void> _rebuildStream = StreamController.broadcast();
  List<WeightedLatLng> data = [];
  List<Map<double, MaterialColor>> gradients = [
    HeatMapOptions.defaultGradient,
    {0.25: Colors.blue, 0.55: Colors.red, 0.85: Colors.pink, 1.0: Colors.purple}
  ];

  var index = 0;

  @override
  initState() {
    _loadData();
    super.initState();
  }

  @override
  dispose() {
    _rebuildStream.close();
    super.dispose();
  }

  _loadData() async {
    var str = await rootBundle.loadString('assets/initial_data.json');
    List<dynamic> result = jsonDecode(str);

    setState(() {
      data = result
          .map((e) => e as List<dynamic>)
          .map((e) => WeightedLatLng(LatLng(e[0], e[1]), 1))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _rebuildStream.add(null);
    });

    final map = FlutterMap(
      options: const MapOptions(initialCenter: LatLng(57.8827, -6.0400), initialZoom: 8.0),
      children: [
        TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
        if (data.isNotEmpty)
          HeatMapLayer(
            reset: _rebuildStream.stream,
            heatMapDataSource: InMemoryHeatMapDataSource(data: data),
            heatMapOptions: HeatMapOptions(
                gradient: HeatMapOptions.defaultGradient,
            ),
          )
      ],
    );
    return Scaffold(
      appBar: const AppBarCommon(
        title: "Set Campaign Location",
      ),
      body: Center(
        child: Container(child: map),
      ),
    );
  }
}
