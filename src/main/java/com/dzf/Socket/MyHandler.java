package com.dzf.Socket;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;

public class MyHandler extends TextWebSocketHandler implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private static final ArrayList<WebSocketSession> users;
	
    static {
        users = new ArrayList<>();
    }
	
    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        //功能：接受客户端传来的数据 (  websocket.send()  );
        super.handleTextMessage(session, message);
        TextMessage returnMessage = new TextMessage(message.getPayload()+" received at server");
        //将数据传给指定的客户端通过自定义方法sendMessageToUser();
        sendMessageToUser("zhoukaixin",returnMessage);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("connect to the websocket success......");
        // 从session中取在线用户Cd
        users.add(session);
        //String userName = (String) session.getAttributes().get();
        /*if(userName!= null){
            //查询未读消息
            int count = webSocketService.getUnReadNews((String) session.getAttributes().get(Constants.WEBSOCKET_USERNAME));
 
            session.sendMessage(new TextMessage(count + ""));
        }*/
        
        
       /* String userCd = (String) session.getAttributes().get("WS_USER_CD");
        if(userCd != null) {
        	// 得到DB该用户未读消息
        	
        	// 发送给指定cd用户
        	session.sendMessage(new TextMessage("<a href='../rebook/exApplyCenter?remark=1'>这是未读信息</a>"));
        	
        	logger.info("------in------");
        }*/
    }
    
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        if(session.isOpen()){
            session.close();
        }
        System.out.println("websocket connection closed......");
        users.remove(session);
    }
    
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
    	System.out.println("websocket connection closed......");
        users.remove(session);
    }
    
    /**
     * 给所有在线用户发送消息
     *
     * @param message
     */
    public void sendMessageToUsers(TextMessage message) {
        for (WebSocketSession user : users) {
            try {
                if (user.isOpen()) {
                    user.sendMessage(message);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
 
    /**
     * 发消息（无论是否在线）
     *
     * @param userCd
     * @param message
     */
    //都是利用相对应的（user的websocketsession）的sendMessage(message)方法进行通信,与客户端的onmesage function()相对应
    public void sendMessageToUser(String userCd, TextMessage message) {
        for (WebSocketSession user : users) {
            if (userCd.equals(user.getAttributes().get("WS_USER_CD"))) { // 应从session取CD对比
                try {
                    if (user.isOpen()) {
                        user.sendMessage(message);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
        }
    }
}