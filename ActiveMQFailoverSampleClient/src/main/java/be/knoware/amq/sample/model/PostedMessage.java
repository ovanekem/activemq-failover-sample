package be.knoware.amq.sample.model;

/**
 * Created by ovanekem on 08/03/16.
 */
public class PostedMessage {
    String text;
    String number;

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }
}
