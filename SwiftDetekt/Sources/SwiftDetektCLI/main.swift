import ArgumentParser
import SwiftDetektCore
import SwiftDetektReport
import Foundation

@main
struct SwiftDetektCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftdetekt",
        abstract: "Static code analysis for Swift",
        subcommands: [Analyze.self, Coverage.self],
        defaultSubcommand: Analyze.self
    )
}

struct Analyze: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Analyze Swift source files")
    
    @Option(name: .shortAndLong, help: "Input path to analyze (file or directory)")
    var input: String = "."
    
    mutating func run() throws {
        let fileManager = FileManager.default
        var files: [String] = []
        let inputPath = (input as NSString).expandingTildeInPath
        
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: inputPath, isDirectory: &isDir) {
            if isDir.boolValue {
                if let enumerator = fileManager.enumerator(atPath: inputPath) {
                    for case let file as String in enumerator {
                        if file.hasSuffix(".swift") {
                            files.append((inputPath as NSString).appendingPathComponent(file))
                        }
                    }
                }
            } else {
                files.append(inputPath)
            }
        } else {
            print("Error: Input path '\(input)' does not exist.")
            throw ExitCode.validationFailure
        }
        
        let engine = DetektEngine()
        let findings = try engine.run(files: files)
        
        let reporter = ConsoleReporter()
        print(reporter.generate(findings: findings))
        
        if !findings.isEmpty {
            throw ExitCode.failure // Exit with error code if findings exist (typical linter behavior)
        }
    }
}

struct Coverage: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Estimate test coverage")
    
    @Option(name: .long, help: "Path to .xcresult or .profdata")
    var input: String?

    func run() throws {
        print("Coverage estimation is a future feature. Please use llvm-cov directly for now.")
    }
}
