import Decore

extension Context {
    static func inline<T>(
        _ owner: T,
        fileName: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) ->  Context {
        return Context(
            fileName: fileName,
            line: line,
            column: column,
            function: function,
            container: .consumer(String(describing: owner))
        )
    }
}
