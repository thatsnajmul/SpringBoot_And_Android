package com.example.notesapp;

public class FirebaseModel {

    private String title;  // Instance fields for Firebase serialization
    private String content;

    // Empty constructor required for Firebase serialization
    public FirebaseModel() { }

    public FirebaseModel(String title, String content) {
        this.title = title;
        this.content = content;
    }

    // Getter and setter for title
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    // Getter and setter for content
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
