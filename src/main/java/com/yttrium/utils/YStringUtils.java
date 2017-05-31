package com.yttrium.utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.UUID;

/**
 * 自定义String工具类
 * Created with IntelliJ IDEA
 * Created by yzy
 * Date: 2017/5/26
 * Time: 16:33
 */
public class YStringUtils {
    /**
     * MD5加密 用于密码加密
     * @param str 用于加密的
     * @return 加密完的
     */
    public static String getMD5(String str) {

        //加大解密难度
        str = str + "yangzhenyu";

        try {
            // 生成一个MD5加密计算摘要
            MessageDigest md = MessageDigest.getInstance("MD5");
            // 计算md5函数
            md.update(str.getBytes());
            // digest()最后确定返回md5 hash值，返回值为8为字符串。因为md5 hash值是16位的hex值，实际上就是8位的字符
            // BigInteger函数则将8位的字符串转换成16位hex值，用字符串来表示；得到字符串形式的hash值
            String md5=new BigInteger(1, md.digest()).toString(16);
            //BigInteger会把0省略掉，需补全至32位
            return fillMD5(md5);
        } catch (Exception e) {
            throw new RuntimeException("MD5加密错误:"+e.getMessage(),e);
        }
    }

    private static String fillMD5(String md5){
        return md5.length()==32?md5:fillMD5("0"+md5);
    }



    public static String getCode() {
        String uuid = UUID.randomUUID().toString().replace("-", "");
        System.err.println(uuid);
        return uuid;
    }

}
