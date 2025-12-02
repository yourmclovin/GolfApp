import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tab = .scoring
    @Query var rounds: [Round]
    
    enum Tab {
        case scoring
        case stats
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WatchRoundScoringView()
                .tag(Tab.scoring)
            
            WatchStatsView(rounds: rounds)
                .tag(Tab.stats)
        }
        .tabViewStyle(.carousel)
    }
}

#Preview {
    ContentView()
}
