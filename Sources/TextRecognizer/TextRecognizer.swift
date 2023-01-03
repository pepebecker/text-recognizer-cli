import ArgumentParser
import AppKit
import Vision

enum MyError: Error, LocalizedError, CustomNSError {
    case notSupported
    case missingPath
    case invalidPath(String)
    case couldNotLoadImage(String)
    case couldNotConvertImage

    var errorDescription: String? {
        switch self {
        case .notSupported:
            return "Not supported on this macOS version."
        case .missingPath:
            return "Please provide a path to an image."
        case .invalidPath(let path):
            return "The path \(path) does not exist."
        case .couldNotLoadImage(let path):
            return "Could not load image from path: \(path)"
        case .couldNotConvertImage:
            return "Could not convert image to CGImage."
        }
    }

    var errorCode: Int { 1 }
}

@main
struct TextRecognizer: ParsableCommand {
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

    func recognize(image: NSImage, languages: [String]) throws -> [String] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw MyError.couldNotConvertImage
        }
        let semaphore = DispatchSemaphore(value: 0)
        var result = [String]()
        var error: Error?
        let request = VNRecognizeTextRequest { (request, err) in
            guard err == nil else {
                error = err
                return
            }
            for observation in request.results as! [VNRecognizedTextObservation] {
                for candiate in observation.topCandidates(1) {
                    result.append(candiate.string)
                }
            }
            semaphore.signal()
        }
        request.recognitionLanguages = languages
        request.recognitionLevel = .accurate
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try imageRequestHandler.perform([request])
        semaphore.wait()
        if let error = error {
            throw error
        }
        return result
    }

    mutating func run() throws {
        if showSupportedLanguages {
            if #available(macOS 12.0, *) {
                print("Supported languages:")
                let supportedLanguageCodes = try VNRecognizeTextRequest().supportedRecognitionLanguages()
                for code in supportedLanguageCodes {
                    let paddedCode = code.padding(toLength: 9, withPad: " ", startingAt: 0)
                    let locale = Locale(identifier: code)
                    if let languageName = locale.localizedString(forLanguageCode: code) {
                        print("\(paddedCode): \(languageName)")
                    } else {
                        print(code)
                    }
                }
            } else {
                throw MyError.notSupported
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
        let recognizedText = try recognize(image: image, languages: languages)
        print(recognizedText.joined(separator: "\n"))
    }
}
