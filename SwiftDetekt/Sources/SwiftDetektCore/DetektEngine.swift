import SwiftDetektAPI
import SwiftDetektRules
import SwiftSyntax
import SwiftParser
import Foundation

public class DetektEngine {
    public init() {}
    
    public func run(files: [String]) throws -> [Finding] {
        var findings: [Finding] = []
        // In the future, load rules dynamically or via config
        let rules: [Rule] = [
            CyclomaticComplexityRule()
        ]
        
        for filePath in files {
            guard FileManager.default.fileExists(atPath: filePath) else {
                print("Skipping missing file: \(filePath)")
                continue
            }
            
            do {
                let url = URL(fileURLWithPath: filePath)
                let source = try String(contentsOf: url)
                let sourceFile = Parser.parse(source: source)
                
                for rule in rules {
                    findings.append(contentsOf: rule.visit(sourceFile, file: filePath))
                }
            } catch {
                print("Failed to process file \(filePath): \(error)")
            }
        }
        return findings
    }
}
