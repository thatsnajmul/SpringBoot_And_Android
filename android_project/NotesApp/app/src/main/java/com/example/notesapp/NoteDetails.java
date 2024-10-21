//package com.example.notesapp;
//
//import android.content.Intent;
//import android.os.Bundle;
//import android.view.MenuItem;
//import android.view.View;
//import android.widget.TextView;
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.appcompat.widget.Toolbar;
//import com.google.android.material.floatingactionbutton.FloatingActionButton;
//
//public class NoteDetails extends AppCompatActivity {
//
//    private TextView mTitleOfNoteDetail, mContentOfNoteDetail;
//    private FloatingActionButton mGoToEditNote;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_note_details);
//
//        mTitleOfNoteDetail = findViewById(R.id.titleofnotedetail);
//        mContentOfNoteDetail = findViewById(R.id.contentofnotedetail);
//        mGoToEditNote = findViewById(R.id.gotoeditnote);
//        Toolbar toolbar = findViewById(R.id.toolbarofnotedetail);
//        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//
//        Intent data = getIntent();
//
//        // Set the title and content from the Intent data
//        mTitleOfNoteDetail.setText(data.getStringExtra("title"));
//        mContentOfNoteDetail.setText(data.getStringExtra("content"));
//
//        mGoToEditNote.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent intent = new Intent(NoteDetails.this, EditNoteActivity.class);
//                intent.putExtra("title", data.getStringExtra("title"));
//                intent.putExtra("content", data.getStringExtra("content"));
//                intent.putExtra("noteId", data.getStringExtra("noteId"));
//                startActivity(intent);
//            }
//        });
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId() == android.R.id.home) {
//            onBackPressed(); // Handle back navigation
//            return true;
//
//        }
//        return super.onOptionsItemSelected(item);
//    }
//}


package com.example.notesapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class NoteDetails extends AppCompatActivity {

    private TextView mTitleOfNoteDetail, mContentOfNoteDetail;
    private FloatingActionButton mGoToEditNote;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_details);

        mTitleOfNoteDetail = findViewById(R.id.titleofnotedetail);
        mContentOfNoteDetail = findViewById(R.id.contentofnotedetail);
        mGoToEditNote = findViewById(R.id.gotoeditnote);
        Toolbar toolbar = findViewById(R.id.toolbarofnotedetail);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Intent data = getIntent();

        // Set the title and content from the Intent data
        mTitleOfNoteDetail.setText(data.getStringExtra("title"));
        mContentOfNoteDetail.setText(data.getStringExtra("content"));

        mGoToEditNote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(NoteDetails.this, EditNoteActivity.class);
                intent.putExtra("title", data.getStringExtra("title"));
                intent.putExtra("content", data.getStringExtra("content"));
                intent.putExtra("noteId", data.getStringExtra("noteId"));
                startActivity(intent);
            }
        });
    }

    @Override
    public void onBackPressed() {
        // Here, trigger the save operation or navigate back
        saveNoteOnBackPressed(); // Method to handle saving note
        super.onBackPressed(); // Navigate back after saving
    }

    private void saveNoteOnBackPressed() {
        // This method can call the save functionality that was used in your CreateNote or EditNote activities
        String title = mTitleOfNoteDetail.getText().toString();
        String content = mContentOfNoteDetail.getText().toString();
        Intent data = getIntent();
        String noteId = data.getStringExtra("noteId");

        // Use intent to navigate back after saving
        Intent intent = new Intent(NoteDetails.this, EditNoteActivity.class);
        intent.putExtra("title", title);
        intent.putExtra("content", content);
        intent.putExtra("noteId", noteId);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed(); // Handle back navigation
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}




//package com.example.notesapp;
//
//import android.content.Intent;
//import android.os.Bundle;
//import android.view.MenuItem;
//import android.view.View;
//import android.widget.TextView;
//import androidx.appcompat.widget.Toolbar;
//
//import androidx.activity.EdgeToEdge;
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.graphics.Insets;
//import androidx.core.view.ViewCompat;
//import androidx.core.view.WindowInsetsCompat;
//
//import com.google.android.material.floatingactionbutton.FloatingActionButton;
//
//import java.util.HashMap;
//import java.util.Map;
//
//public class NoteDetails extends AppCompatActivity {
//
//    private TextView mtitleofnotedetail, mcontentofnotedetail;
//    FloatingActionButton mgotoeditnote;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_note_details);
//
//        mtitleofnotedetail=findViewById(R.id.titleofnotedetail);
//        mcontentofnotedetail=findViewById(R.id.contentofnotedetail);
//        mgotoeditnote=findViewById(R.id.gotoeditnote);
//        Toolbar toolbar = findViewById(R.id.toolbarofnotedetail);
//        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//
//        Intent data = getIntent();
//
//        mgotoeditnote.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent intent=new Intent(v.getContext(), EditNoteActivity.class);
//                intent.putExtra("title", data.getStringExtra("title"));
//                intent.putExtra("content", data.getStringExtra("content"));
//                intent.putExtra("noteId", data.getStringExtra("noteId"));
//                v.getContext().startActivity(intent);
//
//            }
//        });
//
//        mcontentofnotedetail.setText(data.getStringExtra("content"));
//        mcontentofnotedetail.setText(data.getStringExtra("title"));
//
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId() == android.R.id.home) {
//            onBackPressed();  // Handle back navigation
//            return true;
//        }
//        return super.onOptionsItemSelected(item);
//    }
//
//}