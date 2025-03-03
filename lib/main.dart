import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotřeba Vozidla',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Spotřeba Vozidla'),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class Zaznam {
  final int _stavTachometru;
  final double _palivo;
  final double _cena;
  final String _poznamka;
  final DateTime _datum;

  Zaznam(this._stavTachometru, this._palivo, this._cena, this._poznamka, this._datum);
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
    print(tachometrController.text + palivoController.text + cenaController.text + poznamkaController.text + _datum.toString());
    Zaznam zaznam = new Zaznam(int.parse(tachometrController.text), double.parse(palivoController.text), double.parse(cenaController.text), poznamkaController.text, _datum);
    Navigator.pop(context, zaznam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(toolbarHeight: 64.0, title: Text("Přidávání zázamu", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(labelText: "Stav tachometru", border: OutlineInputBorder()), keyboardType: TextInputType.number, controller: tachometrController),
              TextField(decoration: InputDecoration(labelText: "Množství paliva", border: OutlineInputBorder()), keyboardType: TextInputType.number, controller: palivoController),
              TextField(decoration: InputDecoration(labelText: "Cena za litr", border: OutlineInputBorder()), keyboardType: TextInputType.number, controller: cenaController),
              TextField(decoration: InputDecoration(labelText: "Poznámka", border: OutlineInputBorder()), keyboardType: TextInputType.text, controller: poznamkaController),
              CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(1970, 1, 1), lastDate: DateTime.now(), onDateChanged: (DateTime newDate){setState(() {_datum = newDate;});}),
              ElevatedButton(onPressed: _ulozZaznam, child: Text("Uložit")),
            ],
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _prumernaCena = 0.0;
  double _prumernaSpotreba = 0.0;
  final List<Zaznam> _seznamZaznamu = [];

  void _vypocitej() {
    int i = 0;
    _prumernaSpotreba = 0.0;
    for (Zaznam zaznam in _seznamZaznamu){
      if (i >= 1) {
        _prumernaSpotreba += 100*_seznamZaznamu[i-1]._palivo/(zaznam._stavTachometru - _seznamZaznamu[i-1]._stavTachometru);
      }
      _prumernaCena += zaznam._cena;
      i++;
    };
    _prumernaCena = _prumernaCena/_seznamZaznamu.length;
    _prumernaSpotreba = _prumernaSpotreba/(_seznamZaznamu.length-1);
    print(_prumernaCena.toString());
    print(_prumernaSpotreba.toString());
    _prumernaCena = double.parse(_prumernaCena.toStringAsFixed(2));
    _prumernaSpotreba = double.parse(_prumernaSpotreba.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        title: Text(widget.title, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 500,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("Informace o vozidle:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
                        Text("Průmerná spotřeba vozidla: $_prumernaSpotreba l/100 km"),
                        Text("Průměrná cena za litr: $_prumernaCena Kč"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Záznamy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _seznamZaznamu.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_seznamZaznamu[index]._datum.day.toString()+". "+_seznamZaznamu[index]._datum.month.toString()+". "+_seznamZaznamu[index]._datum.year.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Litrů: "+_seznamZaznamu[index]._palivo.toString()+" l"),
                          Text("Cena: "+_seznamZaznamu[index]._cena.toString()+" Kč/l"),
                          Text("Stav tachometru: "+_seznamZaznamu[index]._stavTachometru.toString()+" km"),
                          Text("Poznámka: "+_seznamZaznamu[index]._poznamka),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AppPage()));
          if (!context.mounted) return;
          _seznamZaznamu.add(result);
          if (_seznamZaznamu.length >= 2) {_vypocitej();}
          setState(() {});
        },
        tooltip: 'Přidat záznam',
        child: const Icon(Icons.add),
      ),
    );
  }
}
