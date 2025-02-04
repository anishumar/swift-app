import SwiftUI

struct ContentView: View {
    let eggTimes = [
        "Soft Boiled": 300,
        "Medium Boiled": 480,
        "Hard Boiled": 600,
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(NSLocalizedString("🥚 What kind of egg are you having today?", comment: "Egg selection prompt"))
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.top, 60)
                        .accessibilityLabel(NSLocalizedString("Egg Selection", comment: "Prompt for selecting egg type"))
                    
                    ForEach(eggTimes.keys.sorted(), id: \.self) { eggType in
                        NavigationLink(destination: TimerPage(eggType: eggType, eggTime: eggTimes[eggType] ?? 0)) {
                            VStack {
                                Image(getEggImage(for: eggType))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                    .accessibilityHidden(true)
                                
                                Text(NSLocalizedString(eggType, comment: "Egg type label"))
                                    .font(.headline)
                                    .padding(.top, 0)
                                    .foregroundColor(.white)
                                    .accessibilityLabel(NSLocalizedString(eggType, comment: "Egg type"))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Egg Timer", comment: "Navigation title"))
        }
    }
    
    // Helper method to return the image name for a given egg type.
    func getEggImage(for eggType: String) -> String {
        switch eggType {
        case "Soft Boiled": return "soft-boiled"
        case "Medium Boiled": return "medium-boiled"
        case "Hard Boiled": return "hard-boiled"
        default: return "soft-boiled"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
