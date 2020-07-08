//
//  Einstellungen.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 31.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import UserNotifications
import Foundation
import Combine

class Einstellungen: ObservableObject {
    
    /// taegliche Erinnerung
    @Published var erinnerungEigeneAktiviert: Bool {
        didSet {
            UserDefaults.standard.set(erinnerungEigeneAktiviert, forKey: "erinnerungEigeneAktiviert")
            erinnerungEigene()
        }
    }
    
    /// Timepicker fuer taegliche Erinnerung
    var erinnerungZeit = DateComponents()
    
    @Published var erinnerungZeitDate = UserDefaults.standard.object(forKey: "erinnerungZeitDate") as? Date ?? Date() {
        didSet {
            /// Wenn Datum geaendert wurde (Date-Format), ziehe DateComponents raus, speichere sie ab und call die Funktion zum Erinnerung setzen.
            var dateComponentsPulled = DateComponents()
            dateComponentsPulled.hour = Int((Calendar.current.dateComponents([.hour], from: erinnerungZeitDate)).hour!)
            dateComponentsPulled.minute = Int((Calendar.current.dateComponents([.minute], from: erinnerungZeitDate)).minute!)
            erinnerungZeit = dateComponentsPulled
            UserDefaults.standard.set(erinnerungZeit.hour, forKey: "erinnerungZeitHour")
            UserDefaults.standard.set(erinnerungZeit.minute, forKey: "erinnerungZeitMinute")
            UserDefaults.standard.set(erinnerungZeitDate, forKey: "erinnerungZeitDate")
            erinnerungEigene()
        }
    }
    
    
    
    init() {
        /// Fuer die taegliche Erinnerung
        var dateComponentsInit = DateComponents()
        
        dateComponentsInit.hour = 8
        
        dateComponentsInit.minute = 00
        
        self.erinnerungEigeneAktiviert = UserDefaults.standard.object(forKey: "erinnerungEigeneAktiviert") as? Bool ?? false
        
        self.erinnerungZeit.hour = UserDefaults.standard.object(forKey: "erinnerungZeitHour") as? Int ?? dateComponentsInit.hour
        
        self.erinnerungZeit.minute = UserDefaults.standard.object(forKey: "erinnerungZeitMinute") as? Int ?? dateComponentsInit.minute
    }
    
    /// Diese Funktion prueft ob Erinnerungen aktiviert sind und scheduled oder loescht sie
    func erinnerungEigene() -> Void {
        if self.erinnerungEigeneAktiviert == true {
            let content = UNMutableNotificationContent()
            let hour = UserDefaults.standard.object(forKey: "erinnerungZeitHour") as? Int ?? 13
            if hour < 12 {
                content.title = "Guten Morgen!"
            } else if hour < 17 {
                content.title = "Neuer Tag, neues Glück!"
            } else {
                content.title = "Guten Abend!"
            }
            content.subtitle = "Wähle deine neue Aufgabe!"
            content.sound = UNNotificationSound.default
            content.body = "Es stehen wieder zwei Aufgaben für dich bereit, zwischen denen du dich entscheiden kannst. Viel Spaß dabei!"

            let trigger = UNCalendarNotificationTrigger(dateMatching: self.erinnerungZeit, repeats: true)
            let request = UNNotificationRequest(identifier: "ErinnerungEigene", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["ErinnerungEigene"])
        }
    }
}



