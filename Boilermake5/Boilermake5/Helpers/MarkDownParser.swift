//
//  MarkDownParser.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/29/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import Foundation
import FontAwesomeKit

fileprivate let shiftedLevelMap: [Int : ShiftedLevel] = [0 : ShiftedLevel.zero, 1 : ShiftedLevel.first, 2 : ShiftedLevel.second, 3 : ShiftedLevel.third, 4 : ShiftedLevel.fourth, 5 : ShiftedLevel.fifth]
fileprivate let indentMap: [ShiftedLevel : Int] = [ShiftedLevel.zero : 0, ShiftedLevel.first : 1, ShiftedLevel.second : 2, ShiftedLevel.third : 3, ShiftedLevel.fourth : 4, ShiftedLevel.fifth : 5]

enum MarkDownParserError: Error {
    case URLParseError
}

enum MarkDownElement {
    case paragraph
    case image
    case orderedList(ShiftedLevel)
    case list(ShiftedLevel)
}

struct MarkDownParser {
    static let shared = MarkDownParser()

    func parse(url: URL, success: @escaping ([MarkDownHeader]) -> (), failure: @escaping (Error) -> ()) {
        DispatchQueue.global(qos: .background).async {
            do {
                let markdown = try Data(contentsOf: url)
                let attributedString = try NSAttributedString(data: markdown, options: [:], documentAttributes: nil)
                let markdownString = attributedString.string
                success(self.parse(markdown: markdownString))
            } catch {
                failure(MarkDownParserError.URLParseError)
            }
        }
    }

    func parse(markdown: String) -> [MarkDownHeader] {
        let components = markdown.components(separatedBy: CharacterSet.newlines)
        var initialParagraph: MarkDownHeader?
        var headers: [MarkDownHeader] = []
        var i = 0
        var idx = -1
        var isHeader = true
        var prevWasHeader = false
        var shiftedLevel: ShiftedLevel = ShiftedLevel.zero
        for component in components {
            if let regex = try? NSRegularExpression(pattern: "    |\t", options: []), let preRange = component.range(of: "\\s+", options:.regularExpression) {
                shiftedLevel = shiftedLevelMap[min(5, regex.numberOfMatches(in: component, options: [], range: NSRange(location: 0, length: component[preRange].count)))] ?? ShiftedLevel.zero
            }
            let words = component.components(separatedBy: CharacterSet.whitespaces)
            if words[0] == "#" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h1))
                prevWasHeader = true
            } else if ((words[0].count > 0) && (words[0] == words[0].filter { $0 == "=" }) && (words.count == 1) && (i > 0) && !prevWasHeader) {
                var headerText = components[i - 1]
                if idx >= 0 {
                    _ = headers[idx].contents.popLast()
                } else if let initialParagraph = initialParagraph?.contents.popLast() {
                    headerText = initialParagraph.contentText
                }
                headers.append(MarkDownHeader(header: headerText, contents: [], size: .h1))
                prevWasHeader = true
            } else if words[0] == "##" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h2))
                prevWasHeader = true
            } else if ((words[0].count > 0) && (words[0] == words[0].filter { $0 == "-"}) && (words.count == 1) && (i > 0) && !prevWasHeader) {
                var headerText = components[i - 1]
                if idx >= 0 {
                    _ = headers[idx].contents.popLast()
                } else if let initialParagraph = initialParagraph?.contents.popLast() {
                    headerText = initialParagraph.contentText
                }
                headers.append(MarkDownHeader(header: headerText, contents: [], size: .h2))
                prevWasHeader = true
            } else if words[0] == "###" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h3))
                prevWasHeader = true
            } else if words[0] == "####" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h4))
                prevWasHeader = true
            } else if words[0] == "#####" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h5))
                prevWasHeader = true
            } else if words[0] == "######" {
                headers.append(MarkDownHeader(header: words[1...].joined(separator: " "), contents: [], size: .h6))
                prevWasHeader = true
            } else if idx >= 0 {
                let content = Content(contentText: words.joined(separator: " ").trimmingCharacters(in: CharacterSet.whitespaces), shiftLevel: shiftedLevel)
                headers[idx].contents.append(content)
                isHeader = false
                prevWasHeader = false
            } else {
                isHeader = false
                prevWasHeader = false
                if initialParagraph != nil {
                    let content = Content(contentText: words.joined(separator: " ").trimmingCharacters(in: CharacterSet.whitespaces), shiftLevel: shiftedLevel)
                    initialParagraph?.contents.append(content)
                } else {
                    let content = Content(contentText: words.joined(separator: " ").trimmingCharacters(in: CharacterSet.whitespaces), shiftLevel: shiftedLevel)
                    initialParagraph = MarkDownHeader(header: nil, contents: [content], size: .p)
                }
            }

            if isHeader {
                idx += 1
            }

            isHeader = true
            i += 1
        }
        if let initialParagraph = initialParagraph {
            headers.insert(initialParagraph, at: 0)
        }
        return headers
    }

    func parseElement(for content: Content) -> (MarkDownElement, NSAttributedString, NSAttributedString?, String?) {
        var words = content.contentText.components(separatedBy: CharacterSet.whitespaces)
        var element: MarkDownElement = MarkDownElement.paragraph
        var bullet: NSAttributedString?
        var url: String?
        if words.count > 0 {
            if let match = words[0].range(of: "[0-9]+[.]", options: .regularExpression), match == words[0].startIndex..<words[0].endIndex {
                words[0] = words[0].trimmingCharacters(in: CharacterSet(charactersIn: "0"))
                element = MarkDownElement.orderedList(content.shiftLevel)
                bullet = NSAttributedString(string: words[0])
                words.remove(at: 0)
            } else if words[0] == "-" || words[0] == "*" || words[0] == "+" {
                element = MarkDownElement.list(content.shiftLevel)
                words.remove(at: 0)
                let level = content.shiftLevel
                if level == ShiftedLevel.zero || level == ShiftedLevel.second || level == ShiftedLevel.fourth {
                    bullet = FAKFontAwesome.circleIcon(withSize: 10.0).attributedString()
                } else {
                    bullet = FAKFontAwesome.circleOIcon(withSize: 10.0).attributedString()
                }
            }
        }
        let regex = try? NSRegularExpression(pattern: "!\\[([^\\[]+)\\]\\(([^\\)]+)\\)", options: [])
        if let matches = regex?.matches(in: content.contentText, options: [], range: NSRange(location: 0, length: content.contentText.count)), matches.count > 0 {
            element = MarkDownElement.image
            var text = content.contentText
            if let m = matches.first, let rnge = Range(m.range, in: text), let imageURL = text[rnge].range(of: "([^\\)]+)", options: .regularExpression) {
                url = String(text[imageURL])
            }
            if let m = matches.first, let rnge = Range(m.range, in: text) {
                text.removeSubrange(rnge)
                words = text.components(separatedBy: CharacterSet.whitespaces)
            }
        }
        return (element, NSAttributedString(string: words.joined(separator: " ")), bullet, url)
    }

}
