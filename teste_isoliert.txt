Warum?
- mock und stub, um externe System und lang laufende (oder forked) Prozesse zu vermeiden

Probleme
- ich laufe Gefahr, zu sehr die Implementierung zu testen
  -> finde ein gutes Mittelmaß zwischen zu viel und zu wenig Gemocke
- wenn ich die Implementierung ändere, muss ich die Tests anpassen, obwohl 
  sich die Schnittstelle bzw. das Verhalten nicht geändert haben
  -> Mittelmaß finden!
  