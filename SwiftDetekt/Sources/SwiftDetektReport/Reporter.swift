import SwiftDetektAPI

public protocol Reporter {
    func generate(findings: [Finding]) -> String
}

public struct ConsoleReporter: Reporter {
    public init() {}
    public func generate(findings: [Finding]) -> String {
        if findings.isEmpty {
            return "No findings."
        }
        return findings.map { finding in
            // Basic coloring could be added here with ANSI codes
            "\(finding.file):\(finding.line):\(finding.column): \(finding.severity.rawValue): \(finding.message) [\(finding.ruleId)]"
        }.joined(separator: "\n")
    }
}
