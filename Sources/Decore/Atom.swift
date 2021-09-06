import DecoreStorage

// MARK: - StateOf -
public extension StateOf where C: Atom {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ atom: C.Type,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: atom.key),
            read: { read in
                read(atom)
            },
            onChange: onChange
        )
    }

}

// MARK: - BindingTo -
public extension BindingTo where C: Atom {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ atom: C.Type,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: atom.key),
            read: { read in
                read(atom)
            },
            write: { write, value in
                write(value, for: atom)
            },
            onChange: onChange
        )
    }

}
