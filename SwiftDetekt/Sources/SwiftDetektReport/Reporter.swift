import SwiftDetektAPI
import Foundation

public protocol Reporter {
    func generate(findings: [Finding]) -> String
}

public struct ConsoleReporter: Reporter {
    public init() {}
    
    public func generate(findings: [Finding]) -> String {
        if findings.isEmpty {
            return "No findings."
        }
        
        var output = ""
        
        // Group findings by file
        let groupedFindings = Dictionary(grouping: findings, by: { $0.file })
        let sortedFiles = groupedFindings.keys.sorted()
        
        output += "Found \(findings.count) issues in \(sortedFiles.count) files.\n"
        
        for file in sortedFiles {
            guard let fileFindings = groupedFindings[file] else { continue }
            
            // File Header
            output += "\n\u{001B}[1m\(file)\u{001B}[0m\n"
            
            for finding in fileFindings.sorted(by: { $0.line < $1.line }) {
                let colorCode: String
                switch finding.severity {
                case .error:
                    colorCode = "\u{001B}[31m" // Red
                case .warning:
                    colorCode = "\u{001B}[33m" // Yellow
                case .info:
                    colorCode = "\u{001B}[34m" // Blue
                }
                let resetCode = "\u{001B}[0m"
                
                let severityLabel = "\(colorCode)\(finding.severity.rawValue.capitalized)\(resetCode)"
                
                output += "  Line \(finding.line): \(severityLabel): \(finding.message) [\(finding.ruleId)]\n"
            }
        }
        
        return output
    }
}
