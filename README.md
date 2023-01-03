# TextRecognizer
TextRecognizer is a command-line interface for performing text recognition on images. <br />
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

The command above will output:
```
Supported languages:
en-US    : English
fr-FR    : français
it-IT    : italiano
de-DE    : Deutsch
es-ES    : español
pt-BR    : português
zh-Hans  : 中文
zh-Hant  : 中文
yue-Hans : 粤语
yue-Hant : 廣東話
ko-KR    : 한국어
ja-JP    : 日本語
ru-RU    : русский
uk-UA    : українська
```
