import SwiftSyntax
import SwiftDetektAPI

public struct CyclomaticComplexityRule: Rule {
    public let id = "CyclomaticComplexity"
    
    public init() {}

    public func visit(_ root: SourceFileSyntax, file: String) -> [Finding] {
        let visitor = FunctionFinderVisitor(file: file, ruleId: id, root: root)
        visitor.walk(root)
        return visitor.findings
    }
}

class FunctionFinderVisitor: SyntaxVisitor {
    var findings: [Finding] = []
    let file: String
    let ruleId: String
    let root: SourceFileSyntax
    let converter: SourceLocationConverter
    
    init(file: String, ruleId: String, root: SourceFileSyntax) {
        self.file = file
        self.ruleId = ruleId
        self.root = root
        self.converter = SourceLocationConverter(fileName: file, tree: root)
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let calculator = ComplexityCalculator()
        calculator.walk(node)
        
        // Threshold should come from config, hardcoded to 10 for now
        if calculator.complexity > 10 {
            let loc = node.startLocation(converter: converter)
            
            findings.append(Finding(
                ruleId: ruleId,
                message: "Function '\(node.name.text)' has high cyclomatic complexity (\(calculator.complexity)). Max allowed is 10.",
                file: file,
                line: loc.line,
                column: loc.column
            ))
        }
        return .visitChildren 
    }
}

class ComplexityCalculator: SyntaxVisitor {
    var complexity = 1
    
    override init(viewMode: SyntaxTreeViewMode = .sourceAccurate) {
        super.init(viewMode: viewMode)
    }
    
    override func visit(_ node: IfExprSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: ForStmtSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: RepeatStmtSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: SwitchCaseSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
    
    override func visit(_ node: CatchClauseSyntax) -> SyntaxVisitorContinueKind {
        complexity += 1
        return .visitChildren
    }
}
