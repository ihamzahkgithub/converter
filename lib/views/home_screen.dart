import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/any_to_any.dart';
import '../Models/fetch_rates.dart';
import '../Models/rates_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<RatesModel> result;
  late Future<Map> allcurrencies;
  final formkey = GlobalKey<FormState>();
  String convertedCurrency = 'Converted Currency will be shown here :)';

  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
      allcurrencies = fetchcurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        height: h,
        width: w,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: FutureBuilder<RatesModel>(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: FutureBuilder<Map>(
                    future: allcurrencies,
                    builder: (context, currSnapshot) {
                      if (currSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnyToAny(
                            currencies: currSnapshot.data!,
                            rates: snapshot.data!.rates,
                            onAnswerChanged: (String newAnswer) {
                              setState(() {
                                convertedCurrency = newAnswer;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        convertedCurrency: convertedCurrency,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final String convertedCurrency;

  CustomBottomNavigationBar({required this.convertedCurrency});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.grey,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            '${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(),
          Text(
            '  $convertedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
