# NOVA PULSE

**Your life. Under control.** Eine local-first Lifestyle- und Produktivitäts-PWA, die NOVAs Nachrichten- und Kalenderidee mit PULSEs persönlichem Tages-Dashboard verbindet.

## Features in v1.0

- Dashboard mit Daily Pulse, Terminen, Aufgaben, Routinen und Monats-Finanzüberblick
- Lokaler Assistent mit Kontext aus NOVA-Kalender, Aufgaben und Routinen
- Nachrichtenanalyse mit Absichtserkennung und bearbeitbaren Antwortvorschlägen
- Monatskalender mit Terminverwaltung, Löschen und `.ics`-Export
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


## Version 1.1.0

- Fixed relative calendar queries: NOVA now resolves today, tomorrow, the day after tomorrow, explicit German dates (DD.MM[.YYYY]) and upcoming weekdays before filtering events.
- Added an all-day event option. All-day events do not require a time and are exported as proper date-only iCalendar events.
- Added a persistent light theme toggle in Settings; Dark Mode remains available.
- Service-worker cache version bumped so deployed clients can receive the update.

After uploading this update to the `main` branch, reload the website. If an installed PWA still shows the old version, close it fully and reopen it; on desktop, a hard refresh may be needed once.
