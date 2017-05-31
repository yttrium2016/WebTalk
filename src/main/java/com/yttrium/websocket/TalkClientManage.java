package com.yttrium.websocket;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * Created with IntelliJ IDEA
 * Created by yzy
 * Date: 2017/5/25
 * Time: 14:22
 */
public class TalkClientManage {

    private int onlineCount = 0;
    private static final TalkClientManage talkClientManage = new TalkClientManage();
    private Vector<TalkServer> talkServerList = new Vector<>();
    private ConcurrentMap<String,Object> talkMap =  new ConcurrentHashMap<>();
    private Map<String,String> users = new HashMap<>();
    private TalkClientManage() {
    }


    public static TalkClientManage getTalkClientManage() {
        return talkClientManage;
    }

    public void add(TalkServer talkServer) {

        onlineCount ++;
        talkServerList.add(talkServer);
        talkMap.put(talkServer.getSessionId(),talkServer);
        users.put(talkServer.getSessionId(),talkServer.getName());
    }

    public void remove(TalkServer talkServer) {
        onlineCount --;
        talkServerList.remove(talkServer);
        talkMap.remove(talkServer.getSessionId());
        users.remove(talkServer.getSessionId());
    }

    public void talkToAll(TalkServer my, String out) {
        TalkServer s = null;
        for (Map.Entry<String,Object> entry : talkMap.entrySet()) {
            if (my !=null){
                if (!entry.getKey().equals(my.getSessionId())){
                    s = (TalkServer) entry.getValue();
                    try {
                        s.sendMessage(out);
                    } catch (IOException e) {
                        e.printStackTrace();
                        System.out.println("talkToAll发送出错");
                    }
                }
            }else {
                s = (TalkServer) entry.getValue();
                try {
                    s.sendMessage(out);
                } catch (IOException e) {
                    e.printStackTrace();
                    System.out.println("talkToAll发送出错");
                }
            }
        }
    }

    public void talkToAll2(TalkServer my, String out) {
        TalkServer s = null;
        for (TalkServer aTalkServerList : talkServerList) {
            s = (TalkServer) aTalkServerList;
            if (my != null) {
                if (!my.equals(s)) {
                    try {
                        if (s != null) {
                            aTalkServerList.sendMessage(out);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }else {
                try {
                    if (s != null) {
                        aTalkServerList.sendMessage(out);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public void talkToOne(String id, String out) {
        TalkServer talkServer = (TalkServer) talkMap.get(id);
        try {
            if (talkServer != null) {
                talkServer.sendMessage(out);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }



    public int getOnlineCount() {
        return onlineCount;
    }

    public Map<String, String> getUsers() {
        return users;
    }
}
