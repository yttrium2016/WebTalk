package com.yttrium.service;

import com.yttrium.domain.User;

/**
 * Created with IntelliJ IDEA
 * Created by yzy
 * Date: 2017/5/26
 * Time: 15:34
 */
public interface UserService {
    User findUser(String loginName);

    int addUser(User user);

    boolean checkLoginName(String loginName);
}
