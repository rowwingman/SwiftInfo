import XCTest
@testable import SwiftInfoCore

final class SlackFormatterTests: XCTestCase {
    func testFormatter() {
        let swiftInfo = SwiftInfoProvider.mock()
        let summaries = [Summary(text: "A", style: .positive, numericValue: 0, stringValue: "a")]
        let output = Output(rawDictionary: [:], summaries: summaries, errors: [])
        let formatted = SlackFormatter().format(output: output, titlePrefix: nil, projectInfo: swiftInfo.projectInfo)
        let dictionary = NSDictionary(dictionary: formatted.json)
        let expected: [String: Any] =
            [
                "attachments": [["color": "#36a64f","text": "A"]],
                "text": "SwiftInfo results for Mock 1.0 (1) - Mock-Debug:"
        ]
        XCTAssertEqual(dictionary, NSDictionary(dictionary: expected))
    }

    func testFormatterWithTitlePrefix() {
        let swiftInfo = SwiftInfoProvider.mock()
        let prefix = "<!subteam^mention_id|ios-team>"
        let summaries = [Summary(text: "A", style: .positive, numericValue: 0, stringValue: "a")]
        let output = Output(rawDictionary: [:], summaries: summaries, errors: [])
        let formatted = SlackFormatter().format(output: output, titlePrefix: prefix, projectInfo: swiftInfo.projectInfo)
        let dictionary = NSDictionary(dictionary: formatted.json)
        let text = prefix + "Mock 1.0 (1) - Mock-Debug:"
        let expected: [String: Any] =
            [
                "attachments": [["color": "#36a64f","text": "A"]],
                "text": text
        ]
        XCTAssertEqual(dictionary, NSDictionary(dictionary: expected))
    }

    func testFormatterWithError() {
        let swiftInfo = SwiftInfoProvider.mock()
        let summaries = [Summary(text: "A", style: .positive, numericValue: 0, stringValue: "a")]
        let output = Output(rawDictionary: [:], summaries: summaries, errors: ["abc", "cde"])
        let formatted = SlackFormatter().format(output: output, titlePrefix: nil, projectInfo: swiftInfo.projectInfo)
        let dictionary = NSDictionary(dictionary: formatted.json)
        let expected: [String: Any] =
            [
             "attachments": [["color": "#36a64f","text": "A"]],
             "text": "SwiftInfo results for Mock 1.0 (1) - Mock-Debug:\nErrors:\nabc\ncde"
            ]
        XCTAssertEqual(dictionary, NSDictionary(dictionary: expected))
    }

    func testRawPrint() {
        let swiftInfo = SwiftInfoProvider.mock()
        let summaries = [Summary(text: "A", style: .positive, numericValue: 0, stringValue: "a")]
        let output = Output(rawDictionary: [:], summaries: summaries, errors: [])
        let formatted = SlackFormatter().format(output: output, titlePrefix: nil, projectInfo: swiftInfo.projectInfo)
        XCTAssertEqual(formatted.message, "SwiftInfo results for Mock 1.0 (1) - Mock-Debug:\nA")
    }
}
