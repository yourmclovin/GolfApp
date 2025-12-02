import SwiftUI
import SwiftData
import GolfKit

struct RoundScoringView: View {
    let course: GolfCourse
    @State private var vm: RoundViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    init(course: GolfCourse) {
        self.course = course
        _vm = State(initialValue: RoundViewModel(course: course, modelContext: ModelContext(ModelContainer(for: Round.self))))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(course.name)
                        .font(.headline)
                    Text("Hole \(vm.currentHole) of 18")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(vm.gpsDistance)m")
                        .font(.title3)
                        .bold()
                    Text("to green")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Current hole info
            if vm.currentHole <= course.holes.count {
                let hole = course.holes[vm.currentHole - 1]
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Par")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(hole.par)")
                            .font(.title2)
                            .bold()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Handicap")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(hole.handicap)")
                            .font(.title2)
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // Score buttons
            VStack(spacing: 8) {
                Text("Record Score")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    ForEach(2...5, id: \.self) { score in
                        Button(String(score)) {
                            vm.recordScore(score)
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(6...9, id: \.self) { score in
                        Button(String(score)) {
                            vm.recordScore(score)
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Finish button
            if vm.currentHole > 18 {
                Button(action: finishRound) {
                    Text("Finish Round")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Scoring")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.startRound()
        }
    }
    
    private func finishRound() {
        vm.finishRound()
        dismiss()
    }
}

@MainActor
final class RoundViewModel: ObservableObject {
    @Published var round: Round?
    @Published var currentHole: Int = 1
    @Published var gpsDistance: Int = 0
    
    let course: GolfCourse
    let modelContext: ModelContext
    private let locationService = LocationService()
    
    init(course: GolfCourse, modelContext: ModelContext) {
        self.course = course
        self.modelContext = modelContext
    }
    
    func startRound() {
        round = Round(
            id: UUID().uuidString,
            courseId: course.id,
            date: Date(),
            scores: Array(repeating: 0, count: 18)
        )
        locationService.requestLocationPermission()
        updateGPS()
    }
    
    func recordScore(_ score: Int) {
        guard var r = round else { return }
        r.scores[currentHole - 1] = score
        round = r
        currentHole += 1
        updateGPS()
    }
    
    func finishRound() {
        guard let r = round else { return }
        modelContext.insert(r)
        try? modelContext.save()
    }
    
    private func updateGPS() {
        Task {
            gpsDistance = locationService.getDistance(to: CLLocationCoordinate2D(latitude: course.lat, longitude: course.lon))
        }
    }
}

import CoreLocation

#Preview {
    let mockCourse = GolfCourse(
        id: "test-1",
        name: "Pebble Beach",
        location: "Pebble Beach, CA",
        lat: 36.5627,
        lon: -121.9496,
        par: 72,
        handicap: 2,
        holes: []
    )
    RoundScoringView(course: mockCourse)
}
