//
//  Downpour.swift
//  Downpour
//
//  Created by Stephen Radford on 18/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Foundation

final class Downpour: CustomStringConvertible {
    private enum Pattern: String, CaseIterable {
        case pretty = #"S(\d{4}|\d{1,2})[\-\.\s_]?E\d{1,2}"#
        case tricky = #"[^\d](\d{4}|\d{1,2})[X\-\.\s_]\d{1,2}([^\d]|$)"#
        case combined = #"(?:S)?(\d{4}|\d{1,2})[EX\-\.\s_]\d{1,2}([^\d]|$)"#
        case altSeason = #"Season (\d{4}|\d{1,2}) Episode \d{1,2}"#
        case altSeasonSingle = #"Season (\d{4}|\d{1,2})"#
        case altEpisodeSingle = #"Episode \d{1,2}"#
        case altSeason2 = #"[\s_\.\-\[]\d{3}[\s_\.\-\]]"#
        case year = #"[\(?:\.\s_\[](?:19|(?:[2-9])(?:[0-9]))\d{2}[\]\s_\.\)]"#
    }

    public enum MediaType {
        case tv
        case movie
    }

    private static let regexOptions: String.CompareOptions = [.regularExpression, .caseInsensitive]
    private static let splitCharset = CharacterSet(charactersIn: "eExX-._ ")

    private let rawString: String

    public init(_ name: String) {
        rawString = name
    }

    /// A description of the media's known metadata
    public lazy var description: String = {
        let titleDesc = "Title: \(self.title)\n"
        var episodeDesc = ""
        var seasonDesc = ""
        var yearDesc = ""

        if let episode = self.episode { episodeDesc = "Episode: \(episode)\n" }
        if let season = self.season { seasonDesc = "Season: \(season)\n" }
        if let year = self.year { yearDesc = "Year: \(year)" }

        switch self.type {
        case .tv:
            return "\(titleDesc)\(episodeDesc)\(seasonDesc)\(yearDesc)"
        case .movie:
            return "\(titleDesc)\(yearDesc)"
        }
    }()

    /// The title of the media
    public lazy var title: String = {
        let tempTitle: String?

        switch type {
        case .movie:
            if let year = self.year {
                let endIndex = rawString.index(before: rawString.range(of: String(year))!.lowerBound)
                tempTitle = String(rawString[...endIndex])
            } else { tempTitle = nil }
        case .tv:
            if let sEp = seasonEpisode, let sEpRange = rawString.range(of: sEp), sEpRange.lowerBound != rawString.startIndex {
                let endIndex = rawString.index(before: sEpRange.lowerBound)
                var string = rawString[...endIndex]

                if let year = self.year {
                    let endIndex = string.index(before: string.range(of: String(year))!.lowerBound)
                    string = string[...endIndex]
                }
                tempTitle = String(string)
            } else { tempTitle = nil }
        }

        if let title = tempTitle {
            var clean = title.cleanedString

            if let uncleanMatch = title.range(of: #"\d+\.\d+"#, options: .regularExpression),
                let tooCleanMatch = clean.range(of: #"\d+ \d+"#, options: .regularExpression),
                uncleanMatch == tooCleanMatch {
                clean = clean.replacingCharacters(in: tooCleanMatch, with: title[uncleanMatch])
            }
            return clean
        }

        return rawString.cleanedString
    }()

    /// Used internally for determining other metadata
    private lazy var seasonEpisode: String? = {
        var match: Range<String.Index>?
        var patternMatched: Pattern?

        for (index, pattern) in Pattern.allCases.filter({ $0 != .year }).enumerated() {
            if let _match = rawString.range(of: pattern, options: Downpour.regexOptions) {
                match = _match
                patternMatched = Pattern.allCases[index]
                break
            }
        }

        guard var goodMatch = match, let goodPatternMatched = patternMatched else { return nil }

        let matchString: String?
        switch goodPatternMatched {
        case .tricky:
            goodMatch = rawString.index(after: goodMatch.lowerBound) ..< goodMatch.upperBound
            matchString = String(rawString[goodMatch])
        case .combined:
            goodMatch = goodMatch.lowerBound ..< goodMatch.upperBound
            matchString = String(rawString[goodMatch])
        case .altSeason2:
            let str = rawString[goodMatch].cleanedString
            guard ["264", "720"].contains(str[1 ... 3]) else { return str }
            fallthrough
        default: matchString = String(rawString[goodMatch])
        }

        return matchString
    }()

    /**
     * The season number
     *
     * Not avaliable if `self.type` is `Downpour.MediaType.movie`
     */
    public lazy var season: UInt? = {
        guard let both = seasonEpisode?.cleanedString else { return nil }
        let seasonLabel = "Season "

        guard both.range(of: seasonLabel, options: Downpour.regexOptions) == nil else {
            guard let match = rawString.range(of: Pattern.altSeasonSingle, options: Downpour.regexOptions) else { return nil }
            let string = String(rawString[match])
            let startIndex = string.startIndex
            let endIndex = string.index(startIndex, offsetBy: seasonLabel.count)

            return UInt(string.replacingCharacters(in: startIndex ..< endIndex, with: "").cleanedString)
        }

        guard both.count != 3 else {
            return UInt(both[both.startIndex ... both.startIndex].cleanedString)
        }

        let pieces = both.components(separatedBy: Downpour.splitCharset)

        // If we didn't cause a split above, then the following code can not be
        // reliably run
        guard pieces.count > 1 else { return nil }
        // This will never fail
        guard let first = pieces.first else { fatalError("Splitting a string resulted in an empty array") }

        // The size of the first part needs to be between 1 and 2
        if first.count <= 2, first.count >= 1 {
            return UInt(first.cleanedString)
        }

        let startIndex = first.index(after: first.startIndex)
        return UInt(first[startIndex ..< first.endIndex].cleanedString)
    }()

    /**
     * The episode number
     *
     * Not avaliable if `self.type` is `Downpour.MediaType.movie`
     */
    public lazy var episode: UInt? = {
        let episodeLabel = "Episode "
        guard let both = seasonEpisode?.cleanedString else { return nil }

        guard both.range(of: episodeLabel, options: Downpour.regexOptions) == nil else {
            guard let match = rawString.range(of: Pattern.altEpisodeSingle, options: Downpour.regexOptions) else { return nil }
            let string = String(rawString[match])
            let startIndex = string.startIndex
            let endIndex = string.index(startIndex, offsetBy: episodeLabel.count)

            return UInt(string.replacingCharacters(in: startIndex ..< endIndex, with: "").cleanedString)
        }

        guard both.count != 3 else {
            let startIndex = both.index(after: both.startIndex)
            let endIndex = both.index(after: startIndex)
            return UInt(both[startIndex ... endIndex].cleanedString)
        }

        let pieces = both.components(separatedBy: Downpour.splitCharset)
        var i = 1
        while pieces[i].isEmpty, i < pieces.count {
            i += 1
        }

        return UInt(pieces[i].cleanedString)
    }()

    /// The type of the media
    public lazy var type: Downpour.MediaType = {
        // Sometimes it mestakes the x/h 264 as season 2, episode 64. I don't
        // know of any shows that have 64 episode in a single season, so
        // checking that the episode < 64 should be safe and will resolve these
        // false positives
        if season != nil, (episode ?? 64) < 64 {
            return .tv
        }

        return .movie
    }()

    /// The year number
    public lazy var year: UInt? = {
        guard let match = rawString.range(of: Pattern.year, options: Downpour.regexOptions) else { return nil }
        return UInt(rawString[match].cleanedString)
    }()

    private func format(number: UInt?) -> String? {
        if let num = number {
            return String(format: "%02d", num)
        }

        return nil
    }

    /// The season, with at most one leading zero
    public lazy var formattedSeason: String? = {
        format(number: season)
    }()

    /// The episode, with at most one leading zero
    public lazy var formattedEpisode: String? = {
        format(number: episode)
    }()

    /// Both the season and the episode together, in the format "S##E##"
    public lazy var formattedSeasonEpisode: String = {
        var s = ""
        var e = ""

        if let fmtSn = formattedSeason { s = "S\(fmtSn)" }
        if let fmtEp = formattedEpisode { e = "E\(fmtEp)" }

        return "\(s)\(e)"
    }()

    /**
     * The basic name file name in the Plex Media Server format of "Name (Year) - S##E##"
     *
     * More information on the [Plex Media Server file naming format](https://support.plex.tv/articles/200220687-naming-series-season-based-tv-shows/)
     */
    public lazy var basicPlexName: String = {
        var yearDesc = ""

        if let year = self.year { yearDesc = " (\(year))" }

        switch type {
        case .tv:
            return "\(title)\(yearDesc) - \(formattedSeasonEpisode)"
        case .movie:
            return "\(title)\(yearDesc)"
        }
    }()
}
