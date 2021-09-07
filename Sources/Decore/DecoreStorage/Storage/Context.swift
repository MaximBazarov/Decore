public
struct Context: CustomDebugStringConvertible {

    public
    init(
        fileName: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        container: Storage.Key
    ) {
        self.fileName = fileName
        self.line = line
        self.column = column
        self.function = function
        self.container = container
    }


    public let fileName: String

    public let line: Int
    public let column: Int
    public let function: String

    public let container: Storage.Key

    public var debugDescription: String {
        let containerReads = "\(container) reads <- "
        guard let file = fileName.split(separator: "/").last else {
            return containerReads
        }

        return "\(container) (\(file))"
    }
}
