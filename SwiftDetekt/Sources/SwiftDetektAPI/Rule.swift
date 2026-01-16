@_exported import SwiftSyntax

public protocol Rule {
    var id: String { get }
    /// Visits the syntax tree and returns a list of findings.
    /// - Parameters:
    ///   - root: The root of the source file syntax tree.
    ///   - file: The path to the file being analyzed (used for reporting).
    func visit(_ root: SourceFileSyntax, file: String) -> [Finding]
}
