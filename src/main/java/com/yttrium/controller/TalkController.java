package com.yttrium.controller;


import com.yttrium.websocket.TalkClientManage;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 控制页面的显示
 *
 * @author 杨振宇
 */
@Controller
@RequestMapping("/talk")
public class TalkController {


    @RequestMapping(value = "/getUsers")
    @ResponseBody
    public List<Map> getUsers() {
        List<Map> list = new ArrayList<>();
        Map<String,String> map = TalkClientManage.getTalkClientManage().getUsers();
        Map<String,String> newMap = null;
        for (Map.Entry<String,String> entry : map.entrySet()) {
            newMap = new HashMap<>();
            newMap.put("id",entry.getKey());
            newMap.put("name",entry.getValue());
            list.add(newMap);
        }
        return list;
    }


}
