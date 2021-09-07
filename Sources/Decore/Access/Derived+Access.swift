// MARK: - StateOf -
public extension StateOf where C: Derived {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ derived: C.Type,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: derived.key),
            read: { read in
                read(derived)
            },
            onChange: onChange
        )
    }

}

// MARK: - BindingTo -
public extension BindingTo where C: Derived {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ derived: C.Type,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: derived.key),
            read: { read in
                read(derived)
            },
            write: { write, value in
                write(value, for: derived)
            },
            onChange: onChange
        )
    }

}
