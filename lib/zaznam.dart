class Zaznam {
  int _stavTachometru;
  double _palivo;
  double _cena;
  String _poznamka;
  DateTime _datum;

  Zaznam(this._stavTachometru, this._palivo, this._cena, this._poznamka, this._datum);

  DateTime get datum => _datum;

  set datum(DateTime value) {
    _datum = value;
  }

  String get poznamka => _poznamka;

  set poznamka(String value) {
    _poznamka = value;
  }

  double get cena => _cena;

  set cena(double value) {
    _cena = value;
  }

  double get palivo => _palivo;

  set palivo(double value) {
    _palivo = value;
  }

  int get stavTachometru => _stavTachometru;

  set stavTachometru(int value) {
    _stavTachometru = value;
  }
}