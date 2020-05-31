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
    @Published var erinnerungEigeneAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungEigeneAktiviert, forKey: "erinnerungEigeneAktiviert")
            erinnerungEigene()
        }
    }
    @Published var erinnerungFreundeAbgeschlossenAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungFreundeAbgeschlossenAktiviert, forKey: "erinnerungFreundeAbgeschlossenAktiviert")
            erinnerungFreundeAbgeschlossen()
        }
    }
    @Published var erinnerungFreundeProblemeAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungFreundeProblemeAktiviert, forKey: "erinnerungFreundeProblemeAktiviert")
            erinnerungFreundeProbleme()
        }
    }
    
    init() {
        self.erinnerungEigeneAktiviert = UserDefaults.standard.object(forKey: "erinnerungEigeneAktiviert") as? Bool ?? false
        self.erinnerungFreundeAbgeschlossenAktiviert = UserDefaults.standard.object(forKey: "erinnerungFreundeAbgeschlossenAktiviert") as? Bool ?? false
        self.erinnerungFreundeProblemeAktiviert = UserDefaults.standard.object(forKey: "erinnerungFreundeProblemeAktiviert") as? Bool ?? false
    }
}

func erinnerungEigene() -> Void {
    if Einstellungen().erinnerungEigeneAktiviert == true {
        let content = UNMutableNotificationContent()
        content.title = "Neuer Tag, neues Glück"
        content.subtitle = "Wähle deine neue Aufgabe!"
        content.sound = UNNotificationSound.default
        content.body = "Guten Morgen, es stehen wieder zwei Aufgaben für dich bereit, zwischen denen du dich entscheiden kannst. Viel Spaß dabei!"

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "ErinnerungEigene", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    } else {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["ErinnerungEigene"])
    }
    
    
}
func erinnerungFreundeAbgeschlossen() -> Void {
    print("erinnerungFreundeAbgeschlossen Funktion")
}
func erinnerungFreundeProbleme() -> Void {
    print("erinnerungFreundeProbleme Funktion")
}
