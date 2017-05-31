package com.yttrium.domain;

/**
 * 返回json的默认实体类
 * Created with IntelliJ IDEA
 * Created 杨振宇
 * Date: 2017/5/26
 * Time: 15:29
 */
public class DefaultResult {
    private boolean success = false;
    private String message = "";
    private String url = "";

    public String getMessage() {
        return message;
    }

    public String getUrl() {
        return url;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
