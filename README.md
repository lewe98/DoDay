# CS2365 Swift-Programmierung unter iOS
## DoDay

> Lorem Ipsum, kurzer Text über die App



## Gruppenmitglieder
* Julian Hermanspahn
* Lewe Lorenzen
* Thomas Raab



## Inhalt
* [Featureliste](#featureliste)
* [Softwareentwicklungsprozess](#softwareentwicklungsprozess)
* [Technologie-Stack](#technologie-stack)
* [Installationsanleitung](#installationsanleitung)
* [Ordnerstruktur](#ordnerstruktur)
* [Fazit](#fazit)



## Featureliste
> Lorem Ipsum



## Softwareentwicklungsprozess
> Lorem Ipsum



## Technologie-Stack
Technologie | Verwendungszweck
---------------------|----------
[Xcode 11.5](https://developer.apple.com/xcode/) | Entwicklungsumgebung
[Swift 4](https://www.apple.com/de/swift/) | Programmiersprache
[SwiftUICharts 1.5.0](https://github.com/AppPear/ChartView) | Frontend Development
[Firebase](https://firebase.google.com/docs/firestore) | Datenbank mit Cloud Firestore
[Local Notifications](https://developer.apple.com/documentation/usernotifications) | Benachrichtigungen
[User Defaults](https://developer.apple.com/documentation/foundation/userdefaults) | Persistierung der Einstellungen des Nutzers
[Core Data](https://developer.apple.com/documentation/coredata) | Datensicherung für offline Nutzung
[Swift UI Animations]() | 
[Working with sound]() | 



## Installationsanleitung
Das Repository mithilfe von Xcode klonen:

> Xcode öffnen > ``Clone an existing project`` > ``https://git.thm.de/jhmn46/itask`` > master branch auswählen

Cocoa Pods installieren:
> Sobald das Repository geklont wurde, alle aktiven Xcode Fenster schließen. 
> Im Anschluss mithilfe des Terminals in den Projektordner navigieren und ``pod install` ausführen.
> Dadurch werden die in der ``Podfile`` eingetragenen Abhängigkeiten installiert.
``
Das Projekt öffnen:
> Durch die Installation der Abhängigkeiten wird eine ``.xcworkspace`` Datei generiert.
> Diese wird in Zukunft verwendet, um das Projekt zu öffnen.
> ``New Scheme...`` > Target: iTask > Name: iTask



## Ordnerstruktur
```bash
├── client
│   ├── interfaces
│   │   ├── *.ts (Classes)
│   ├── src
│   │   ├── app
│   │   │   ├── auth (all pages related to user authentication)
│   │   │   │   ├── auth.module.ts (modules and routing)
│   │   │   ├── landing (landing page)
│   │   │   ├── services (all services)
│   │   │   │   ├── DatabaseController (handles all API requests)
│   │   │   │   ├── storage.ts (handles local storage/ device storage)
│   │   │   ├── shared (all shared components)
│   │   │   ├── shell (shell models)
│   │   │   │   ├── e.g. text-shell (shows loading animation while real data is fetched)
│   │   ├── assets (all assets)
│   │   ├── environments (environment variables)
│   │   ├── sass (globally used sass helper files)
│   ├── package.json (client modules and scripts)
├── server
│   ├── server.ts (Server Script)
│   ├── package.json (Scripts and Modules for Server)
│   ├── .eslintrc (Config for ESLint)
│   ├── .eslintignore (Excluded files for ESLint)
│   ├── test
│   │   ├── database-handler.ts (Initializes Memory Database for tests)
│   │   ├── api.test.ts (Tests for API requests)
│   │   ├── function.test.ts (Tests for Method calls)
│   └── models
│   │   ├── *.ts (Mongoose Schemas)
├── .gitignore
├── .prettierrc (Config for Prettier)
├── jest.config.js (Config for Jest)
├── .env (Environment Variables)
├── .gitlab-ci.yml (Defines Deploy-Pipelines)
├── .package.json (Scripts for Deploy)
├── README.md
```



## Fazit
#### Julian Hermanspahn
> Lorem Ipsum

#### Lewe Lorenzen
> Lorem Ipsum


#### Thomas Raab
> Lorem Ipsum
