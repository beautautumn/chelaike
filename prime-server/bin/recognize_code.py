#coding:utf-8

import sys
from os import system, listdir, path, remove
from PIL import Image,ImageDraw

def getPixel(image,x,y,G,N):
    L = image.getpixel((x,y))
    if L > G:
        L = True
    else:
        L = False

    nearDots = 0
    if L == (image.getpixel((x - 1,y - 1)) > G):
        nearDots += 1
    if L == (image.getpixel((x - 1,y)) > G):
        nearDots += 1
    if L == (image.getpixel((x - 1,y + 1)) > G):
        nearDots += 1
    if L == (image.getpixel((x,y - 1)) > G):
        nearDots += 1
    if L == (image.getpixel((x,y + 1)) > G):
        nearDots += 1
    if L == (image.getpixel((x + 1,y - 1)) > G):
        nearDots += 1
    if L == (image.getpixel((x + 1,y)) > G):
        nearDots += 1
    if L == (image.getpixel((x + 1,y + 1)) > G):
        nearDots += 1

    if nearDots < N:
        return image.getpixel((x,y-1))
    else:
        return None

def clearNoise(image,G,N,Z):
    draw = ImageDraw.Draw(image)

    for i in xrange(0,Z):
        for x in xrange(1,image.size[0] - 1):
            for y in xrange(1,image.size[1] - 1):
                color = getPixel(image,x,y,G,N)
                if color != None:
                    draw.point((x,y),color)

def recognize(image_path, output_path):
    original_image = Image.open(image_path)
    code = ""

    image = original_image.convert("L")

    clearNoise(image, 20, 4, 4)

    image = image.crop((4, 3, 42, 19))

    bmp_path = path.splitext(image_path)[0] + ".bmp"
    image.save(bmp_path, "BMP")

    system("tesseract %s %s -l eng -psm 7 letters" % (bmp_path, output_path))
    code = open(output_path + ".txt", "r").read().replace(" ", "").replace("\n", "")

    remove(bmp_path)
    remove(output_path + ".txt")

    return code

#测试代码
def test():
    test_dir = "./test/seed_images/"

    total = 0
    recognized = 0

    # 测试
    for filename in listdir(test_dir):
        if not filename.endswith(".gif"): continue

        image_path = path.join(test_dir, filename)
        filename = path.splitext(path.basename(filename))[0]
        tmp_path = "/tmp/" + filename

        code = recognize(image_path, tmp_path)

        print "实际验证码：%s  ===  识别验证码：%s" % (filename, code)

        total += 1
        if code == filename: recognized += 1

    print "识别百分比：%s / %s" % (recognized, total)

def main():
    image_path = sys.argv[1]
    output_path = sys.argv[2]

    code = recognize(image_path, output_path)

    sys.stdout.write(code)
    return code

if __name__ == '__main__':
    main()
