import XCTest
@testable import GolfKit

final class CourseServiceTests: XCTestCase {
    var sut: CourseService!
    var mockModelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        // Create a mock ModelContext (in-memory)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: GolfCourse.self, configurations: config)
        mockModelContext = ModelContext(container)
        sut = CourseService(modelContext: mockModelContext)
    }
    
    override func tearDown() {
        sut = nil
        mockModelContext = nil
        super.tearDown()
    }
    
    // MARK: - searchCourses Tests
    
    func testSearchCoursesWithEmptyQuery() async throws {
        let courses = try await sut.searchCourses(query: "")
        XCTAssertGreater(courses.count, 0, "Should return all courses for empty query")
    }
    
    func testSearchCoursesByName() async throws {
        let courses = try await sut.searchCourses(query: "Pebble")
        let pebbleBeach = courses.first { $0.name.contains("Pebble") }
        XCTAssertNotNil(pebbleBeach)
    }
    
    func testSearchCoursesByLocation() async throws {
        let courses = try await sut.searchCourses(query: "California")
        XCTAssertGreater(courses.count, 0)
    }
    
    func testSearchCoursesNoResults() async throws {
        let courses = try await sut.searchCourses(query: "NonExistentCourse123")
        XCTAssertEqual(courses.count, 0)
    }
    
    // MARK: - getCourse Tests
    
    func testGetCourseById() async throws {
        let allCourses = try await sut.searchCourses(query: "")
        guard let firstCourse = allCourses.first else {
            XCTFail("No courses available")
            return
        }
        
        let course = try sut.getCourse(id: firstCourse.id)
        XCTAssertNotNil(course)
        XCTAssertEqual(course?.id, firstCourse.id)
    }
    
    func testGetCourseByIdNotFound() throws {
        let course = try sut.getCourse(id: "invalid-id")
        XCTAssertNil(course)
    }
    
    // MARK: - getAllCourses Tests
    
    func testGetAllCourses() throws {
        let courses = try sut.getAllCourses()
        XCTAssertGreater(courses.count, 0)
    }
    
    // MARK: - Course Data Validation
    
    func testCourseDataIntegrity() throws {
        let courses = try sut.getAllCourses()
        
        for course in courses {
            XCTAssertFalse(course.id.isEmpty, "Course ID should not be empty")
            XCTAssertFalse(course.name.isEmpty, "Course name should not be empty")
            XCTAssertFalse(course.location.isEmpty, "Course location should not be empty")
            XCTAssertGreater(course.lat, -90, "Latitude should be valid")
            XCTAssertLess(course.lat, 90, "Latitude should be valid")
            XCTAssertGreater(course.lon, -180, "Longitude should be valid")
            XCTAssertLess(course.lon, 180, "Longitude should be valid")
            XCTAssertEqual(course.holes.count, 18, "Course should have 18 holes")
        }
    }
    
    func testHoleDataIntegrity() throws {
        let courses = try sut.getAllCourses()
        guard let firstCourse = courses.first else {
            XCTFail("No courses available")
            return
        }
        
        for (index, hole) in firstCourse.holes.enumerated() {
            XCTAssertEqual(hole.number, index + 1, "Hole number should match index")
            XCTAssertGreater(hole.par, 0, "Par should be greater than 0")
            XCTAssertLess(hole.par, 10, "Par should be less than 10")
            XCTAssertFalse(hole.yardages.isEmpty, "Hole should have yardages")
        }
    }
}
