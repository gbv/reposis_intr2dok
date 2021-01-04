package de.vzg.intr2dok.doi;

public class TokenResponse {
    public String token;
    public String user_email;
    public String user_nicename;
    public String user_display_name;

    @Override
    public String toString() {
        return "TokenResponse{" +
                "token='***'" +
                ", user_email='" + user_email + '\'' +
                ", user_nicename='" + user_nicename + '\'' +
                ", user_display_name='" + user_display_name + '\'' +
                '}';
    }
}
