package com.ct.erp.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

public class UIDGenerator {
    private final static String YYMMDDHHMMSS = "yyMMddHHmmss";
    public static String getUid(int length) {
        if (length >= 12) {
            length = length - 12;
            StringBuffer stringBuffer = new StringBuffer(getCurrentDate(0, YYMMDDHHMMSS));
            Random random = new Random();
            for (int i = 0; i < length; i++) {
                stringBuffer.append(random.nextInt(10));
            }
            return stringBuffer.toString();
        } else {
            return getRandom(length);
        }
    }
    public static String getCurrentDate(int increment, String pattern) {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DAY_OF_MONTH, increment);
        Date date = c.getTime();
        DateFormat df = new SimpleDateFormat(pattern);
        return df.format(date);
    }
    private static String getRandom(int length) {
        StringBuffer stringBuffer = new StringBuffer("");
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            stringBuffer.append(random.nextInt(10));
        }
        return stringBuffer.toString();
    }
}
