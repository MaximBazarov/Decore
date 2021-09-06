import DecoreStorage

// MARK: - StateOf -
public extension StateOf where C: Group {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ group: C.Type,
        at id: C.ID,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: group.key(at: id)),
            read: { read in
                read(group, at: id)
            },
            onChange: onChange
        )
    }

}

// MARK: - BindingTo -
public extension BindingTo where C: Group {

    convenience init(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function,
        _ group: C.Type,
        at id: C.ID,
        onChange: @escaping ( () -> C.Value ) -> Void = { _ in }
    ) {
        self.init(
            context: Context(
                fileName: file,
                line: line,
                column: column,
                function: function,
                container: group.key(at: id)),
            read: { read in
                read(group, at: id)
            },
            write: { write, value in
                write(value, for: group, at: id)
            },
            onChange: onChange
        )

    }

}
