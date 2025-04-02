# EXIF data in images

references:
- https://piexif.readthedocs.io/en/latest/index.html
-
- https://stackoverflow.com/questions/61626067/python-add-arbitrary-exif-data-to-image-usercomment-field
- https://stackoverflow.com/questions/52729428/how-to-write-custom-metadata-into-jpeg-with-python
- https://stackoverflow.com/a/63400376/54745
- https://pil.readthedocs.io/en/latest/index.html
- UserComment encoding: https://github.com/SixLabors/ImageSharp/issues/1919#issuecomment-1004913497
- https://stackoverflow.com/questions/19284205/safe-to-use-utf8-decoding-for-exif-property-marked-as-ascii/19284524#19284524

## Writing Steps

- use PIL to load the image
- use pickle to encode arbitary data
- use piexif to create exif dictionaries
- use piexif to dump the dictionary to bytes
- write image out with exif=bytes

## Reading Steps

- use piexif to load the exif data from the file into a dict
- use pickle to extract and encoded data

## Tools:

- sudo apt-get install exiftool

## dump exif data as hex and ascii:

```bash
exiftool -All -b image_mod.jpg | od -A x -t x1z -v
```

```bash
000000 31 30 2e 38 30 69 6d 61 67 65 5f 6d 6f 64 2e 6a  >10.80image_mod.j<
000010 70 67 2e 31 31 38 37 37 32 30 32 32 3a 30 34 3a  >pg.118772022:04:<
000020 31 33 20 31 32 3a 31 33 3a 31 36 2d 30 37 3a 30  >13 12:13:16-07:0<
000030 30 32 30 32 32 3a 30 34 3a 31 33 20 31 32 3a 31  >02022:04:13 12:1<
000040 33 3a 30 34 2d 30 37 3a 30 30 32 30 32 32 3a 30  >3:04-07:002022:0<
000050 34 3a 31 33 20 31 32 3a 31 33 3a 31 36 2d 30 37  >4:13 12:13:16-07<
000060 3a 30 30 36 34 34 4a 50 45 47 4a 50 47 69 6d 61  >:00644JPEGJPGima<
000070 67 65 2f 6a 70 65 67 31 20 31 30 31 31 4d 4d e6  >ge/jpeg1 1011MM.<
000080 b5 b9 e2 81 ad e6 95 b3 e7 8d a1 e6 9d a5 31 31  >..............11<
000090 31 35 37 36 30 38 33 32 20 32 31 31 31 35 78 37  >15760832 21115x7<
0000a0 36 30 2e 30 38 34 37 34                          >60.08474<
```

as a list of tags and values:

```bash
exiftool -All image_mod.jpg
```

```text
ExifTool Version Number         : 10.80
File Name                       : image_mod.jpg
Directory                       : .
File Size                       : 12 kB
File Modification Date/Time     : 2022:04:13 12:13:16-07:00
File Access Date/Time           : 2022:04:13 12:13:19-07:00
File Inode Change Date/Time     : 2022:04:13 12:13:16-07:00
File Permissions                : rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : None
X Resolution                    : 1
Y Resolution                    : 1
Exif Byte Order                 : Big-endian (Motorola, MM)
User Comment                    : 浹⁭敳獡来
Image Width                     : 1115
Image Height                    : 76
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 1115x76
Megapixels                      : 0.085
```
