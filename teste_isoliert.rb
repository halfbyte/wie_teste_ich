# Warum?
# - mock und stub, um externe System und lang laufende (oder forked) Prozesse zu vermeiden

# Probleme
# - ich laufe Gefahr, zu sehr die Implementierung zu testen
#   -> finde ein gutes Mittelmaß zwischen zu viel und zu wenig Gemocke
# - wenn ich die Implementierung ändere, muss ich die Tests anpassen, obwohl 
#   sich die Schnittstelle bzw. das Verhalten nicht geändert haben
#   -> Mittelmaß finden!

# TODO: an dieser Stelle kann man sehr einen Controller-Tests zeigen und dabei 
# demonstrieren, wie man die Models und die Zugriffe auf die Datenbank wegmockt [thorsten, 27.05.2008]

# TODO: ausserdem kann man einen Model-Test zeigen, wie z.B. die Youtube-API weggemockt
# wird (Validierung, ob eine Video-ID auch existiert) [thorsten, 27.05.2008]
