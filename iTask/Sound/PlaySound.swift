//
//  PlaySound.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 05.07.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

/// Spielt einen Sound ab.
///
/// - Parameter sound: Name des Sounds.
/// - Parameter type: Typ des Sounds.
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Audio File nicht gefunden!")
        }
    }
}
