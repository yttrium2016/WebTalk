package com.yttrium.service.impl;

import com.yttrium.domain.User;
import com.yttrium.mapper.UserMapper;
import com.yttrium.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created with IntelliJ IDEA
 * Created by yzy
 * Date: 2017/5/26
 * Time: 15:35
 */
@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public User findUser(String loginName) {
        return userMapper.selectByLoginName(loginName);
    }

    @Override
    public int addUser(User user) {
        return userMapper.insert(user);
    }

    @Override
    public boolean checkLoginName(String loginName) {
        return userMapper.selectByLoginName(loginName) == null;
    }
}
