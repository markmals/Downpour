//
//  DownpourTests.swift
//  Downpour
//
//  Created by Kyle Fuller on 25/12/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import XCTest
@testable import Downpour

class DownpourVideoTests: XCTestCase {
    func testMovie1() {
        let metadata = Downpour("Movie.Name.2013.1080p.BluRay.H264.AAC.mp4")
        XCTAssertEqual(metadata.title, "Movie Name")
        XCTAssertEqual(metadata.year ?? 0, 2013)
        XCTAssertNil(metadata.season)
        XCTAssertNil(metadata.episode)
        XCTAssertEqual(metadata.type, .movie)
        XCTAssertEqual(metadata.basicPlexName, "Movie Name (2013)")
    }

    func testMovie2() {
        let metadata = Downpour("Movie_Name_2_2017_x264_RARBG.avi")
        XCTAssertEqual(metadata.title, "Movie_Name_2") // FIXME
        XCTAssertEqual(metadata.year ?? 0, 2017)
        XCTAssertNil(metadata.season)
        XCTAssertNil(metadata.episode)
        XCTAssertEqual(metadata.type, .movie)
        XCTAssertEqual(metadata.basicPlexName, "Movie_Name_2 (2017)") // FIXME
    }

    func testStandardShow1() {
        let metadata = Downpour("Mr.Show.Name.S01E02.Source.Quality.Etc-Group")
        XCTAssertEqual(metadata.title, "Mr Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Mr Show Name - S01E02")
    }

    func testStandardShow2() {
        let metadata = Downpour("Show.Name.S01E02")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testStandardShow3() {
        let metadata = Downpour("Show Name - S01E02 - My Ep Name")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testStandardShow4() {
        let metadata = Downpour("Show.2.0.Name.S01.E03.My.Ep.Name-Group")
        XCTAssertEqual(metadata.title, "Show 2.0 Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 3)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show 2.0 Name - S01E03")
    }

    func testStandardShow5() {
        let metadata = Downpour("Show Name - S06E01 - 2009-12-20 - Ep Name")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 6)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S06E01")
    }

    func testStandardShow6() {
        let metadata = Downpour("Show Name - S06E01 - -30-")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 6)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S06E01")
    }

    func testStandardShow7() {
        let metadata = Downpour("Show.Name.S06E01.Other.WEB-DL")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 6)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S06E01")
    }

    func testStandardShow8() {
        let metadata = Downpour("Show.Name.S06E01 Some-Stuff Here")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 6)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S06E01")
    }

    func testStandardShow9() {
        let metadata = Downpour("Show.Name-0.2010.S01E02.Source.Quality.Etc-Group")
        XCTAssertEqual(metadata.title, "Show Name-0") // FIXME
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertEqual(metadata.year ?? 0, 2010)
        XCTAssertEqual(metadata.basicPlexName, "Show Name-0 (2010) - S01E02") // FIXME
    }

    func testStandardShow10() {
        let metadata = Downpour("Show-Name-S06E01-720p")
        XCTAssertEqual(metadata.title, "Show-Name") // FIXME
        XCTAssertEqual(metadata.season, 6)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show-Name - S06E01") // FIXME
    }

    func testStandardShow11() {
        let metadata = Downpour("Show Name - s2005e01")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 2005)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S2005E01")
    }

    func testStandardShow12() {
        let metadata = Downpour("Show Name - s05e01")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 5)
        XCTAssertEqual(metadata.episode, 1)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S05E01")
    }

    func testFOVShow1() {
        let metadata = Downpour("Show_Name.1x02.Source_Quality_Etc-Group")
        XCTAssertEqual(metadata.title, "Show_Name") // FIXME
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show_Name - S01E02") // FIXME
    }

    func testFOVShow2() {
        let metadata = Downpour("Show Name 1x02")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testFOVShow3() {
        let metadata = Downpour("Show Name 1x02 x264 Test")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testFOVShow4() {
        let metadata = Downpour("Show Name - 1x02 - My Ep Name")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testFOVShow5() {
        let metadata = Downpour("Show Name 1x02 x264 Test")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }

    func testFOVShow6() {
        let metadata = Downpour("Show Name - 1x02 - My Ep Name")
        XCTAssertEqual(metadata.title, "Show Name")
        XCTAssertEqual(metadata.season, 1)
        XCTAssertEqual(metadata.episode, 2)
        XCTAssertEqual(metadata.type, .tv)
        XCTAssertNil(metadata.year)
        XCTAssertEqual(metadata.basicPlexName, "Show Name - S01E02")
    }
}

#if os(Linux)
extension DownpourVideoTests {
    static var allTests: [(String, (DownpourVideoTests) -> () throws -> Void)] {
        return [
            ("testMovie1", testMovie1),
            ("testMovie2", testMovie2),
            ("testStandardShow1", testStandardShow1),
            ("testStandardShow2", testStandardShow2),
            ("testStandardShow3", testStandardShow3),
            ("testStandardShow4", testStandardShow4),
            ("testStandardShow5", testStandardShow5),
            ("testStandardShow6", testStandardShow6),
            ("testStandardShow7", testStandardShow7),
            ("testStandardShow8", testStandardShow8),
            ("testStandardShow9", testStandardShow9),
            ("testStandardShow10", testStandardShow10),
            ("testStandardShow11", testStandardShow11),
            ("testStandardShow12", testStandardShow12),
            ("testFOVShow1", testFOVShow1),
            ("testFOVShow2", testFOVShow2),
            ("testFOVShow3", testFOVShow3),
            ("testFOVShow4", testFOVShow4),
            ("testFOVShow5", testFOVShow5),
            ("testFOVShow6", testFOVShow6)
        ]
    }
}
#endif
