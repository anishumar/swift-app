import SwiftUI

struct TimerPage: View {
    var eggType: String
    var eggTime: Int
    @StateObject private var viewModel: EggTimerViewModel
    @State private var animateBounce = false
    @AppStorage("primaryColor") var primaryColorHex: String = "#007AFF" // for Start Timer color; Stop/Resume will be fixed below
    
    init(eggType: String, eggTime: Int) {
        self.eggType = eggType
        self.eggTime = eggTime
        _viewModel = StateObject(wrappedValue: EggTimerViewModel(eggType: eggType, eggTime: eggTime))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(String(format: NSLocalizedString("%@ Egg is Boiling!", comment: "Egg boiling message"), eggType))
                .font(.title2)
                .bold()
            
            Text(viewModel.timeRemaining > 0 ?
                    String(format: NSLocalizedString("Time Remaining: %@", comment: "Timer countdown"), formatTime(viewModel.timeRemaining)) :
                    NSLocalizedString("Your Egg is Ready!", comment: "Timer finished message"))
                .font(.headline)
                .accessibilityLabel(viewModel.timeRemaining > 0 ?
                    String(format: NSLocalizedString("Time Remaining: %@", comment: "Timer countdown"), formatTime(viewModel.timeRemaining)) :
                    NSLocalizedString("Egg is Ready", comment: "Timer finished message"))
            
            Image(getEggImage(for: eggType))
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .offset(y: animateBounce ? -10 : 10)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        animateBounce.toggle()
                    }
                }
                .accessibilityLabel(NSLocalizedString("Egg Image", comment: "Egg image for timer"))
            
            // Horizontal progress bar below the egg image
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                .frame(width: 300)
                .padding(.horizontal)
            
            // Timer control buttons
            HStack(spacing: 10) {
                if viewModel.timerActive {
                    Button(action: {
                        viewModel.stopTimer()
                    }) {
                        Text(NSLocalizedString("Stop Timer", comment: "Stop timer button"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red) // Stop timer button: red
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .accessibilityLabel(NSLocalizedString("Stop Timer", comment: "Stop timer"))
                } else if viewModel.timeRemaining > 0 {
                    Button(action: {
                        viewModel.resumeTimer()
                    }) {
                        Text(NSLocalizedString("Resume Timer", comment: "Resume timer button"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green) // Resume timer button: green
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .accessibilityLabel(NSLocalizedString("Resume Timer", comment: "Resume timer"))
                } else {
                    Button(action: {
                        viewModel.startTimer()
                    }) {
                        Text(NSLocalizedString("Start Timer", comment: "Start timer button"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: primaryColorHex))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .accessibilityLabel(NSLocalizedString("Start Timer", comment: "Start timer"))
                }
            }
            .padding(.horizontal)
            
            // Reset Button – available at all times
            Button(action: {
                viewModel.resetTimer()
            }) {
                Text(NSLocalizedString("Reset Timer", comment: "Reset timer button"))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .accessibilityLabel(NSLocalizedString("Reset Timer", comment: "Reset timer"))
            
            // Achievement message display (gamification)
            if let achievement = viewModel.achievementMessage {
                Text(achievement)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding()
                    .accessibilityLabel(achievement)
            }
        }
        .padding()
        .onAppear {
            if viewModel.timerActive && viewModel.timeRemaining > 0 {
                viewModel.resumeTimer()
            } else {
                viewModel.stopTimer()
            }
        }
        .onDisappear {
            viewModel.saveTimerState()
        }
    }
    
    // Calculates progress as a value between 0 and 1.
    var progress: Double {
        return Double(eggTime - viewModel.timeRemaining) / Double(eggTime)
    }
    
    // Formats seconds into MM:SS format.
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    // Returns the asset name for the given egg type.
    func getEggImage(for eggType: String) -> String {
        switch eggType {
        case "Soft Boiled": return "soft-boiled"
        case "Medium Boiled": return "medium-boiled"
        case "Hard Boiled": return "hard-boiled"
        default: return "soft-boiled"
        }
    }
}

struct TimerPage_Previews: PreviewProvider {
    static var previews: some View {
        TimerPage(eggType: "Soft Boiled", eggTime: 300)
    }
}
