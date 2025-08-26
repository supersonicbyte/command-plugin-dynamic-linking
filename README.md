Navigate to the `Client` package:

`cd LocalPackages/Client`.

Running `swift package command_plugin_dynamic_linking` gives the following error:

```
Building for debugging...
error: link command failed with exit code 1 (use -v to see invocation)
ld: library 'DynamicLib' not found
clang: error: linker command failed with exit code 1 (use -v to see invocation)
[11/13] Linking Core-tool
error: fatalError
```

If we run `ls .build/arm64-apple-macosx/debug` we can see the following output:
```
Client.build                        Core.build                          DynamicLib.build                    ModuleCache
Core-tool-entitlement.plist         description.json                    index                               Modules-tool
Core-tool.build                     DynamicLib-tool.build               libDynamicLib-tool.dylib            plugin-tools-description.json
Core-tool.product                   DynamicLib-tool.product             libDynamicLib-tool.dylib.dSYM       swift-version--58304C5D6DBC2206.txt
```

For some reason the `DynamicLib` is being built as `libDynamicLib-tool.dylib` but the compiler is searching for `libDynamicLib.dylib` and thus we get the mentioned error.

A workaround is to copy the `libDynamicLib-tool.dylib` and to name it `libDynamicLib.dylib` with the following command:

```
cp .build/arm64-apple-macosx/debug/libDynamicLib-tool.dylib .build/arm64-apple-macosx/debug/libDynamicLib.dylib
```

Now when we run `swift package command_plugin_dynamic_linking` everything works.

## Project Structure

```
command-plugin-dynamic-linking/
├── Package.swift                           # Main package manifest
├── Sources/
│   └── Core/
│       └── Core.swift                      # Executable target that uses DynamicLib
├── Plugins/
│   └── command-plugin-dynamic-linking.swift # Swift Package Manager command plugin
├── LocalPackages/
│   ├── Client/
│   │   ├── Package.swift
│   │   └── Sources/
│   │       └── main.swift
│   └── DynamicLib/
│       ├── Package.swift
│       ├── Sources/
│       │   └── DynamicLib/
│       │       └── DynamicLib.swift        # Dynamic library implementation
│       └── Tests/
│           └── DynamicLibTests/
│               └── DynamicLibTests.swift
└── README.md
```

### Package Layout

- **Main Package**: `command-plugin-dynamic-linking` - Contains the Core executable and the command plugin
- **Core Target**: Executable that depends on the DynamicLib local package
- **Command Plugin**: Custom SPM plugin that runs the Core executable
- **LocalPackages/DynamicLib**: Local Swift package providing dynamic library functionality
- **LocalPackages/Client**: Client package which we use to run the plugin command on
