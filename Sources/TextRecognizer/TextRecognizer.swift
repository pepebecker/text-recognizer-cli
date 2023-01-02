import ArgumentParser
import AppKit
import Vision

struct ValidationError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

@main
struct TextRecognizer: ParsableCommand {
    @Option(name: .shortAndLong, help: "The language of the text to recognize.")
    var language: String = "en"

    @Argument(help: "The image which contains the text to recognize.")
    var path: String

    func recognize(image: NSImage, languages: [String], callback: @escaping (Result<[String], Error>) -> Void) {
        let request = VNRecognizeTextRequest { (request, error) in
            var recognizedText = [String]()
            for observation in request.results as! [VNRecognizedTextObservation] {
                for candiate in observation.topCandidates(1) {
                    recognizedText.append(candiate.string)
                }
            }
            if let error = error {
                callback(.failure(error))
            } else {
                callback(.success(recognizedText))
            }
        }
        request.recognitionLanguages = languages
        request.recognitionLevel = .accurate
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            callback(.failure(NSError(domain: "", code: 0)))
            return
        }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try imageRequestHandler.perform([request])
        } catch {
            callback(.failure(error))
        }
    }

    mutating func run() throws {
        if path.isEmpty {
            print("Please provide a path to an image.")
            return
        }
        guard let absolutePath = realpath(path, nil) else {
            print("The path \(path) does not exist.")
            return
        }
        let absPath = String(cString: absolutePath)
        guard let image = NSImage(contentsOfFile: absPath) else {
            print("Could not load image from path: \(absPath)")
            return
        }
        recognize(image: image, languages: [language]) { result in
            switch result {
            case .success(let recognizedText):
                print(recognizedText.joined(separator: "\n"))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
