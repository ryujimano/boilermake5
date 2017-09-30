//
//  MarkDownParser.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/29/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import Foundation

enum MarkDownParserError: Error {
    case URLParseError
}

struct MarkDownParser {
    static let shared = MarkDownParser()

    func parse(url: URL) throws -> [MarkDownHeader] {
        do {
            let markdown = try Data(contentsOf: url)
            let attributedString = try NSAttributedString.init(data: markdown, options: [:], documentAttributes: nil)
            let markdownString = attributedString.string
            return parse(markdown: markdownString)
        } catch {
            throw MarkDownParserError.URLParseError
        }
    }

    func parse(markdown: String) -> [MarkDownHeader] {
        let components = markdown.components(separatedBy: CharacterSet.newlines)
        var headers: [MarkDownHeader] = []
        var i = 0
        var idx = -1
        var isHeader = true
        for component in components {
            let words = component.components(separatedBy: CharacterSet.whitespaces)
            if words[0] == "#" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h1))
            } else if ((words[0] == words[0].filter { $0 == "=" }) && (words.count == 1) && (i > 0)) {
                headers.append(MarkDownHeader(header: components[i - 1], contents: [], size: .h1))
            } else if words[0] == "##" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h2))
            } else if ((words[0] == words[0].filter { $0 == "-"}) && (words.count == 1) && (i > 0)) {
                headers.append(MarkDownHeader(header: components[i - 1], contents: [], size: .h2))
            } else if words[0] == "###" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h3))
            } else if words[0] == "####" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h4))
            } else if words[0] == "#####" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h5))
            } else if words[0] == "######" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h6))
            } else {
                headers[idx].contents.append(words.joined(separator: " "))
                isHeader = false
            }

            if isHeader {
                idx += 1
            }

            isHeader = true
            i += 1
        }
        return headers
    }

}
