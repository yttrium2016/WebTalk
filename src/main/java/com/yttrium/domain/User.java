package com.yttrium.domain;

public class User {
    private Integer userId;


    private String loginName;

    private String password;

    private String repassword;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }



    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName == null ? null : loginName.trim();
    }

    public String getPassword() {
        return password;
    }

    public String getRepassword() {
        return repassword;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public void setRepassword(String repassword) {
        this.repassword = repassword;
    }

}