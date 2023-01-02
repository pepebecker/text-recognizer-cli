# TextRecognizer
A command-line interface for performing text recognition on images.

## Usage
```bash
recognize-text [--language <language>] <path>
```

## Arguments
- `<path>`: The path to the image which contains the text to recognize.

## Options
- `-l`, `--language <language>`: The language of the text to recognize. Default: en.
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
