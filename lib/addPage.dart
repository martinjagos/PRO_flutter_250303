import 'package:flutter/material.dart';
import 'zaznam.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  final tachometrController = TextEditingController();
  final palivoController = TextEditingController();
  final cenaController = TextEditingController();
  final poznamkaController = TextEditingController();
  DateTime _datum = DateTime.now();

  @override
  void dispose() {
    tachometrController.dispose();
    palivoController.dispose();
    cenaController.dispose();
    poznamkaController.dispose();

    super.dispose();
  }
  void _ulozZaznam() {
    Zaznam zaznam = new Zaznam(int.parse(tachometrController.text), double.parse(palivoController.text), double.parse(cenaController.text), poznamkaController.text, _datum);
    Navigator.pop(context, zaznam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(toolbarHeight: 72.0, title: Text("Přidávání zázamu", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(labelText: "Stav tachometru", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))), keyboardType: TextInputType.number, controller: tachometrController),
              TextField(decoration: InputDecoration(labelText: "Množství paliva", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))), keyboardType: TextInputType.number, controller: palivoController),
              TextField(decoration: InputDecoration(labelText: "Cena za litr", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))), keyboardType: TextInputType.number, controller: cenaController),
              TextField(decoration: InputDecoration(labelText: "Poznámka", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))), keyboardType: TextInputType.text, controller: poznamkaController),
              CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(1970, 1, 1), lastDate: DateTime.now(), onDateChanged: (DateTime newDate){setState(() {_datum = newDate;});}),
              ElevatedButton(onPressed: _ulozZaznam, child: Text("Uložit")),
            ],
          ),
        ),
      ),
    );
  }
}