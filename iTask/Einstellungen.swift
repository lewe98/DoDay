//
//  Einstellungen.swift
//  iTask
//
//  Created by Thomas on 31.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import UserNotifications
import Foundation
import Combine

class Einstellungen: ObservableObject {
    // taegliche Erinnerung morgens
    @Published var erinnerungEigeneAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungEigeneAktiviert, forKey: "erinnerungEigeneAktiviert")
            erinnerungEigene()
        }
    }
    // Remote Notifications fuer Freundesaktivitaeten
    @Published var erinnerungFreundeAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungFreundeAktiviert, forKey: "erinnerungFreundeAktiviert")
            erinnerungFreunde()
        }
    }
    // Timepicker fuer taegliche Erinnerung morgens
    var erinnerungZeit = DateComponents()
    @Published var erinnerungZeitDate = Date() {
        didSet {
            // Wenn Datum geaendert wurde (Date-Format), ziehe DateComponents raus, speichere sie ab und call die Funktion zum Erinnerung setzen.
            var dateComponentsPulled = DateComponents()
            dateComponentsPulled.hour = Int((Calendar.current.dateComponents([.hour], from: erinnerungZeitDate)).hour!)
            dateComponentsPulled.minute = Int((Calendar.current.dateComponents([.minute], from: erinnerungZeitDate)).minute!)
            erinnerungZeit = dateComponentsPulled
            UserDefaults.standard.set(erinnerungZeit.hour, forKey: "erinnerungZeitHour")
            UserDefaults.standard.set(erinnerungZeit.minute, forKey: "erinnerungZeitMinute")
            erinnerungEigene()
        }
    }
    
    init() {
        // Fuer die taegliche Erinnerung
        var dateComponentsInit = DateComponents()
        dateComponentsInit.hour = 8
        dateComponentsInit.minute = 00
        self.erinnerungEigeneAktiviert = UserDefaults.standard.object(forKey: "erinnerungEigeneAktiviert") as? Bool ?? false
        self.erinnerungZeit.hour = UserDefaults.standard.object(forKey: "erinnerungZeitHour") as? Int ?? dateComponentsInit.hour
        self.erinnerungZeit.minute = UserDefaults.standard.object(forKey: "erinnerungZeitMinute") as? Int ?? dateComponentsInit.minute
        
        // Fuer die Freundes-Erinnerungen (Push-Notifications)
        self.erinnerungFreundeAktiviert = UserDefaults.standard.object(forKey: "erinnerungFreundeAktiviert") as? Bool ?? false
    }
}

func erinnerungEigene() -> Void {
    // prueft ob morgentliche Erinnerungen aktiviert sind und scheduled oder loescht sie
    if Einstellungen().erinnerungEigeneAktiviert == true {
        let content = UNMutableNotificationContent()
        content.title = "Neuer Tag, neues Glück"; content.subtitle = "Wähle deine neue Aufgabe!"; content.sound = UNNotificationSound.default
        content.body = "Guten Morgen, es stehen wieder zwei Aufgaben für dich bereit, zwischen denen du dich entscheiden kannst. Viel Spaß dabei!"

        let trigger = UNCalendarNotificationTrigger(dateMatching: Einstellungen().erinnerungZeit, repeats: true)
        let request = UNNotificationRequest(identifier: "ErinnerungEigene", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    } else {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["ErinnerungEigene"])
    }
}

func erinnerungFreunde() -> Void {
    // prueft ob remote Notifications gewuenscht sind und aktiviert oder deaktiviert diese. Dies muss serversided geschehen.
    if Einstellungen().erinnerungFreundeAktiviert == true {
        print("Erinnerungen fuer Freunde sollten jetzt aktiviert sein")
    } else {
        print("Erinnerungen fuer Freunde sollten jetzt deaktiviert sein")
    }
}

