# From
# https://stackoverflow.com/questions/61626067/python-add-arbitrary-exif-data-to-image-usercomment-field

# https://stackoverflow.com/a/63400376/54745

from PIL import Image
import piexif
import pickle

image = Image.open("image.jpg")

exifData = image._getexif()

if exifData is None:
    exifData = {}


tags = {
    "url_current": "https://stackoverflow.com/q/52729428/1846249",
    "contains_fish": False,
    3: 0.14159265358979323,
}

data = pickle.dumps(tags)
exifIfd = {
    piexif.ExifIFD.MakerNote: data,
    piexif.ExifIFD.UserComment: b"UNICODE\0" + "my message".encode("utf-8"),
}

exifDict = {"0th": {}, "Exif": exifIfd, "1st": {}, "thumbnail": None, "GPS": {}}

exifDataBytes = piexif.dump(exifDict)

image.save("image_mod.jpg", format="jpeg", exif=exifDataBytes)
