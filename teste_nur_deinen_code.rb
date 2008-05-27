# - nicht Plugins, Gems oder gar Rails selber
# * Keinen Framework-Code Testen
#   * Assoziationen
#     * reflect_on
#     * respond_to reicht nicht aus, weil has_one/belongs_to nicht trennbar ist über den assoc-proxy
#     -> screencast gucken
#     -> Plugin extrahieren
#   * Validations
#     * validation_reflections
# TODO: was meinst du mit den Punkten? [thorsten, 27.05.2008]

# Warum?
# - weil diese schon - zumindest meistens ;-) - gut genug getestet sind
# - neu ist doch nur der eigene Code

# Probleme:
# - woran macht man fest, dass man nur den eigenen Code testet?

# TODO: Negativbeispiel zeigen [thorsten, 27.05.2008]