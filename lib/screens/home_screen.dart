import 'dart:convert';

import 'package:advice_api_integration/model/advice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  Advice initialAdvice =
      const Advice(id: 0, text: "Press the button to generate advice.");

  //?? for fetching advice ->
  Future fetchAdvice() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await Dio().get('https://api.adviceslip.com/advice');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data)['slip'];
        setState(() {
          initialAdvice = Advice(id: data['id'], text: data['advice']);
          loading = false;
        });
      } else {
        setState(() {
          initialAdvice = const Advice(
            id: 0,
            text: "We couldn't fetch the advice. Please try again later.",
          );
          loading = false;
        });
      }
    } catch (e) {
      setState(
        () {
          initialAdvice = const Advice(
            id: 0,
            text: "We couldn't fetch the advice. Please try again later.",
          );
          loading = false;
        },
      );
    }
  }

  //?? build ->
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Advice Generator",
          style: TextStyle(
            fontFamily: 'poppins_bold',
            letterSpacing: 0.3,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),

      //?? body ->
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.format_quote),
                        Text(
                          "Advice #${initialAdvice.id}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Icon(Icons.format_quote),
                      ],
                    ),
                  ),
                  Text(
                    initialAdvice.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      //?? floatingActionButton ->
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: loading ? null : fetchAdvice,
        label: Text(
          loading ? "Loading..." : "Generate Advice",
          style: const TextStyle(
            fontFamily: 'poppins_bold',
            letterSpacing: 0.3,
          ),
        ),
        icon: loading
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.grid_3x3),
      ),
    );
  }
}
