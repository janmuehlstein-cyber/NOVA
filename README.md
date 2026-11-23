# NOVA PULSE

**Your life. Under control.** Eine local-first Lifestyle- und Produktivitäts-PWA, die NOVAs Nachrichten- und Kalenderidee mit PULSEs persönlichem Tages-Dashboard verbindet.

## Features in v2.0.0

- Dashboard mit Daily Pulse, Terminen, Aufgaben, Routinen und Monats-Finanzüberblick
- Lokaler Assistent mit Kontext aus NOVA-Kalender, Aufgaben und Routinen
- Nachrichtenanalyse mit Absichtserkennung und bearbeitbaren Antwortvorschlägen
- Monatskalender mit Erstellen, Bearbeiten, Löschen und `.ics`-Export
- Aufgabenliste mit Fälligkeit und Erledigt-Status
- Routinen-Tracker mit täglichem Abhaken
- Manuelle Einnahmen-/Ausgabenübersicht
- Einstellungen, JSON-Backup und -Restore
- Responsive iPhone-/Desktop-Oberfläche
- Installierbare PWA mit Offline-App-Shell
- Keine Anmeldung, kein Tracking, keine externe Datenbank

## Lokal starten

`index.html` im Browser öffnen. Für PWA-Installation und Offline-Caching über einen lokalen Webserver oder GitHub Pages bereitstellen.

## Auf GitHub Pages veröffentlichen

1. ZIP entpacken.
2. Den **Inhalt des Ordners `nova-pulse`** ins Root-Verzeichnis eines GitHub-Repositories hochladen (z. B. `nova-pulse`).
3. In GitHub unter **Settings → Pages** `Deploy from a branch` auswählen.
4. Branch `main`, Ordner `/ (root)` auswählen und speichern.
5. Nach dem Deployment die Pages-URL auf dem iPhone in Safari öffnen → Teilen → **Zum Home-Bildschirm**.

## Datenschutz & wichtige Grenzen

- Kalender, Routinen, Aufgaben, Buchungen, Chatverlauf und Einstellungen werden in `localStorage` dieses Browsers gespeichert. Sie werden nicht mit GitHub synchronisiert.
- GitHub Pages veröffentlicht den Quellcode öffentlich. Niemals private Nachrichten, Backups, API-Schlüssel oder persönliche Daten ins Repository hochladen.
- Die Nachrichtenanalyse und der Assistent sind in dieser Version lokal und regelbasiert. Es gibt noch keine echte generative KI.
- WhatsApp wird nicht direkt ausgelesen oder gesteuert. Nachrichten werden vom Nutzer manuell eingefügt.
- Termine werden nur nach einer bewussten Aktion des Nutzers lokal angelegt. Es gibt keine automatische Kalenderänderung.
- Der NOVA-Kalender ist zunächst ein eigener lokaler Kalender. `.ics`-Export ermöglicht den Import in Apple Kalender; eine direkte bidirektionale iCloud-Synchronisierung ist nicht enthalten.
- Finanzen werden manuell erfasst. Es gibt keine Bankanbindung und keine Anlageberatung.
- Google Fonts wird für optionale Schriftgestaltung eingebunden; bei Offline-Nutzung greift die Systemschrift.

## Architektur

Statische PWA ohne Build-Schritt: HTML, CSS und Vanilla JavaScript. Dadurch ist das Projekt leicht zu verstehen, zu hosten und zu erweitern.

## Nächste Ausbaustufen

1. Geschütztes Backend für echte KI (API-Key ausschließlich serverseitig)
2. Apple Kalender / CalDAV-Synchronisierung mit expliziter Freigabe und Bestätigung vor dem Erstellen
3. Optionales Wetter-Modul mit bewusst ausgelöster Standortfreigabe
4. Aufgaben mit Priorität, Projekten und Erinnerungen
5. Automatisierte Tests und robuste lokale Datenmigration

## Lizenz

Private Projektbasis. Vor einer öffentlichen Weiterverwendung Lizenz ergänzen.


## Version 1.2.0 – Fehlerbehebungen und Kalender-Update

- Relative Datumsabfrage korrigiert: „übermorgen“ wird mit Unicode-sicherer Worterkennung erkannt und nicht mehr mit „morgen“ verwechselt.
- NOVA filtert Kalendertermine nach dem ermittelten lokalen Datum; unterstützt „heute“, „morgen“, „übermorgen“, Datumsangaben und kommende Wochentage.
- Hellmodus-Schalter ist jetzt dauerhaft direkt in der oberen Leiste sichtbar und zusätzlich in den Einstellungen vorhanden. Die Auswahl bleibt lokal gespeichert.
- Ganztägige Termine blenden die Uhrzeit aus und benötigen keine Uhrzeit. Die Speicherung und der `.ics`-Export verwenden ein echtes Datum-ohne-Uhrzeit-Format.
- Termine können im Kalender bearbeitet und gelöscht werden.
- Service Worker verwendet eine neue Cache-Version, aktiviert sich sofort und prüft HTML/CSS/JavaScript bevorzugt frisch vom Server, damit alte App-Versionen nicht weiter angezeigt werden.

### Update auf GitHub Pages

1. ZIP entpacken und alle Dateien aus `nova-pulse` in das Root-Verzeichnis des bestehenden Repositorys hochladen.
2. Vorhandene Dateien ersetzen und den Upload committen.
3. Website neu laden. Falls eine installierte PWA noch die alte Version zeigt: App vollständig schließen und erneut öffnen; notfalls die Website einmal in Safari neu laden.


## Version 2.0.0 – Apple Kalender Bridge (iOS companion)

- Added an Apple Calendar connection panel in Settings.
- Added a native WebKit message bridge for EventKit.
- Apple events are listed beside local NOVA events in the calendar and can be refreshed manually or when opening the calendar.
- New events can be saved to NOVA locally or to Apple Calendar.
- Existing Apple events can be edited and deleted from NOVA. Every Apple create, edit, or delete operation requires an additional confirmation dialog.
- Uses EventKit full access because bidirectional read/write/edit/delete requires it; permission is requested only after the user taps Connect (or explicitly chooses Apple Calendar when saving an event).
- Added `ios/NOVAPulse.xcodeproj` and native Swift source.

### Important: native iPhone app required

The GitHub Pages PWA running in Safari cannot directly access EventKit. Direct Apple Calendar integration works only inside the supplied native iOS WebView app. Open `ios/NOVAPulse.xcodeproj` on a Mac with Xcode 15+ and build it for iOS 17+. The current Windows + iPhone setup can publish and use the PWA, but cannot compile/sign the native iOS app without access to a Mac/Xcode build environment. This ZIP contains the source project, not a signed IPA.

The native WebView uses the existing GitHub Pages address configured in `ios/NOVAPulse/CalendarWebView.swift`. If the repository URL changes, update that URL and the allowed host there. The native app has separate WebView storage from Safari; export a NOVA JSON backup in Safari and import it into the native app if you want to transfer local NOVA data. Apple Calendar events themselves remain in Apple's calendar database.

### Permission and privacy

- iOS displays the calendar permission prompt. NOVA does not collect Apple ID credentials or iCloud passwords.
- Full access is required for the requested read, create, update, and delete workflow.
- A separate in-app confirmation appears before each Apple Calendar mutation.
- The iOS bridge only accepts messages from the bundled NOVA WebView; external links open outside the WebView.
- Synchronization is refreshed when opening the calendar and with the Synchronize button; this version does not run background sync while the app is closed.


## Version 2.0.1 – Mobile-Ansicht

- Mobile Hauptnavigation entspricht jetzt den sechs Hauptbereichen der Desktop-Seitenleiste.
- Beschriftungen und Symbole wurden für schmale iPhone-Bildschirme angepasst.
- Das übergroße dekorative Sternsymbol im Dashboard wurde entfernt.
- Cache-Version erhöht, damit Browser die aktualisierten Dateien neu laden.


## Version 2.1.0 – Verbesserungen

- Lokale NOVA-Termine können wöchentlich, monatlich oder jährlich wiederholt werden. Die Wiederholungen erscheinen in der Kalenderansicht und im ICS-Export.
- Apple-Kalender-Wiederholungen werden in dieser Version noch nicht über die native EventKit-Brücke geschrieben. Wiederholungen sind deshalb derzeit auf lokale NOVA-Termine beschränkt.
- Bearbeitete Antwortvorschläge können als lokale Lernbeispiele gespeichert werden. NOVA kann passende gespeicherte Beispiele bei späteren ähnlichen Eingaben wiederverwenden. Das ist ein begrenztes lokales Lernsystem, kein Training eines KI-Modells.
- Die Assistenz erkennt einfache Einladungen mit Datumsbezug und gleicht sie mit NOVA-Terminen ab. Sie formuliert eine Zu- oder Absage als Vorschlag; sie verschickt keine Nachricht und verändert keine Termine.
- Die Unterhaltung wurde um weitere regelbasierte Alltagsantworten erweitert. Eine frei generierende KI ist weiterhin nicht eingebunden; dafür wäre ein sicherer Backend-Dienst nötig.
