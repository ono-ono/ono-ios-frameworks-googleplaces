// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localized {

  internal enum StatusCode {
    /// Malformed request.
    internal static var invalidRequest: String { return Localized.tr("Localizable", "StatusCode.invalidRequest") }
    /// OK
    internal static var ok: String { return Localized.tr("Localizable", "StatusCode.ok") }
    /// Too many requests.
    internal static var overQueryLimit: String { return Localized.tr("Localizable", "StatusCode.overQueryLimit") }
    /// Unsupported request.
    internal static var requestDenied: String { return Localized.tr("Localizable", "StatusCode.requestDenied") }
    /// Unknown error.
    internal static var unknownError: String { return Localized.tr("Localizable", "StatusCode.unknownError") }
    /// No results.
    internal static var zeroResults: String { return Localized.tr("Localizable", "StatusCode.zeroResults") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

