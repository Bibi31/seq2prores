# Example Usage

This file demonstrates example usage scenarios for the seq2prores.bat script.

## Example 1: Basic EXR Sequence

**Input Files:**
```
C:\Projects\VFX\shot_01.0001.exr
C:\Projects\VFX\shot_01.0002.exr
C:\Projects\VFX\shot_01.0003.exr
...
C:\Projects\VFX\shot_01.0100.exr
```

**Action:**
Drag `shot_01.0001.exr` onto `seq2prores.bat`

**Expected Output:**
```
========================================
  Image Sequence to ProRes Converter
========================================

Dropped file: "C:\Projects\VFX\shot_01.0001.exr"
Working directory: "C:\Projects\VFX\"

FFmpeg found: OK

Parsed components:
  Base name: shot_01
  Padding: 0001 (length: 4)
  Extension: .exr

FFmpeg input pattern: "shot_01.%04d.exr"
Output file: "shot_01.mov"

Starting FFmpeg conversion...
----------------------------------------
Command details:
  Frame rate: 24 FPS
  Codec: ProRes Proxy (profile:v 0)
  Color space: BT.709
----------------------------------------

========================================
  SUCCESS: Conversion completed
========================================

Output file: "shot_01.mov"

Log file deleted (conversion successful).

Press any key to continue . . .
```

**Result:**
A new file `shot_01.mov` is created in `C:\Projects\VFX\`

---

## Example 2: PNG Sequence with Long Padding

**Input Files:**
```
D:\renders\character_walk.00001.png
D:\renders\character_walk.00002.png
...
D:\renders\character_walk.00250.png
```

**Action:**
Drag `character_walk.00001.png` onto `seq2prores.bat`

**Expected Pattern:**
- Base name: `character_walk`
- Padding: `00001` (length: 5)
- FFmpeg pattern: `character_walk.%05d.png`
- Output: `character_walk.mov`

---

## Example 3: Complex Name with Dots

**Input Files:**
```
E:\footage\project.v2.final.0001.jpg
E:\footage\project.v2.final.0002.jpg
...
```

**Action:**
Drag `project.v2.final.0001.jpg` onto `seq2prores.bat`

**Expected Pattern:**
- Base name: `project.v2.final`
- Padding: `0001` (length: 4)
- FFmpeg pattern: `project.v2.final.%04d.jpg`
- Output: `project.v2.final.mov`

---

## Example 4: Error - FFmpeg Not Found

**Expected Output:**
```
========================================
  Image Sequence to ProRes Converter
========================================

Dropped file: "C:\test\frame.0001.exr"
Working directory: "C:\test\"

ERROR: ffmpeg.exe is not found in the system PATH.
Please install FFmpeg and add it to your PATH environment variable.
Download FFmpeg from: https://ffmpeg.org/download.html
Press any key to continue . . .
```

**Solution:**
Install FFmpeg and add it to your system PATH.

---

## Example 5: Error - Invalid Filename Format

**Input File:**
```
C:\test\invalid_name.exr
```

**Expected Output:**
```
========================================
  Image Sequence to ProRes Converter
========================================

Dropped file: "C:\test\invalid_name.exr"
Working directory: "C:\test\"

FFmpeg found: OK

ERROR: Unable to parse padding from filename.
Expected format: {name}.{padding}.{extension}
Example: shot_01.0001.exr
Received: "invalid_name.exr"
Press any key to continue . . .
```

**Solution:**
Rename your files to follow the `{name}.{padding}.{extension}` format.

---

## Testing the Script

### Test 1: Verify FFmpeg Installation
```cmd
ffmpeg -version
```
Should display FFmpeg version information.

### Test 2: Create Test Sequence
You can create a test sequence using FFmpeg itself:
```cmd
ffmpeg -f lavfi -i testsrc=size=1920x1080:rate=24 -frames:v 10 test_sequence.%04d.png
```
This creates `test_sequence.0001.png` through `test_sequence.0010.png`

### Test 3: Run the Conversion
Drag `test_sequence.0001.png` onto `seq2prores.bat`

### Test 4: Verify Output
Check that `test_sequence.mov` was created and can be played.

---

## Advanced Customization Examples

### Custom Frame Rate (29.97 FPS)
Edit line 150 in `seq2prores.bat`:
```batch
ffmpeg -framerate 29.97 -i "%INPUT_PATTERN%" -c:v prores -profile:v 0 -color_trc bt709 -color_primaries bt709 -colorspace bt709 -y "%OUTPUT_FILE%" > "%LOG_FILE%" 2>&1
```

### Higher Quality ProRes (ProRes 422 HQ)
Edit line 150 in `seq2prores.bat`:
```batch
ffmpeg -framerate 24 -i "%INPUT_PATTERN%" -c:v prores -profile:v 3 -color_trc bt709 -color_primaries bt709 -colorspace bt709 -y "%OUTPUT_FILE%" > "%LOG_FILE%" 2>&1
```

### Custom Output Directory
Edit around line 133 in `seq2prores.bat`:
```batch
set "OUTPUT_FILE=C:\Output\ProRes\%BASE_NAME%.mov"
```

### Different Color Space (sRGB)
Edit line 150 in `seq2prores.bat`:
```batch
ffmpeg -framerate 24 -i "%INPUT_PATTERN%" -c:v prores -profile:v 0 -color_trc iec61966-2-1 -color_primaries bt709 -colorspace bt709 -y "%OUTPUT_FILE%" > "%LOG_FILE%" 2>&1
```
