import AppKit
import ArgumentParser
import TextRecognizer

enum MyError: Error, LocalizedError, CustomNSError {
  case missingPath
  case invalidPath(String)
  case couldNotLoadImage(String)

  var errorDescription: String? {
    switch self {
    case .missingPath:
      return "Please provide a path to an image."
    case .invalidPath(let path):
      return "The path \(path) does not exist."
    case .couldNotLoadImage(let path):
      return "Could not load image from path: \(path)"
    }
  }

  var errorCode: Int { 1 }
}

@main
struct TextRecognizerCLI: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "recognize-text",
    abstract: "Extract text in target language from an image"
  )

  @Flag(name: .customLong("supported-languages"), help: "Show supported languages.")
  var showSupportedLanguages: Bool = false

  @Option(name: [.short, .customLong("lang")], help: "The language of the text to recognize.")
  var languages = ["en"]

  @Argument(help: "The path to the image containing the text to recognize.")
  var path: String?

  mutating func run() throws {
    if showSupportedLanguages {
      print("Supported languages:")
      let supportedLanguageCodes = try TextRecognizer.supportedLanguages()
      for code in supportedLanguageCodes {
        let paddedCode = code.padding(toLength: 9, withPad: " ", startingAt: 0)
        let locale = Locale(identifier: code)
        if let languageName = locale.localizedString(forLanguageCode: code) {
          print("\(paddedCode): \(languageName)")
        } else {
          print(code)
        }
      }
      return
    }
    let path = self.path ?? ""
    if path.isEmpty {
      throw MyError.missingPath
    }
    guard let absPath = realpath(path, nil) else {
      throw MyError.invalidPath(path)
    }
    let absolutePath = String(cString: absPath)
    guard let image = NSImage(contentsOfFile: absolutePath) else {
      throw MyError.couldNotLoadImage(absolutePath)
    }
    let recognizedText = try TextRecognizer.recognize(image: image, languages: languages)
    print(recognizedText.joined(separator: "\n"))
  }
}
