import SwiftSyntax

public enum FindingSeverity: String, Codable {
    case error
    case warning
    case info
}

public struct Finding: Codable, CustomStringConvertible {
    public let ruleId: String
    public let message: String
    public let file: String
    public let line: Int
    public let column: Int
    public let severity: FindingSeverity
    
    public init(ruleId: String, message: String, file: String, line: Int, column: Int, severity: FindingSeverity = .warning) {
        self.ruleId = ruleId
        self.message = message
        self.file = file
        self.line = line
        self.column = column
        self.severity = severity
    }
    
    public var description: String {
        return "[\(ruleId)] \(file):\(line):\(column) - \(message)"
    }
}
