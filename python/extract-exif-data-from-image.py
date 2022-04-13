# from https://piexif.readthedocs.io/en/latest/functions.html#load

import pickle
import piexif

exifDict = piexif.load("image_mod.jpg")

for ifdName in exifDict:
    print("\n{0} IFD:".format(ifdName))
    if isinstance(exifDict[ifdName], dict):
        for key in exifDict[ifdName]:
            try:
                data = exifDict[ifdName][key]
                if isinstance(data, bytes):
                    if key == piexif.ExifIFD.MakerNote:
                        d = pickle.loads(data)
                        print(key, d)
                    elif key == piexif.ExifIFD.UserComment:
                        if data[0:8] == b"UNICODE\0":
                            print(key, data[8:].decode("utf-8"))
                        else:
                            print(f"{key} type {type(data)}: {data[:10]}")
                else:
                    print(key, exifDict[ifdName][key][:10])
            except:
                print(key, exifDict[ifdName][key])
    else:
        print(f"{ifdName} is type {type(exifDict[ifdName])}")
