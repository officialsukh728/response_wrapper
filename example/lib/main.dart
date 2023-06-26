import 'dart:async';
import 'package:flutter/material.dart';
import 'package:response_wrapper/response_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ResponseHttpInjector.init(
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String apiData = "";
  bool loading = false;
  String apiFullLink = "https://reqres.in/api/users";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Response Wrapper Example'),
        ),
        body: Center(
          child: loading
              ? customLoader()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(apiData),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                    label: const Text("Get Api"),
                    tooltip: "Get Api",
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final response =
                          await getDioService.request(url: apiFullLink);
                      setState(() {
                        apiData = "${response.data ?? ""}";
                        loading = false;
                      });
                    }),
                FloatingActionButton.extended(
                    label: const Text("Post Api"),
                    tooltip: "Post Api",
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final response = await getDioService.request(
                        url: apiFullLink,
                        requestType: DioServiceConst.post,
                        body: {"name": "morpheus", "job": "zion resident"},
                      );
                      setState(() {
                        apiData = "${response.data ?? ""}";
                        loading = false;
                      });
                    }),
                FloatingActionButton.extended(
                    label: const Text("Delete Api"),
                    tooltip: "Delete Api",
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final response =
                          await getDioService.request(url: apiFullLink);
                      setState(() {
                        apiData = "${response.data ?? ""}";
                        loading = false;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
