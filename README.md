# TextRecognizer CLI

[![GitHub release](https://img.shields.io/github/release/pepebecker/text-recognizer-cli.svg)](https://github.com/pepebecker/text-recognizer-cli/releases/latest)

TextRecognizer CLI is a command-line interface for performing text recognition on images. <br />
With this tool, you can easily extract text from images and specify the language of the text to improve the accuracy of the recognition.

## Install
```
brew tap pepebecker/tap
brew install text-recognizer
```

## Usage
```bash
recognize-text [--lang <lang>] <path>
```

## Arguments
- `<path>`: The path to the image containing the text to recognize.

## Options
- `--supported-languages`: Show a list of all supported languages.
- `-l`, `--lang <lang>`: The language of the text to recognize. (default: en)
- `-h`, `--help`: Show help information.

## Example
To recognize text in an image located at /path/to/image.png in English:
```bash
recognize-text /path/to/image.png
```

To recognize text in the same image in Spanish:
```bash
recognize-text --language es /path/to/image.png
```

To list all supported languages:
```bash
recognize-text --supported-languages
```

The following is an exemple output of the command above:
```
Supported languages:
en-US    : English
fr-FR    : Français
it-IT    : Italiano
de-DE    : Deutsch
es-ES    : Español
pt-BR    : Português
zh-Hans  : 中文
zh-Hant  : 中文
yue-Hans : 粤语
yue-Hant : 廣東話
ko-KR    : 한국어
ja-JP    : 日本語
ru-RU    : Русский
uk-UA    : Українська
```

## Build From Source
To build TextRecognizer from source, you need to have [Swift Package Manager](https://swift.org/package-manager/) installed. Then, run the following command:
```bash
swift build -c release --arch arm64 --arch x86_64
cp .build/apple/Products/Release/recognize-text ./recognize-text
```

## Dependencies
- [TextRecognizer](https://github.com/pepebecker/text-recognizer-swift)
- [ArgumentParser](https://github.com/apple/swift-argument-parser)

## License
TextRecognizer CLI is released under the ISC license. [See LICENSE](LICENSE) for details.

## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/pepebecker/text-recognizer-cli/issues).
