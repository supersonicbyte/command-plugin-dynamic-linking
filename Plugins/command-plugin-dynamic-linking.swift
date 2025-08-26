import PackagePlugin
import Foundation

enum CommandError: Error, CustomStringConvertible {
    var description: String {
        String(describing: self)
    }

    case pluginError(String)
}

@main
struct command_plugin_dynamic_linking: CommandPlugin {
    // Entry point for command plugins applied to Swift Packages.
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let tool = try context.tool(named: "Core")

        let process = try Process.run(tool.url, arguments: arguments)
        process.waitUntilExit()

        if process.terminationReason != .exit || process.terminationStatus != 0 {
            throw CommandError.pluginError("`\(tool.name)` failed")
        } else {
            print("Works fine!")
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension command_plugin_dynamic_linking: XcodeCommandPlugin {
    // Entry point for command plugins applied to Xcode projects.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        print("Hello, World!")
    }
}

#endif
