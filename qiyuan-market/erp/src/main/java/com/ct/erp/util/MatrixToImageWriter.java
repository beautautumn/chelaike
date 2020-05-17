package com.ct.erp.util;

import com.google.zxing.common.BitMatrix;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.OutputStream;
import java.io.IOException;
import java.awt.image.BufferedImage;

/**
 * 生成二维码图片类
 * @author admin
 *
 */
public final class MatrixToImageWriter {
	
	/**
	 * 黑色
	 */
	private static final int BLACK = 0xFF000000;
	
	/**
	 * 白色
	 */
	private static final int WHITE = 0xFFFFFFFF;

	private MatrixToImageWriter() {
	}

	public static String a(String fileName, String text){
		
		return "";
	}
	
	/**
	 * 转化成图片
	 * @param matrix
	 * @return
	 */
	public static BufferedImage toBufferedImage(BitMatrix matrix) {
		int width = matrix.getWidth();
		int height = matrix.getHeight();
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				image.setRGB(x, y, matrix.get(x, y) ? BLACK : WHITE);
			}
		}
		return image;
	}

	/**
	 * 输出图片文件
	 * @param matrix
	 * @param format
	 * @param file
	 * @throws IOException
	 */
	public static void writeToFile(BitMatrix matrix, String format, File file) throws IOException {
		BufferedImage image = toBufferedImage(matrix);
		if (!ImageIO.write(image, format, file)) {
			throw new IOException("Could not write an image of format " + format + " to " + file);
		}
	}

	/**
	 * 写入文件输出流
	 * @param matrix
	 * @param format
	 * @param stream
	 * @throws IOException
	 */
	public static void writeToStream(BitMatrix matrix, String format, OutputStream stream) throws IOException {
		BufferedImage image = toBufferedImage(matrix);
		if (!ImageIO.write(image, format, stream)) {
			throw new IOException("Could not write an image of format " + format);
		}
	}

}
