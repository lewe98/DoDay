# CS2365 Swift-Programmierung unter iOS
## DoDay

> Do it. Today.

Die DoDay-App bietet Nutzern täglich neue Aufgaben, die über den Tag bewältigt werden sollen.
Ein Social-Feature und diverse Statistiken steigert die Motivation, die ausgesuchten Aufgaben auch tatsächlich abzuarbeiten.



## Gruppenmitglieder
* Julian Hermanspahn
* Lewe Lorenzen
* Thomas Raab



## Inhalt
* [Featurebeschreibung](#features)
* [Featureliste](#featureliste)
* [Softwareentwicklungsprozess](#softwareentwicklungsprozess)
* [Technologie-Stack](#technologie-stack)
* [Installationsanleitung](#installationsanleitung)
* [Ordnerstruktur](#ordnerstruktur)
* [Fazit](#fazit)



## Features
Die Features der App lassen sich grob in vier Themengebiete, die auch den Tabs entsprechen, gliedern:
### Allgemein
Nach einem Welcome-Screen hat der Nutzer die Möglichkeit sich zu Registrieren.

### Aufgaben
Der Nutzer wählt täglich eine von zwei aus der Datenbank gelesenen Aufgaben aus, die er an diesem Tag abarbeiten möchte. Die ausgewählte Aufgabe kann dann als erledigt, nicht erledigt und zum verschieben markiert werden.

### Statistiken
Über verschiedene Statistiken, teils grafisch und teils textuell, verschafft sich der Nutzer einen Überblick über seine erledigten Aufgaben und bleibt motiviert.

### Freunde
Das Social-Feature bietet das Hinzufügen von Freunden, Teilen der aktuellen Aufgabe und das Vergleichen mit anderen Nutzern. Über diese Funktionalität sollen sich Nutzer gegenseitig motivieren, mitzuziehen und die täglichen Aufgaben zu erledigen.

### Einstellungen
Tägliche Erinnerungen zur gewünschten Zeit, eigene Aufgaben einreichen und technische Features wie das Zurücksetzen der Statistik oder Nachlesen der Datenschutzbestimmungen runden die App ab.


## Featureliste
- Welcome Screen
- Registrieren
  - Eingabe des Namens
  - Akzeptieren der Datenschutzhinweise
  - Persistentes Speichern des Users
  - Einloggen mit Vendor-ID (ohne lästiges Passwort)
- Aufgaben
  - Persönliche Ansprache des Nutzers
  - Anzeigen zweier Aufgaben
  - Auswählen der Tagesaufgabe
  - Anzeigen der ausgewählten Aufgabe
  - Aufgabe als fertig, aufgeschoben oder nicht geschafft markieren
- Statistiken
  - Ausgabe des aktuellen Streaks
  - Ausgabe der insgesamt erledigten Aufgaben
  - Ausgabe der Statistik zu erledigten, nicht erledigten und aufgeschobenen Aufgaben (grafische Ausgabe)
  - Ausgabe der zuletzt erledigten Aufgabe
- Freunde
  - Erzeugen eines Freundescodes
  - Ausgabe des eigenen Freundescodes
  - Freundescode in Zwischenablage speichern
  - Freunde hinzuzufügen
  - Dynamisch erzeugte Liste aller Freunde
    - Name des Freundes
    - Aktuelle Aufgabe des Freundes
    - Erledigte Aufgaben des Freundes
  - Freunde herausfordern (Teilen-Funktion mit dynamischem Text, der die aktuelle Aufgabe beinhaltet)
- Einstellungen
  - Notification
    - an- und ausschaltbar
    - Wahl der Uhrzeit
  - Einsenden eigener Aufgaben
  - Zurücksetzen der Statistiken
  - Impressum als Web-View
  - Datenschutz als Web-View
Des Weiteren werden sämtliche Einstellungen und Änderungen an Aufgaben, Usern etc. persistent (z. B. via FireBase) gespeichert.



## Softwareentwicklungsprozess
Zu Beginn des Entwicklungsprozesses hat das Team sämtliche Aufgaben in Trello aufgeschrieben und priorisiert.
Zum Start des ersten der wöchentlichen Sprints hat das Team gemeinsam Aufgaben verteilt, die für alle zu einem ähnlichen Workload führten.
Die verteilten Aufgaben sollten bis Sprintende (eine Woche, je von Donnerstag bis Donnerstag) erledigt sein. An Montagen hat sich das Team zudem verbindlich getroffen und ist eventuelle Probleme und den aktuellen Stand durchgegangen. Zwischenzeitlich fand eine Kommunikation über die gemeinsame WhatsApp-Gruppe statt.
Nach dem dritten Sprint einigte sich das Team auf einen Wechsel von der autonomen Arbeitsweise zur Pair-Programming-Methode (per Zoom), um auftretende Problemstellungen besser zu bearbeiten.

Die App wurde durchgängig von allen drei Gruppenmitgliedern zu gleichen Teilen entwickelt. Aktuelle Entwicklungsstände wurden auf Branches in Git gepusht. Fertige Aufgaben wurden im Canban-Board Trello entsprechend von "In Progress" zu "Review" bewegt. Die reviewten Änderungen wurden anschließend in den "Staging"-Branch gemerged. Kritische Issues wurden nach Absprache ebenfalls in Git als Issues angelegt.


## Technologie-Stack
Technologie | Verwendungszweck
---------------------|----------
[Xcode 11.5](https://developer.apple.com/xcode/) | Entwicklungsumgebung
[Swift 4](https://www.apple.com/de/swift/) | Programmiersprache
[SwiftUIX](https://github.com/SwiftUIX/SwiftUIX) | Frontend Development
[Firebase](https://firebase.google.com/docs/firestore) | Datenbank mit Cloud Firestore
[Local Notifications](https://developer.apple.com/documentation/usernotifications) | Benachrichtigungen
[UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) | Persistierung der Einstellungen des Nutzers
[Core Data](https://developer.apple.com/documentation/coredata) | Datensicherung für offline Nutzung



## Installationsanleitung
### Das Repository mithilfe von Xcode klonen:

Xcode öffnen > ``Clone an existing project`` > ``https://git.thm.de/jhmn46/itask`` > master oder staging branch auswählen

### Cocoa Pods installieren:
Sobald das Repository geklont wurde, alle aktiven Xcode Fenster schließen. 
Im Anschluss mithilfe des Terminals in den Projektordner navigieren und ``$ pod install`` ausführen.
Dadurch werden die in der ``Podfile`` eingetragenen Abhängigkeiten installiert.
Diese werden mithilfe des CocoaPods dependency manager geladen. 
Sollte CocoaPods noch nicht installiert sein, muss folgender Befehl im Terminal eingegeben werden: ``$ sudo gem install cocoapods``.

### Das Projekt öffnen:
Durch die Installation der Abhängigkeiten wird eine ``.xcworkspace`` Datei generiert.
Diese wird in Zukunft verwendet, um das Projekt zu öffnen.
``New Scheme...`` > Target: iTask > Name: iTask



## Ordnerstruktur
```iTask
├── iTask
│   ├── InitViews
│   │   ├── ContentView.swift (View für registrierte Nutzer)
│   │   ├── Register.swift (Registrierungs-Formular)
│   │   ├── Loading.swift (Ladebildschirm)
│   ├── TabBar
│   │   ├── HeuteView.swift (View für die täglichen Aufgbane)
│   │   ├── UebersichtView.swift (View für Statistiken)
│   │   ├── FreundeView.swift (View für Freunde)
│   │   ├── EinstellungenView.swift (View für Einstellungen)
│   ├── EinstellungenViews
│   │   ├── ImpressumWebview.swift (Webview mit Impressum)
│   │   ├── DatenschutzWebview.swift (Webview mit Datenschutzangaben)
│   │   ├── AufgabenEinreichenView.swift (Sheet zum Einreichen von Aufgaben)
│   ├── Models
│   │   ├── UserModel.swift (Model des Users)
│   │   ├── AufgabenModel.swift (Model der Aufgaben)
│   ├── Services
│   │   ├── FirebaseFunctions.swift (Sämtliche Firebase Funktionen)
│   │   ├── CoraDataFunctions.swift (Sämtliche CoreData Funktionen)
│   │   ├── GlobalFunctions.swift (Ausgelagerte, globale Funktionen)
│   ├── BodyViews
│   │   ├── AktuellFirstView.swift (View für Auswahl zwischen heutigen Aufgaben)
│   │   ├── AktuellSecondView.swift (View für Anzeige ausgewählter Aufgabe)
│   │   ├── AufgabeDetail.swift (Eigentliche Aufgabe, wird eingebunden)
│   │   ├── NavigationConfigurator.swift (ViewController für das Heute-Tab)
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── FreundeHinzufuegenView.swift (Sheet zum Hinzufuegen von Freunden)
│   ├── LaunchScreen.storyboard (verantwortlich für Launchscreen)
│   ├── Einstellungen.swift (Verwaltung sämtlicher persistent gespeicherter Einstellungen)
│   ├── info.plist
│   ├── GoogleService-info.plist
│   ├── iTask.xcdatamodeld.plist
│   ├── Assets.xcassets
│   ├── Preview Content
│   │   ├── Preview Assets.xcassets
├── iTaskTests
│   ├── iTaskTests.swift (Test-File)
│   ├── info.plist
├── iTaskUITests
│   ├── iTaskUITests.swift (UI-Test-File)
│   ├── info.plist
├── Products
│   ├── DoDay.app (eigentliche App)
│   ├── iTaskTests.xctest
│   ├── iTaskUITests.xctest
├── Pods
├── Frameworks
```



## Fazit
#### Julian Hermanspahn
Lorem Ipsum

#### Lewe Lorenzen
Lorem Ipsum


#### Thomas Raab
Das Arbeiten im Team hat trotz Corona-Pandemie gut funktioniert. Die digitale Abstimmung war mit der Verwendung der entsprechenden Tools (git, Trello – aber auch z. B. Zoom) konsequent möglich.

Schwierigkeiten traten bei der Problembehandlung innerhalb XCodes auf. Ungenaue Fehlermeldung und eine schlechte Dokumentation bzw. wenig Foreneinträge zu SwiftUI führten zur frustrierenden Fehlersuche. Nach unserem Umstieg auf Pair-Programming per Zoom ließen sich auch hier Lösungen finden.

Insgesamt bin ich mit dem Ergebnis des Projekts mehr als zu frieden und freue mich sehr auf weitere Arbeiten mit diesem motivierten Team.
