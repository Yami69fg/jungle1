import UIKit
import SpriteKit
import AVFoundation

class JungleSound {
    
    static let shared = JungleSound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Button", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibration = UserDefaults.standard.bool(forKey: "vibrationOn")
        if isVibration {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
    
    func playEndSound() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "End", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
    
    func playSnakeSound() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Snake", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
}



extension UIViewController {
    
    func addJungleSound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    func endSound() {
        JungleSound.shared.playEndSound()
    }
    
    func snakeSound() {
        JungleSound.shared.playSnakeSound()
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        JungleSound.shared.playSoundPress()
    }
}

