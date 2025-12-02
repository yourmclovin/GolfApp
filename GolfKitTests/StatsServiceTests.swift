import XCTest
@testable import GolfKit

final class StatsServiceTests: XCTestCase {
    var sut: StatsService!
    
    override func setUp() {
        super.setUp()
        sut = StatsService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - calculateStats Tests
    
    func testCalculateStatsWithEmptyRounds() {
        let stats = sut.calculateStats(rounds: [])
        
        XCTAssertEqual(stats.rounds, 0)
        XCTAssertEqual(stats.totalScore, 0)
        XCTAssertEqual(stats.avgScore, 0)
        XCTAssertEqual(stats.girCount, 0)
        XCTAssertEqual(stats.totalPutts, 0)
        XCTAssertNil(stats.bestScore)
        XCTAssertNil(stats.worstScore)
    }
    
    func testCalculateStatsWithSingleRound() {
        let round = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: [4, 3, 5, 4, 4, 3, 4, 5, 4, 4, 4, 3, 5, 4, 4, 3, 5, 4],
            putts: [2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2]
        )
        
        let stats = sut.calculateStats(rounds: [round])
        
        XCTAssertEqual(stats.rounds, 1)
        XCTAssertEqual(stats.totalScore, 72)
        XCTAssertEqual(stats.avgScore, 72)
        XCTAssertEqual(stats.girCount, 18)
        XCTAssertEqual(stats.totalPutts, 32)
        XCTAssertEqual(stats.bestScore, 72)
        XCTAssertEqual(stats.worstScore, 72)
    }
    
    func testCalculateStatsWithMultipleRounds() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18),
            putts: Array(repeating: 2, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 5, count: 18),
            putts: Array(repeating: 2, count: 18)
        )
        
        let stats = sut.calculateStats(rounds: [round1, round2])
        
        XCTAssertEqual(stats.rounds, 2)
        XCTAssertEqual(stats.totalScore, 162) // 72 + 90
        XCTAssertEqual(stats.avgScore, 81)
        XCTAssertEqual(stats.girCount, 18)
        XCTAssertEqual(stats.totalPutts, 72)
        XCTAssertEqual(stats.bestScore, 72)
        XCTAssertEqual(stats.worstScore, 90)
    }
    
    // MARK: - getBestScore Tests
    
    func testGetBestScore() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 5, count: 18)
        )
        
        let bestScore = sut.getBestScore(rounds: [round1, round2])
        XCTAssertEqual(bestScore, 72)
    }
    
    func testGetBestScoreWithEmptyRounds() {
        let bestScore = sut.getBestScore(rounds: [])
        XCTAssertNil(bestScore)
    }
    
    // MARK: - getWorstScore Tests
    
    func testGetWorstScore() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 5, count: 18)
        )
        
        let worstScore = sut.getWorstScore(rounds: [round1, round2])
        XCTAssertEqual(worstScore, 90)
    }
    
    func testGetWorstScoreWithEmptyRounds() {
        let worstScore = sut.getWorstScore(rounds: [])
        XCTAssertNil(worstScore)
    }
    
    // MARK: - getAverageScore Tests
    
    func testGetAverageScore() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 5, count: 18)
        )
        
        let avgScore = sut.getAverageScore(rounds: [round1, round2])
        XCTAssertEqual(avgScore, 81)
    }
    
    func testGetAverageScoreWithEmptyRounds() {
        let avgScore = sut.getAverageScore(rounds: [])
        XCTAssertEqual(avgScore, 0)
    }
    
    // MARK: - getAveragePutts Tests
    
    func testGetAveragePutts() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18),
            putts: Array(repeating: 2, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18),
            putts: Array(repeating: 2, count: 18)
        )
        
        let avgPutts = sut.getAveragePutts(rounds: [round1, round2])
        XCTAssertEqual(avgPutts, 2)
    }
    
    // MARK: - getGIRPercentage Tests
    
    func testGetGIRPercentage() {
        let round = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: [4, 3, 5, 4, 4, 3, 4, 5, 4, 4, 4, 3, 5, 4, 4, 3, 5, 4]
        )
        
        let girPercentage = sut.getGIRPercentage(rounds: [round])
        XCTAssertEqual(girPercentage, 100) // All scores <= 4
    }
    
    func testGetGIRPercentageWithEmptyRounds() {
        let girPercentage = sut.getGIRPercentage(rounds: [])
        XCTAssertEqual(girPercentage, 0)
    }
    
    // MARK: - calculateStatsForCourse Tests
    
    func testCalculateStatsForCourse() {
        let round1 = Round(
            id: "round-1",
            courseId: "course-1",
            date: Date(),
            scores: Array(repeating: 4, count: 18)
        )
        
        let round2 = Round(
            id: "round-2",
            courseId: "course-2",
            date: Date(),
            scores: Array(repeating: 5, count: 18)
        )
        
        let stats = sut.calculateStatsForCourse(rounds: [round1, round2], courseId: "course-1")
        
        XCTAssertEqual(stats.rounds, 1)
        XCTAssertEqual(stats.totalScore, 72)
    }
}
