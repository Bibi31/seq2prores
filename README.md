# Image Sequence to ProRes Converter

A Windows drag-and-drop tool for converting image sequences to ProRes video files using FFmpeg.

## Overview

This tool provides a simple drag-and-drop workflow for converting image sequences (EXR, PNG, JPG, etc.) into ProRes video files. Designed for VFX and animation pipelines, it automates the conversion process with industry-standard settings.

## Features

- **Drag-and-Drop Interface**: Simply drag the first image of your sequence onto the script
- **Automatic Pattern Detection**: Intelligently parses filenames following the `{name}.{padding}.{extension}` convention
- **ProRes Proxy Output**: Generates lightweight ProRes Proxy files (profile 1) perfect for editorial review
- **BT.709 Color Space**: Applies industry-standard color space settings
- **Error Handling**: Comprehensive error checking with detailed logging
- **Clean Output**: Automatically deletes logs on success, preserves them on failure

## Requirements

### FFmpeg

This script requires FFmpeg to be installed and accessible in your system PATH.

**Download FFmpeg:**
- Official site: [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)
- Windows builds: [https://www.gyan.dev/ffmpeg/builds/](https://www.gyan.dev/ffmpeg/builds/) (recommended)

**Installation Steps:**

1. Download the FFmpeg executable (essentials build is sufficient)
2. Extract the archive to a location like `C:\ffmpeg`
3. Add the `bin` folder to your PATH:
   - Open System Properties → Environment Variables
   - Edit the `Path` variable under System variables
   - Add `C:\ffmpeg\bin` (or your installation path)
   - Click OK to save
4. Verify installation by opening Command Prompt and typing: `ffmpeg -version`

## Usage

### Filename Convention

Your image sequence must follow this naming convention:

```
{base_name}.{frame_number}.{extension}
```

**Examples:**
- `shot_01.0001.exr`
- `render_v002.0001.png`
- `scene_final.00001.jpg`
- `comp.001.dpx`

The padding (frame number) must consist only of digits and can be any length.

### Drag-and-Drop Workflow

1. **Prepare your sequence**: Ensure all images follow the naming convention
2. **Drop the first frame**: Drag and drop ONLY the first image (e.g., `shot_01.0001.exr`) onto `seq2prores.bat`
3. **Wait for conversion**: The script will:
   - Parse the filename
   - Detect the padding length
   - Convert the entire sequence to ProRes
4. **Get your output**: A `.mov` file will be created in the same directory

**Example:**

If you drop `shot_01.0001.exr`, the script will:
- Detect the pattern: `shot_01.%04d.exr`
- Process all frames: `shot_01.0001.exr`, `shot_01.0002.exr`, etc.
- Create output: `shot_01.mov`

### Encoding Settings

The script uses the following FFmpeg parameters:

- **Frame Rate**: 24 FPS
- **Codec**: ProRes (prores)
- **Profile**: 1 (ProRes Proxy)
- **Color Settings**:
  - Transfer Characteristics: BT.709
  - Color Primaries: BT.709
  - Color Space: BT.709
- **Overwrite**: Automatically overwrites existing files (-y flag)

### Output

- **Location**: Same directory as the input sequence
- **Filename**: Uses the base name with `.mov` extension
- **Format**: QuickTime MOV container with ProRes codec

## Error Handling

### FFmpeg Not Found

If you see "ffmpeg.exe is not found in the system PATH":
- Ensure FFmpeg is installed
- Verify the `bin` folder is in your PATH
- Restart Command Prompt/Explorer after modifying PATH

### Parsing Errors

If you see "Unable to parse padding from filename":
- Check that your filename follows the `{name}.{padding}.{extension}` format
- Ensure the padding consists only of digits
- Verify the first frame exists

### Conversion Failures

If the conversion fails:
- Check `conversion_log.txt` in the same directory for detailed error messages
- Verify all frames in the sequence exist
- Ensure frame numbers are sequential
- Check file permissions

## Troubleshooting

### The output file is not created

- Verify FFmpeg is working: Run `ffmpeg -version` in Command Prompt
- Check the log file for errors
- Ensure you have write permissions in the directory

### The script closes immediately

- You may have dropped multiple files instead of one
- The file path might contain special characters
- Try running from Command Prompt to see error messages

### Frame rate is wrong

- Edit the script and change the `-framerate 24` parameter
- Common values: 23.976, 24, 25, 29.97, 30, 60

### Different ProRes profile needed

Edit the script and change the `-profile:v` parameter:
- 0 = ProRes Proxy (smallest file size)
- 1 = ProRes LT
- 2 = ProRes Standard
- 3 = ProRes HQ (highest quality)

## Technical Details

### Filename Parsing Logic

The script uses the following logic to parse filenames:

1. Extracts the extension (e.g., `.exr`)
2. Splits the remaining name by dots
3. Treats the last segment as padding (must be all digits)
4. Joins all previous segments as the base name

### FFmpeg Pattern Construction

The script constructs an FFmpeg-compatible pattern:
- Original: `shot_01.0001.exr`
- Padding length: 4
- FFmpeg pattern: `shot_01.%04d.exr`

The `%04d` tells FFmpeg to look for 4-digit zero-padded frame numbers.

### Log File Management

- **Success**: `conversion_log.txt` is automatically deleted
- **Failure**: Log file is preserved for debugging
- **Location**: Same directory as the input sequence

## Customization

To modify the script for your pipeline:

1. **Frame Rate**: Change `-framerate 24` to your desired rate
2. **ProRes Profile**: Change `-profile:v 1` to 0, 2, or 3
3. **Color Space**: Modify the `setparams` filter values
4. **Output Location**: Change `set "OUTPUT_FILE=%BASE_NAME%.mov"` to include a different path

## License

This is free and unencumbered software released into the public domain.

## Support

For issues, questions, or contributions, please open an issue on the GitHub repository.

## Credits

Created for VFX and animation pipelines requiring quick ProRes conversions from image sequences.