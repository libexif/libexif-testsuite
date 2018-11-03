#!/bin/sh
# Tests the various output formats

. ./check-vars.sh

readonly originalimg="$SRCDIR/images/canon-powershot-g2-001.jpg"
readonly tmpimg="check-output.jpg"
readonly tmpfile="check-output.tmp"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

echo Add some tags with difficult data
$EXIFEXE --no-fixup --tag=ImageDescription --ifd=0 --set-value="Foo & Bar <Baz> extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code" --output="$tmpimg" "$originalimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }

echo Check tags in normal format
# Strip path from file name
$EXIFEXE --width=200 "$tmpimg" 2>&1 | sed -e "/EXIF tags/s@/.*/@@" > "$tmpfile"
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
EXIF tags in 'check-output.jpg' ('Intel' byte order):
--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Tag                 |Value
--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Image Description   |Foo & Bar <Baz> extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code
Manufacturer        |Canon
Model               |Canon PowerShot G2
Orientation         |Top-left
X-Resolution        |180
Y-Resolution        |180
Resolution Unit     |Inch
Date and Time       |2005:03:17 04:36:48
YCbCr Positioning   |Centered
Compression         |JPEG compression
X-Resolution        |180
Y-Resolution        |180
Resolution Unit     |Inch
Exposure Time       |1/10 sec.
F-Number            |f/4.5
Exif Version        |Exif Version 2.2
Date and Time (Origi|2005:03:17 04:36:48
Date and Time (Digit|2005:03:17 04:36:48
Components Configura|Y Cb Cr -
Compressed Bits per | 2
Shutter Speed       |3.31 EV (1/9 sec.)
Aperture            |4.34 EV (f/4.5)
Exposure Bias       |0.00 EV
Maximum Aperture Val|2.00 EV (f/2.0)
Metering Mode       |Pattern
Flash               |Flash did not fire, compulsory flash mode
Focal Length        |7.0 mm
Maker Note          |450 bytes undefined data
User Comment        |
FlashPixVersion     |FlashPix Version 1.0
Color Space         |sRGB
Pixel X Dimension   |640
Pixel Y Dimension   |480
Focal Plane X-Resolu|2285.714
Focal Plane Y-Resolu|2285.714
Focal Plane Resoluti|Inch
Sensing Method      |One-chip color area sensor
File Source         |DSC
Custom Rendered     |Normal process
Exposure Mode       |Manual exposure
White Balance       |Auto white balance
Digital Zoom Ratio  |1.0000
Scene Capture Type  |Standard
Interoperability Ind|R98
Interoperability Ver|0100
RelatedImageWidth   |640
RelatedImageLength  |480
--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXIF data contains a thumbnail (968 bytes).
EOF
test $? -eq 0 || exit 1

echo Check tags in machine-readable format
$EXIFEXE --machine-readable "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
Image Description	Foo & Bar <Baz> extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code
Manufacturer	Canon
Model	Canon PowerShot G2
Orientation	Top-left
X-Resolution	180
Y-Resolution	180
Resolution Unit	Inch
Date and Time	2005:03:17 04:36:48
YCbCr Positioning	Centered
Compression	JPEG compression
X-Resolution	180
Y-Resolution	180
Resolution Unit	Inch
Exposure Time	1/10 sec.
F-Number	f/4.5
Exif Version	Exif Version 2.2
Date and Time (Original)	2005:03:17 04:36:48
Date and Time (Digitized)	2005:03:17 04:36:48
Components Configuration	Y Cb Cr -
Compressed Bits per Pixel	 2
Shutter Speed	3.31 EV (1/9 sec.)
Aperture	4.34 EV (f/4.5)
Exposure Bias	0.00 EV
Maximum Aperture Value	2.00 EV (f/2.0)
Metering Mode	Pattern
Flash	Flash did not fire, compulsory flash mode
Focal Length	7.0 mm
Maker Note	450 bytes undefined data
User Comment	
FlashPixVersion	FlashPix Version 1.0
Color Space	sRGB
Pixel X Dimension	640
Pixel Y Dimension	480
Focal Plane X-Resolution	2285.714
Focal Plane Y-Resolution	2285.714
Focal Plane Resolution Unit	Inch
Sensing Method	One-chip color area sensor
File Source	DSC
Custom Rendered	Normal process
Exposure Mode	Manual exposure
White Balance	Auto white balance
Digital Zoom Ratio	1.0000
Scene Capture Type	Standard
Interoperability Index	R98
Interoperability Version	0100
RelatedImageWidth	640
RelatedImageLength	480
ThumbnailSize	968
EOF
test $? -eq 0 || exit 1

echo Check tags in XML format
$EXIFEXE --xml-output "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
<exif>
	<Image_Description>Foo &amp; Bar &lt;Baz&gt; extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code</Image_Description>
	<Manufacturer>Canon</Manufacturer>
	<Model>Canon PowerShot G2</Model>
	<Orientation>Top-left</Orientation>
	<X-Resolution>180</X-Resolution>
	<Y-Resolution>180</Y-Resolution>
	<Resolution_Unit>Inch</Resolution_Unit>
	<Date_and_Time>2005:03:17 04:36:48</Date_and_Time>
	<YCbCr_Positioning>Centered</YCbCr_Positioning>
	<Compression>JPEG compression</Compression>
	<X-Resolution>180</X-Resolution>
	<Y-Resolution>180</Y-Resolution>
	<Resolution_Unit>Inch</Resolution_Unit>
	<Exposure_Time>1/10 sec.</Exposure_Time>
	<F-Number>f/4.5</F-Number>
	<Exif_Version>Exif Version 2.2</Exif_Version>
	<Date_and_Time__Original_>2005:03:17 04:36:48</Date_and_Time__Original_>
	<Date_and_Time__Digitized_>2005:03:17 04:36:48</Date_and_Time__Digitized_>
	<Components_Configuration>Y Cb Cr -</Components_Configuration>
	<Compressed_Bits_per_Pixel> 2</Compressed_Bits_per_Pixel>
	<Shutter_Speed>3.31 EV (1/9 sec.)</Shutter_Speed>
	<Aperture>4.34 EV (f/4.5)</Aperture>
	<Exposure_Bias>0.00 EV</Exposure_Bias>
	<Maximum_Aperture_Value>2.00 EV (f/2.0)</Maximum_Aperture_Value>
	<Metering_Mode>Pattern</Metering_Mode>
	<Flash>Flash did not fire, compulsory flash mode</Flash>
	<Focal_Length>7.0 mm</Focal_Length>
	<Maker_Note>450 bytes undefined data</Maker_Note>
	<User_Comment></User_Comment>
	<FlashPixVersion>FlashPix Version 1.0</FlashPixVersion>
	<Color_Space>sRGB</Color_Space>
	<Pixel_X_Dimension>640</Pixel_X_Dimension>
	<Pixel_Y_Dimension>480</Pixel_Y_Dimension>
	<Focal_Plane_X-Resolution>2285.714</Focal_Plane_X-Resolution>
	<Focal_Plane_Y-Resolution>2285.714</Focal_Plane_Y-Resolution>
	<Focal_Plane_Resolution_Unit>Inch</Focal_Plane_Resolution_Unit>
	<Sensing_Method>One-chip color area sensor</Sensing_Method>
	<File_Source>DSC</File_Source>
	<Custom_Rendered>Normal process</Custom_Rendered>
	<Exposure_Mode>Manual exposure</Exposure_Mode>
	<White_Balance>Auto white balance</White_Balance>
	<Digital_Zoom_Ratio>1.0000</Digital_Zoom_Ratio>
	<Scene_Capture_Type>Standard</Scene_Capture_Type>
	<Interoperability_Index>R98</Interoperability_Index>
	<Interoperability_Version>0100</Interoperability_Version>
	<RelatedImageWidth>640</RelatedImageWidth>
	<RelatedImageLength>480</RelatedImageLength>
</exif>
EOF
test $? -eq 0 || exit 1

echo Check tags in normal format with IDs
# Strip path from file name
$EXIFEXE --ids --width=200 "$tmpimg" 2>&1 | sed -e "/EXIF tags/s@/.*/@@" > "$tmpfile"
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
EXIF tags in 'check-output.jpg' ('Intel' byte order):
------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Tag   |Value
------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
0x010e|Foo & Bar <Baz> extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code
0x010f|Canon
0x0110|Canon PowerShot G2
0x0112|Top-left
0x011a|180
0x011b|180
0x0128|Inch
0x0132|2005:03:17 04:36:48
0x0213|Centered
0x0103|JPEG compression
0x011a|180
0x011b|180
0x0128|Inch
0x829a|1/10 sec.
0x829d|f/4.5
0x9000|Exif Version 2.2
0x9003|2005:03:17 04:36:48
0x9004|2005:03:17 04:36:48
0x9101|Y Cb Cr -
0x9102| 2
0x9201|3.31 EV (1/9 sec.)
0x9202|4.34 EV (f/4.5)
0x9204|0.00 EV
0x9205|2.00 EV (f/2.0)
0x9207|Pattern
0x9209|Flash did not fire, compulsory flash mode
0x920a|7.0 mm
0x927c|450 bytes undefined data
0x9286|
0xa000|FlashPix Version 1.0
0xa001|sRGB
0xa002|640
0xa003|480
0xa20e|2285.714
0xa20f|2285.714
0xa210|Inch
0xa217|One-chip color area sensor
0xa300|DSC
0xa401|Normal process
0xa402|Manual exposure
0xa403|Auto white balance
0xa404|1.0000
0xa406|Standard
0x0001|R98
0x0002|0100
0x1001|640
0x1002|480
------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXIF data contains a thumbnail (968 bytes).
EOF
test $? -eq 0 || exit 1

echo Check tags in machine-readable format with IDs
$EXIFEXE --ids --machine-readable "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
0x010e	Foo & Bar <Baz> extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code
0x010f	Canon
0x0110	Canon PowerShot G2
0x0112	Top-left
0x011a	180
0x011b	180
0x0128	Inch
0x0132	2005:03:17 04:36:48
0x0213	Centered
0x0103	JPEG compression
0x011a	180
0x011b	180
0x0128	Inch
0x829a	1/10 sec.
0x829d	f/4.5
0x9000	Exif Version 2.2
0x9003	2005:03:17 04:36:48
0x9004	2005:03:17 04:36:48
0x9101	Y Cb Cr -
0x9102	 2
0x9201	3.31 EV (1/9 sec.)
0x9202	4.34 EV (f/4.5)
0x9204	0.00 EV
0x9205	2.00 EV (f/2.0)
0x9207	Pattern
0x9209	Flash did not fire, compulsory flash mode
0x920a	7.0 mm
0x927c	450 bytes undefined data
0x9286	
0xa000	FlashPix Version 1.0
0xa001	sRGB
0xa002	640
0xa003	480
0xa20e	2285.714
0xa20f	2285.714
0xa210	Inch
0xa217	One-chip color area sensor
0xa300	DSC
0xa401	Normal process
0xa402	Manual exposure
0xa403	Auto white balance
0xa404	1.0000
0xa406	Standard
0x0001	R98
0x0002	0100
0x1001	640
0x1002	480
ThumbnailSize	968
EOF
test $? -eq 0 || exit 1

echo Check tags in XML format with IDs
$EXIFEXE --ids --xml-output "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
<exif>
<x010e>Foo &amp; Bar &lt;Baz&gt; extra long string that will require internal reallocation so is a more complete test of the internal XML escaping code</x010e><x010f>Canon</x010f><x0110>Canon PowerShot G2</x0110><x0112>Top-left</x0112><x011a>180</x011a><x011b>180</x011b><x0128>Inch</x0128><x0132>2005:03:17 04:36:48</x0132><x0213>Centered</x0213><x0103>JPEG compression</x0103><x011a>180</x011a><x011b>180</x011b><x0128>Inch</x0128><x829a>1/10 sec.</x829a><x829d>f/4.5</x829d><x9000>Exif Version 2.2</x9000><x9003>2005:03:17 04:36:48</x9003><x9004>2005:03:17 04:36:48</x9004><x9101>Y Cb Cr -</x9101><x9102> 2</x9102><x9201>3.31 EV (1/9 sec.)</x9201><x9202>4.34 EV (f/4.5)</x9202><x9204>0.00 EV</x9204><x9205>2.00 EV (f/2.0)</x9205><x9207>Pattern</x9207><x9209>Flash did not fire, compulsory flash mode</x9209><x920a>7.0 mm</x920a><x927c>450 bytes undefined data</x927c><x9286></x9286><xa000>FlashPix Version 1.0</xa000><xa001>sRGB</xa001><xa002>640</xa002><xa003>480</xa003><xa20e>2285.714</xa20e><xa20f>2285.714</xa20f><xa210>Inch</xa210><xa217>One-chip color area sensor</xa217><xa300>DSC</xa300><xa401>Normal process</xa401><xa402>Manual exposure</xa402><xa403>Auto white balance</xa403><xa404>1.0000</xa404><xa406>Standard</xa406><x0001>R98</x0001><x0002>0100</x0002><x1001>640</x1001><x1002>480</x1002></exif>
EOF
test $? -eq 0 || exit 1

echo Check MakerNote tags in normal format
$EXIFEXE --show-mnote "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
MakerNote contains 78 values:
Macro Mode          |Normal
Self-timer          |Off
Quality             |Normal
Flash Mode          |Off
Drive Mode          |Single
Unknown Tag         |0x0000
Focus Mode          |Single
Unknown Tag         |0x0000
Record Mode         |JPEG
Image Size          |Small
Easy Shooting Mode  |Manual
Digital Zoom        |None
Contrast            |Normal
Saturation          |Normal
Sharpness           |Normal
ISO                 |50
Metering Mode       |Evaluative
Focus Range         |Auto
AF Point            |Center
Exposure Mode       |Manual
Unknown Tag         |0xffff
Lens Type           |0xffff
Long Focal Length of|672
Short Focal Length o|224
Focal Units per mm  |32
Maximal Aperture    |2.07
Minimal Aperture    |8.00
Flash Activity      |0x0000
Flash Details       |
Unknown Tag         |0x0000
Unknown Tag         |0x0000
Focus Mode          |Continuous
AE Setting          |Normal AE
Image Stabilization |0xffff
Display Aperture    |0.00
Zoom Source Width   |2272
Zoom Target Width   |2272
Unknown Tag         |0x0000
Unknown Tag         |0x0001
Focal Type          |Zoom
Focal Length        |224
Focal Plane X Size  |7.26 mm
Focal Plane Y Size  |5.46 mm
Unknown Tag         |0 0 0 0 
Auto ISO            |1.000
Shot ISO            |50
Measured EV         |-10.91 EV
Target Aperture     |4.51
Target Exposure Time|1/9
Exposure Compensatio|0.00 EV
White Balance       |Auto
Slow Shutter        |Off
Sequence Number     |0
Unknown Tag         |0x0000
Unknown Tag         |0x0000
Unknown Tag         |0x0000
Flash Guide Number  |0.00
AF Point            |Center
Flash Exposure Compe|0.00 EV
AE Bracketing       |Off
AE Bracket Value    |0.00 EV
Unknown Tag         |0x0001
Focus Distance Upper|3595 mm
Focus Distance Lower|0 mm
F-Number            |4.51
Exposure Time       |1/9
Unknown Tag         |0x0000
Bulb Duration       |0x0000
Unknown Tag         |0xffd0
Camera Type         |Compact
Unknown Tag         |0 0 0 0 0 0 
Unknown Tag         |0 0 0 0 
Image Type          |IMG:PowerShot G2 JPEG
Firmware Version    |Firmware Version 1.10
Image Number        |206-0616
Owner Name          |John Doe Camera Owner
Unknown Tag         |17825792 
Unknown Tag         |42 3 32769 114 32769 39 0 0 65070 0 0 10 65504 65488 0 220
EOF
test $? -eq 0 || exit 1

echo Check MakerNote tags in machine-readable format
$EXIFEXE --show-mnote --machine-readable  "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
Macro Mode	Normal
Self-timer	Off
Quality	Normal
Flash Mode	Off
Drive Mode	Single
Unknown Tag	0x0000
Focus Mode	Single
Unknown Tag	0x0000
Record Mode	JPEG
Image Size	Small
Easy Shooting Mode	Manual
Digital Zoom	None
Contrast	Normal
Saturation	Normal
Sharpness	Normal
ISO	50
Metering Mode	Evaluative
Focus Range	Auto
AF Point	Center
Exposure Mode	Manual
Unknown Tag	0xffff
Lens Type	0xffff
Long Focal Length of Lens	672
Short Focal Length of Lens	224
Focal Units per mm	32
Maximal Aperture	2.07
Minimal Aperture	8.00
Flash Activity	0x0000
Flash Details	
Unknown Tag	0x0000
Unknown Tag	0x0000
Focus Mode	Continuous
AE Setting	Normal AE
Image Stabilization	0xffff
Display Aperture	0.00
Zoom Source Width	2272
Zoom Target Width	2272
Unknown Tag	0x0000
Unknown Tag	0x0001
Focal Type	Zoom
Focal Length	224
Focal Plane X Size	7.26 mm
Focal Plane Y Size	5.46 mm
Unknown Tag	0 0 0 0 
Auto ISO	1.000
Shot ISO	50
Measured EV	-10.91 EV
Target Aperture	4.51
Target Exposure Time	1/9
Exposure Compensation	0.00 EV
White Balance	Auto
Slow Shutter	Off
Sequence Number	0
Unknown Tag	0x0000
Unknown Tag	0x0000
Unknown Tag	0x0000
Flash Guide Number	0.00
AF Point	Center
Flash Exposure Compensation	0.00 EV
AE Bracketing	Off
AE Bracket Value	0.00 EV
Unknown Tag	0x0001
Focus Distance Upper	3595 mm
Focus Distance Lower	0 mm
F-Number	4.51
Exposure Time	1/9
Unknown Tag	0x0000
Bulb Duration	0x0000
Unknown Tag	0xffd0
Camera Type	Compact
Unknown Tag	0 0 0 0 0 0 
Unknown Tag	0 0 0 0 
Image Type	IMG:PowerShot G2 JPEG
Firmware Version	Firmware Version 1.10
Image Number	206-0616
Owner Name	John Doe Camera Owner
Unknown Tag	17825792 
Unknown Tag	42 3 32769 114 32769 39 0 0 65070 0 0 10 65504 65488 0 220
EOF
test $? -eq 0 || exit 1

echo Check MakerNote tags in normal format with IDs
$EXIFEXE --ids --show-mnote "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
MakerNote contains 78 values:
0x0001|Normal
0x0001|Off
0x0001|Normal
0x0001|Off
0x0001|Single
0x0001|0x0000
0x0001|Single
0x0001|0x0000
0x0001|JPEG
0x0001|Small
0x0001|Manual
0x0001|None
0x0001|Normal
0x0001|Normal
0x0001|Normal
0x0001|50
0x0001|Evaluative
0x0001|Auto
0x0001|Center
0x0001|Manual
0x0001|0xffff
0x0001|0xffff
0x0001|672
0x0001|224
0x0001|32
0x0001|2.07
0x0001|8.00
0x0001|0x0000
0x0001|
0x0001|0x0000
0x0001|0x0000
0x0001|Continuous
0x0001|Normal AE
0x0001|0xffff
0x0001|0.00
0x0001|2272
0x0001|2272
0x0001|0x0000
0x0001|0x0001
0x0002|Zoom
0x0002|224
0x0002|7.26 mm
0x0002|5.46 mm
0x0003|0 0 0 0 
0x0004|1.000
0x0004|50
0x0004|-10.91 EV
0x0004|4.51
0x0004|1/9
0x0004|0.00 EV
0x0004|Auto
0x0004|Off
0x0004|0
0x0004|0x0000
0x0004|0x0000
0x0004|0x0000
0x0004|0.00
0x0004|Center
0x0004|0.00 EV
0x0004|Off
0x0004|0.00 EV
0x0004|0x0001
0x0004|3595 mm
0x0004|0 mm
0x0004|4.51
0x0004|1/9
0x0004|0x0000
0x0004|0x0000
0x0004|0xffd0
0x0004|Compact
0x0000|0 0 0 0 0 0 
0x0000|0 0 0 0 
0x0006|IMG:PowerShot G2 JPEG
0x0007|Firmware Version 1.10
0x0008|206-0616
0x0009|John Doe Camera Owner
0x0010|17825792 
0x000d|42 3 32769 114 32769 39 0 0 65070 0 0 10 65504 65488 0 220 0 0 0 0 0 
EOF
test $? -eq 0 || exit 1

echo Check MakerNote tags in machine-readable format with IDs
$EXIFEXE --ids --show-mnote --machine-readable "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
0x0001	Normal
0x0001	Off
0x0001	Normal
0x0001	Off
0x0001	Single
0x0001	0x0000
0x0001	Single
0x0001	0x0000
0x0001	JPEG
0x0001	Small
0x0001	Manual
0x0001	None
0x0001	Normal
0x0001	Normal
0x0001	Normal
0x0001	50
0x0001	Evaluative
0x0001	Auto
0x0001	Center
0x0001	Manual
0x0001	0xffff
0x0001	0xffff
0x0001	672
0x0001	224
0x0001	32
0x0001	2.07
0x0001	8.00
0x0001	0x0000
0x0001	
0x0001	0x0000
0x0001	0x0000
0x0001	Continuous
0x0001	Normal AE
0x0001	0xffff
0x0001	0.00
0x0001	2272
0x0001	2272
0x0001	0x0000
0x0001	0x0001
0x0002	Zoom
0x0002	224
0x0002	7.26 mm
0x0002	5.46 mm
0x0003	0 0 0 0 
0x0004	1.000
0x0004	50
0x0004	-10.91 EV
0x0004	4.51
0x0004	1/9
0x0004	0.00 EV
0x0004	Auto
0x0004	Off
0x0004	0
0x0004	0x0000
0x0004	0x0000
0x0004	0x0000
0x0004	0.00
0x0004	Center
0x0004	0.00 EV
0x0004	Off
0x0004	0.00 EV
0x0004	0x0001
0x0004	3595 mm
0x0004	0 mm
0x0004	4.51
0x0004	1/9
0x0004	0x0000
0x0004	0x0000
0x0004	0xffd0
0x0004	Compact
0x0000	0 0 0 0 0 0 
0x0000	0 0 0 0 
0x0006	IMG:PowerShot G2 JPEG
0x0007	Firmware Version 1.10
0x0008	206-0616
0x0009	John Doe Camera Owner
0x0010	17825792 
0x000d	42 3 32769 114 32769 39 0 0 65070 0 0 10 65504 65488 0 220 0 0 0 0 0 
EOF
test $? -eq 0 || exit 1

echo "Check that MakerNote tags in XML format isn't allowed"
$EXIFEXE --show-mnote --xml-output "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 1 || { echo Incorrect return code; exit 1; }

echo "Check that MakerNote tags in XML format with IDs isn't allowed"
$EXIFEXE --ids --show-mnote --xml-output "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 1 || { echo Incorrect return code; exit 1; }

echo Check tags in normal format from one IFD
# Strip path from file name
$EXIFEXE --ifd=1 "$tmpimg" 2>&1 | sed -e "/EXIF tags/s@/.*/@@" > "$tmpfile"
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
EXIF tags in 'check-output.jpg' ('Intel' byte order):
--------------------+----------------------------------------------------------
Tag                 |Value
--------------------+----------------------------------------------------------
Compression         |JPEG compression
X-Resolution        |180
Y-Resolution        |180
Resolution Unit     |Inch
--------------------+----------------------------------------------------------
EXIF data contains a thumbnail (968 bytes).
EOF
test $? -eq 0 || exit 1

echo Check tags in machine-readable format from one IFD
$EXIFEXE --ifd=1 --machine-readable "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
Compression	JPEG compression
X-Resolution	180
Y-Resolution	180
Resolution Unit	Inch
ThumbnailSize	968
EOF
test $? -eq 0 || exit 1

echo Check tags in XML format from one IFD
$EXIFEXE --ifd=1 --xml-output "$tmpimg" > "$tmpfile" 2>&1
test $? -eq 0 || { echo Incorrect return code; exit 1; }
$DIFFEXE - "$tmpfile" <<EOF
<exif>
	<Compression>JPEG compression</Compression>
	<X-Resolution>180</X-Resolution>
	<Y-Resolution>180</Y-Resolution>
	<Resolution_Unit>Inch</Resolution_Unit>
</exif>
EOF
test $? -eq 0 || exit 1

# Cleanup
echo PASSED
rm -f "$tmpfile" "$tmpimg"
