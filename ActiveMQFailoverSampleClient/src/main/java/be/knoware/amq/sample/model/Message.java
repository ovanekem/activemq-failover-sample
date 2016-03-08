package be.knoware.amq.sample.model;

/**
 * Created by ovanekem on 07/03/16.
 */
public class Message {
    private String text;
    private String id;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

}
