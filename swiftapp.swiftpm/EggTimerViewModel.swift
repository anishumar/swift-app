import Foundation
import AVFoundation
import SwiftUI
import Combine
import UserNotifications

class EggTimerViewModel: ObservableObject {
    @Published var timeRemaining: Int
    @Published var timerActive = false
    @Published var eggImageOffset: CGFloat = 0
    @Published var achievementMessage: String? = nil
    
    private var cancellable: AnyCancellable?
    private var player: AVAudioPlayer?
    private let eggType: String
    private let initialTime: Int   // initial egg time
    private var eggsTimed: Int = 0
    
    init(eggType: String, eggTime: Int) {
        self.eggType = eggType
        self.initialTime = eggTime
        self.timeRemaining = eggTime
        loadTimerState()
        requestNotificationPermission()
    }
    
    func startTimer() {
        // If timer finished, reset it first
        if timeRemaining == 0 {
            timeRemaining = initialTime
        }
        
        stopTimer() // Invalidate any existing timer
        timerActive = true
        playSound(named: "start_beep")
        scheduleNotification()
        
        cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stopTimer()
                    self.playSound(named: "done_beep")
                    self.cancelNotification()
                    self.incrementEggsTimed()
                }
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
        timerActive = false
        eggImageOffset = 0
        saveTimerState()
        cancelNotification()
    }
    
    func resumeTimer() {
        // If timer is finished, start fresh.
        startTimer()
    }
    
    func resetTimer() {
        stopTimer()
        timeRemaining = initialTime
        saveTimerState()
        cancelNotification()
    }
    
    func playSound(named soundName: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Achievements and Gamification
    func incrementEggsTimed() {
        eggsTimed = UserDefaults.standard.integer(forKey: "\(eggType)_eggsTimed")
        eggsTimed += 1
        UserDefaults.standard.set(eggsTimed, forKey: "\(eggType)_eggsTimed")
        checkAchievements()
    }
    
    func checkAchievements() {
        if eggsTimed >= 5 {
            achievementMessage = NSLocalizedString("Achievement Unlocked: Egg Master!", comment: "Achievement message")
        } else {
            achievementMessage = nil
        }
    }
    
    // MARK: - Local Notifications
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Egg Timer", comment: "Notification title")
        content.body = NSLocalizedString("Your egg is ready!", comment: "Notification body")
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeRemaining), repeats: false)
        let request = UNNotificationRequest(identifier: "\(eggType)_notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(eggType)_notification"])
    }
    
    // MARK: - Persistence
    func saveTimerState() {
        UserDefaults.standard.set(timeRemaining, forKey: "\(eggType)_timeRemaining")
        UserDefaults.standard.set(timerActive, forKey: "\(eggType)_timerActive")
    }
    
    func loadTimerState() {
        if let savedTime = UserDefaults.standard.value(forKey: "\(eggType)_timeRemaining") as? Int {
            timeRemaining = savedTime
        }
        timerActive = UserDefaults.standard.bool(forKey: "\(eggType)_timerActive")
        eggsTimed = UserDefaults.standard.integer(forKey: "\(eggType)_eggsTimed")
    }
}
