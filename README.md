## DoDay - Do it. Today.
###### *CS2365 Swift-Programmierung unter iOS - Sommersemester 2020*

> Die DoDay-App bietet Nutzern täglich neue Aufgaben, die über den Tag bewältigt werden sollen.
  Ein Social-Feature und diverse Statistiken steigern die Motivation, die gewählten Aufgaben zu bewältigen.



![Aufgabe](./dok-files/aufgabePic.png)
<img src="./dok-files/aufgabe.png"/>



## Gruppenmitglieder
* Julian Hermanspahn (Freundescode: Gj1DYJw3)
* Lewe Lorenzen (Freundescode: QLu11B8R)
* Thomas Raab (Freundescode: 9hPjgSEC)



## Inhalt
* [Überblick](#überblick-über-die-app)
* [Featureliste](#featureliste)
* [Softwareentwicklungsprozess](#softwareentwicklungsprozess)
* [Technologie-Stack](#technologie-stack)
* [Installationsanleitung](#installationsanleitung)
* [Hinweise zum Testen](#hinweise-zum-testen)
* [Ordnerstruktur](#ordnerstruktur)
* [Fazit](#fazit)



## Überblick über die App
- Launch
    - Nach der Darstellung des Launch Screens hat der Nutzer die Möglichkeit sich zu registrieren.
- Aufgaben
    - Der Nutzer wählt täglich eine von zwei Aufgaben aus, die er an diesem Tag abarbeiten möchte.
      Die ausgewählte Aufgabe kann dann als erledigt, nicht erledigt und zum verschieben markiert werden.
- Statistiken
    - Über verschiedene Statistiken verschafft sich der Nutzer einen Überblick über seine erledigten Aufgaben und bleibt motiviert.
- Freunde
    - Das Social-Feature bietet das Hinzufügen von Freunden und das Teilen der aktuellen Aufgabe.
      Über diese Funktionalität sollen sich Nutzer gegenseitig motivieren, die täglichen Aufgaben zu erledigen.
- Einstellungen
    - Tägliche Erinnerungen zur gewünschten Zeit, eigene Aufgaben einreichen, das Zurücksetzen der Statistiken oder
      das Nachlesen der Datenschutzbestimmungen runden die App ab.



## Featureliste
- über 40 Aufgaben, die erledigt werden können
- Light Mode & Dark Mode
- Launch Screen
- Registrieren
  - Eingabe des Nutzernamens
  - Akzeptieren der Datenschutzhinweise
  - Persistentes Speichern des Users
  - Einloggen mit Vendor-ID
- Aufgaben
  - Anzeigen zweier Aufgaben
  - Auswählen der Tagesaufgabe
  - Anzeigen von Details und Statistiken einer Aufgabe
  - Aufgabe als fertig, aufgeschoben oder nicht geschafft markieren (Sounds)
- Statistiken
  - Darstellung der aktuellen Streak
  - Anzahl der insgesamt erledigten Aufgaben
  - Statistik der erledigten, nicht erledigten und aufgeschobenen Aufgaben (Animationen)
  - Liste der zuletzt erledigten Aufgabe
- Freunde
  - Erzeugen eines Freundescodes
  - Ausgabe des eigenen Freundescodes
  - Freundescode in Zwischenablage speichern
  - Freunde hinzuzufügen
  - Liste aller Freunde
    - Name des Freundes
    - Aktuelle Aufgabe des Freundes
    - Anzahl der erledigten Aufgaben des Freundes
  - Freunde herausfordern (Teilen-Funktion mit dynamischem Text, der die aktuelle Aufgabe beinhaltet)
- Einstellungen
  - Local Notification
    - an- und ausschaltbar
    - Wahl der Uhrzeit
  - Einsenden eigener Aufgaben
  - Zurücksetzen der Statistiken
  - Impressum als Web-View
  - Datenschutz als Web-View



## Softwareentwicklungsprozess
Zu Beginn des Entwicklungsprozesses hat das Team sämtliche Aufgaben in Trello aufgeschrieben und priorisiert.
Zum Start des ersten Sprints hat das Team gemeinsam Aufgaben verteilt, die für alle zu einem ähnlichen Workload führten.
Die verteilten Aufgaben sollten bis Sprintende (eine Woche, je von Donnerstag bis Donnerstag) erledigt sein.
An Montagen hat sich das Team zudem verbindlich getroffen und hat eventuelle Probleme und den aktuellen Stand besprochen.
Die Kommunikation fand über die gemeinsame WhatsApp-Gruppe oder über Zoom statt.
Nach dem dritten Sprint einigte sich das Team auf einen Wechsel von der autonomen Arbeitsweise zur Pair-Programming-Methode,
um auftretende Problemstellungen besser zu bearbeiten.

Die App wurde durchgängig von allen drei Gruppenmitgliedern zu gleichen Teilen entwickelt. Aktuelle Entwicklungsstände wurden auf Branches in Git gepusht.
Fertige Aufgaben wurden im Canban-Board Trello entsprechend von "In Progress" zu "Review" bewegt. Die reviewten Änderungen wurden anschließend in den "Staging"-Branch gemerged.
Kritische Issues wurden nach Absprache ebenfalls in Git als Issues angelegt.



## Technologie-Stack
Technologie | Verwendungszweck
---------------------|----------
[Xcode 11.5](https://developer.apple.com/xcode/) | Entwicklungsumgebung
[Swift 4](https://www.apple.com/de/swift/) | Programmiersprache
[SwiftUIX](https://github.com/SwiftUIX/SwiftUIX) | Frontend Development
[Firebase](https://firebase.google.com/docs/firestore) | Datenbank mit Cloud Firestore
[Local Notifications](https://developer.apple.com/documentation/usernotifications) | Benachrichtigungen
[Working with Sound](https://developer.apple.com/documentation/avfoundation/avaudioplayer) | Sound-Feedback
[SwiftUI Animations](https://developer.apple.com/tutorials/swiftui/animating-views-and-transitionss) | Frontend Development
[UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) | Persistierung der Einstellungen des Nutzers
[Core Data](https://developer.apple.com/documentation/coredata) | Datensicherung für offline Nutzung



## Installationsanleitung
- Das Repository mithilfe von Xcode klonen:
    - Xcode öffnen > ``Clone an existing project`` > ``https://git.thm.de/jhmn46/itask`` > master oder staging branch auswählen

- Cocoa Pods installieren:
    - Sobald das Repository geklont wurde, alle aktiven Xcode Fenster schließen. 
      Im Anschluss mithilfe des Terminals in den Projektordner navigieren und ``$ pod install`` ausführen.
      Dadurch werden die in der ``Podfile`` eingetragenen Abhängigkeiten installiert.
      Diese werden mithilfe des CocoaPods dependency manager geladen. 
      Sollte CocoaPods noch nicht installiert sein, muss folgender Befehl im Terminal eingegeben werden: ``$ sudo gem install cocoapods``.

- Das Projekt öffnen:
    - Durch die Installation der Abhängigkeiten wird eine ``.xcworkspace`` Datei generiert.
      Diese wird in Zukunft verwendet, um das Projekt zu öffnen.
      ``New Scheme...`` > Target: iTask > Name: iTask



## Ordnerstruktur
```iTask
├── iTask
│   ├── Confetti
│   │   ├── ParticlesEmitter.swift (Logik, um Partikeleffekte zu generieren)
│   │   ├── Confetti.swift (Darstellung der Partikeleffekte)
│   ├── Sound
│   │   ├── success.mp3 (Audio-Datei)
│   │   ├── failure.mp3 (Audio-Datei)
│   │   ├── later.mp3 (Audio-Datei)
│   │   ├── plop.mp3 (Audio-Datei)
│   │   ├── reset.mp3 (Audio-Datei)
│   │   ├── PlaySound.swift (Funktion, um sämtliche Sounds abzuspielen)
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
│   │   ├── Einstellungen.swift (Verwaltung sämtlicher persistierter Einstellungen)
│   ├── FreundeViews
│   │   ├── FreundeHinzufuegenView.swift (Sheet zum Hinzufuegen von Freunden)
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
│   │   ├── Additives_diagramm.swift (Diagramm, um Statistiken darzustellen)
│   │   ├── NavigationConfigurator.swift (ViewController für das Heute-Tab)
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── LaunchScreen.storyboard
│   ├── info.plist
│   ├── GoogleService-info.plist
│   ├── iTask.xcdatamodeld
│   ├── Assets.xcassets
│   ├── Preview Content
│   │   ├── Preview Assets.xcassets
├── Products
│   ├── DoDay.app
├── Pods
├── Frameworks
```



## Fazit
#### Julian Hermanspahn
Insgesamt hat mir die Veranstaltung sehr gut gefallen. Positiv hervorheben möchte ich, dass wir die gelernten Inhalte direkt umsetzen durften (Wahrzeichen, Core Data, etc.). Auch die Einteilung in Expertengruppen war eine tolle Idee. So hat man sich intensiv mit einem Thema beschäftigt und konnte sich sehr gut darin vertiefen. Allerdings gab es keine "Qualitätssicherung", wodurch man nicht wusste, ob man die Inhalte einer Expertengruppe "bedenkenlos" übernehmen konnte. Ich hätte mir insgesamt mehr Vorlesungen und Unterlagen gewünscht, um aus einer größeren Menge an Vorlagen und Hilfestellungen schöpfen zu können. 

Natürlich ist es nicht möglich, eine komplette Programmiersprache innerhalb weniger Wochen zu vermitteln, daher sind natürlich öfters Probleme bei der Bearbeitung des persönlichen Projekts aufgetreten. Dadurch wurde der Workflow gestört und wir haben uns an gewissen Problemen die Zähne ausgebissen. Ich mir gewünscht, dass z.B. einmal pro Woche eine Sprechstunde mit den Dozenten stattgefunden hätte, um größere "Leerläufe" zu vermeiden. Allerdings wurde man auf diese Weise geschult, sich selbstständig in fremde Sachverhalte einzuarbeiten.
Außerdem konnte man sich innerhalb des Teams durch eine gute Zusammenarbeit in vielen Bereichen ergänzen und weiterhelfen.


#### Lewe Lorenzen
Das Team war sehr motiviert ein gutes Ergebnis zu erarbeiten. Die Arbeit mit XCode und der Anbindung an Firebase stellte sich jedoch als Herausforderung raus. Dies kostete anfangs viel Zeit, sodass das Projekt öfter zum stehen kam. Als es jedoch in den letzten Wochen gelöst werden konnte, wurden anschließend noch viele Features hinzugefügt.

Die fehlende Möglichkeit sich für das Projekt zu treffen war eine Herausforderung.
Durch die Flexibilität des Teams konnten jedoch oft schnell Meetings auf Zoom vereinbart werden. Dies den Vorteil hatte jederzeit kurz Rücksprache zu halten.

Abschließend bin ich mit dem Ergebnis des Projektes sehr zufrieden. Wir konnten unsere Erwartungen erfüllen sowie viele neue Kenntnisse durch das eigene Problem lösen erlangt habe.

Ein Technologie Verständnis wäre bei Folgenden Punkten noch interessant gewesen:
- Callback bzw. asynchrone Funktionen
- Die unterschiede der Anwendungsfälle von  @Enviromentalobject/@State/@Binding
- Debüt mit CoreData-Werten



#### Thomas Raab
Das Arbeiten im Team hat trotz Corona-Pandemie gut funktioniert. Die digitale Abstimmung war mit der Verwendung der entsprechenden Tools (git, Trello – aber auch z. B. Zoom) konsequent möglich.

Schwierigkeiten traten bei der Problembehandlung innerhalb XCodes auf. Ungenaue Fehlermeldung und eine schlechte Dokumentation bzw. wenig Foreneinträge zu SwiftUI führten zur frustrierenden Fehlersuche. Nach unserem Umstieg auf Pair-Programming per Zoom ließen sich auch hier Lösungen finden.

Insgesamt bin ich mit dem Ergebnis des Projekts mehr als zu frieden und freue mich sehr auf weitere Arbeiten mit diesem motivierten Team.
