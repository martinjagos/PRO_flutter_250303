import 'package:flutter/material.dart';
import 'zaznam.dart';
import 'addPage.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Spotřeba Vozidla'),
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
    if (_seznamZaznamu.length >= 2) {
      int i = 0;
      _prumernaSpotreba = 0.0;
      _prumernaCena = 0.0;
      double _pocetLitru = 0.0;
      for (Zaznam zaznam in _seznamZaznamu){
        _pocetLitru += _seznamZaznamu[i].palivo;
        _prumernaCena += zaznam.cena;
        i++;
      };
      _prumernaSpotreba = _pocetLitru*100/(_seznamZaznamu[_seznamZaznamu.length-1].stavTachometru - _seznamZaznamu[0].stavTachometru);
      _prumernaCena = _prumernaCena/_seznamZaznamu.length;
      _prumernaCena = double.parse(_prumernaCena.toStringAsFixed(2));
      _prumernaSpotreba = double.parse(_prumernaSpotreba.toStringAsFixed(2));
    }
  }
  void _odstranZaznam(index) {
    _seznamZaznamu.removeAt(index);
    setState(() {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72.0,
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
                          child: const Text("Informace o vozidle:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
                        Text("Průmerná spotřeba vozidla: $_prumernaSpotreba l/100 km"),
                        Text("Průměrná cena za litr: $_prumernaCena Kč"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: const Text("Záznamy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),
              ),
              _seznamZaznamu.length == 0 ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Center(child: Text("Nic tady zatím není, přidejte záznam kliknutím na tlačítko +", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)),
              ) : Expanded(
                child: ListView.builder(
                  itemCount: _seznamZaznamu.length,
                  itemBuilder: (context, index) {
                    int _reverseIndex = _seznamZaznamu.length -1 -index;
                    return ListTile(
                      trailing: Wrap(
                        children: <Widget>[
                          IconButton(onPressed: _vypocitej, icon: Icon(Icons.edit)),
                          IconButton(onPressed: ()=>_odstranZaznam(_reverseIndex), icon: Icon(Icons.delete, color: Colors.red)),
                        ],
                      ),
                      title: Text(_seznamZaznamu[_reverseIndex].datum.day.toString()+". "+_seznamZaznamu[_reverseIndex].datum.month.toString()+". "+_seznamZaznamu[_reverseIndex].datum.year.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Litrů: "+_seznamZaznamu[_reverseIndex].palivo.toString()+" l"),
                          Text("Cena: "+_seznamZaznamu[_reverseIndex].cena.toString()+" Kč/l"),
                          Text("Stav tachometru: "+_seznamZaznamu[_reverseIndex].stavTachometru.toString()+" km"),
                          Text("Poznámka: "+_seznamZaznamu[_reverseIndex].poznamka),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
