package com.yttrium.websocket;

/**
 * Created with IntelliJ IDEA
 * Created by yzy
 * Date: 2017/5/25
 * Time: 14:21
 */

import com.yttrium.domain.User;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;

@ServerEndpoint(value = "/talkServer",configurator=HttpSessionConfigurator.class)
public class TalkServer {

    private String SessionId;

    public String getSessionId() {
        return SessionId;
    }

    private Session mSession;

    private String name;

    public String getName() {
        return name;
    }

    /**
     * 连接建立成功调用的方法
     * @param session  可选的参数。session为与某个客户端的连接会话，需要通过它来给客户端发送数据
     */
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) throws IOException {
        mSession = session;
        SessionId = session.getId();

        HttpSession httpSession= (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
        User user = (User) httpSession.getAttribute("loginUser");
        if (user != null) {
            name = user.getLoginName();
        }else {
            name = "不知道什么鬼";
        }
        TalkClientManage.getTalkClientManage().add(this);
        int count = TalkClientManage.getTalkClientManage().getOnlineCount();
        TalkClientManage.getTalkClientManage().talkToAll(this,"新有"+name+"新加入聊天室");
        TalkClientManage.getTalkClientManage().talkToAll(null,"getUsers");
        TalkClientManage.getTalkClientManage().talkToAll(null,"已有"+count+"人在聊天室");
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(Session session){
//        System.out.println(name+"close");
        TalkClientManage.getTalkClientManage().talkToAll(this,"现有"+name+"退出聊天室");
        TalkClientManage.getTalkClientManage().talkToAll(this,"getUsers");
        TalkClientManage.getTalkClientManage().remove(this);
    }

    /**
     * 接收客户端的message,判断是否有接收人而选择进行广播还是指定发送
     * @param out 客户端发送过来的消息
     */
    @OnMessage
    public void onMessage(Session session, String out) {
        String[] strings = out.split("-");
        if ("all".equals(strings[0])) {
            TalkClientManage.getTalkClientManage().talkToAll(this, name+":"+strings[1]);
        }else {
            TalkClientManage.getTalkClientManage().talkToOne(strings[0],name+":"+strings[1]);
        }
    }

    /**
     * 发生错误时调用
     * @param error
     */
    @OnError
    public void onError(Throwable error){
        error.printStackTrace();
//        System.out.println(name+"error");
    }


    public void sendMessage(String msg) throws IOException {
//        System.out.println("向"+name+"发送了:"+msg+"信息");
        if (mSession != null) {
            mSession.getBasicRemote().sendText(msg);
        }
    }

}
