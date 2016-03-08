package be.knoware.amq.sample.controllers;

import be.knoware.amq.sample.model.Message;
import be.knoware.amq.sample.model.PostedMessage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.annotation.Resource;
import javax.jms.*;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by ovanekem on 07/03/16.
 */
@Path("/")
public class MessageController {

    @GET
    @Path("/list")
    @Produces({ "application/json" })
    public String retrieveMessages() {
        Connection connection = null;
        Session session = null;
        List<Message> messages = new ArrayList<Message>();
        ConnectionFactory factory = null;
        Queue queue = null;
        InitialContext ctx = null;


        try {
            ctx = new InitialContext();
            factory = (ConnectionFactory)ctx.lookup("java:/ConnectionFactory");
            connection = factory.createConnection();
            session = connection.createSession(true, Session.SESSION_TRANSACTED);
            queue = (Queue)ctx.lookup("java:jboss/activemq/queue/SampleQueue");
            MessageConsumer consumer = session.createConsumer(queue);
            connection.start();
            while (true) {
                javax.jms.Message msg = consumer.receive(500);
                if (msg == null) {
                    break;
                }
                if (msg instanceof TextMessage) {
                    Message message = new Message();
                    message.setText(((TextMessage) msg).getText());
                    message.setId(msg.getJMSMessageID());
                    messages.add(message);
                }
                session.commit();
            }
        } catch (JMSException e) {
            e.printStackTrace();
        } catch (NamingException e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                try {
                    session.close();
                } catch (JMSException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.stop();
                    connection.close();
                } catch (JMSException e) {
                    e.printStackTrace();
                }
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String returnedValue = null;
        try {
            returnedValue = mapper.writeValueAsString(messages);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        return returnedValue;

    }


    @POST
    @Path("/enqueue")
    @Consumes({ "application/json" })
    @Produces({ "application/json" })
    public String postMessages(PostedMessage postedMessage) {
        Connection connection = null;
        Session session = null;
        List<Message> messages = new ArrayList<Message>();
        ConnectionFactory factory = null;
        Queue queue = null;
        InitialContext ctx = null;


        try {
            ctx = new InitialContext();
            factory = (ConnectionFactory)ctx.lookup("java:/ConnectionFactory");
            connection = factory.createConnection();
            session = connection.createSession(true, Session.SESSION_TRANSACTED);
            queue = (Queue)ctx.lookup("java:jboss/activemq/queue/SampleQueue");
            MessageProducer producer = session.createProducer(queue);
            connection.start();
            int maxValue = Integer.parseInt(postedMessage.getNumber());
            for (int i = 0; i < maxValue; i++) {
                javax.jms.Message jmsMessage = session.createTextMessage(postedMessage.getText());
                producer.send(jmsMessage);
            }
            session.commit();

        } catch (JMSException e) {
            e.printStackTrace();
        } catch (NamingException e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                try {
                    session.close();
                } catch (JMSException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.stop();
                    connection.close();
                } catch (JMSException e) {
                    e.printStackTrace();
                }
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String returnedValue = null;
        try {
            returnedValue = mapper.writeValueAsString("Finished importing messages");
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        return returnedValue;

    }
}
