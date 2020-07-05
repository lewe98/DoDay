//
//  PlaySound.swift
//  iTask
//
//  Created by Lewe Lorenzen on 05.07.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
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
