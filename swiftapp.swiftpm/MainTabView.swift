import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView() // The egg timer interface
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
            
            EggFactsView() // The egg facts and health benefits
                .tabItem {
                    Image(systemName: "book")
                    Text("Facts")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
