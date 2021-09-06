import DecoreStorage

// MARK: - StateOf -
public extension StateOf where C: Computation {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ computation: C.Type,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: computation.key),
            read: { read in
                read(computation)
            },
            onChange: onChange
        )
    }

}

