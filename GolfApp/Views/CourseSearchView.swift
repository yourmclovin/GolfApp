import SwiftUI
import GolfKit

struct CourseSearchView: View {
    @State private var searchText = ""
    @State private var courses: [GolfCourse] = []
    @State private var isLoading = false
    @State private var selectedCourse: GolfCourse?
    @State private var showRoundView = false
    
    private let courseService = CourseService(modelContext: ModelContext(ModelContainer(for: GolfCourse.self)))
    
    var filteredCourses: [GolfCourse] {
        if searchText.isEmpty {
            return courses
        }
        return courses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                if isLoading {
                    ProgressView()
                } else if filteredCourses.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "map.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No courses found")
                            .font(.headline)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    List(filteredCourses) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.name)
                                    .font(.headline)
                                HStack {
                                    Text(course.location)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("Par \(course.par)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                loadCourses()
            }
        }
    }
    
    private func loadCourses() {
        isLoading = true
        Task {
            do {
                courses = try await courseService.searchCourses(query: "")
            } catch {
                print("Error loading courses: \(error)")
            }
            isLoading = false
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search courses...", text: $text)
                .textFieldStyle(.roundedBorder)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    CourseSearchView()
}
