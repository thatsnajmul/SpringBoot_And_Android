package com.example.notesapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class CreateNotes extends AppCompatActivity {

    EditText mcreatetitleofnote, mcreatecontentofnote;
    FloatingActionButton msavenote;
    FirebaseAuth firebaseAuth;
    FirebaseUser firebaseUser;
    FirebaseFirestore firebaseFirestore;

    ProgressBar mprogressbarofcreatenote;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_notes);

        // Initialize UI elements
        msavenote = findViewById(R.id.savenote);
        mcreatecontentofnote = findViewById(R.id.createcontentofnote);
        mcreatetitleofnote = findViewById(R.id.createtitleofnote);

        mprogressbarofcreatenote=findViewById(R.id.progressbarofcreatenote);

        // Set up toolbar
        Toolbar toolbar = findViewById(R.id.toolbarofcreatenote);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        // Initialize Firebase components
        firebaseAuth = FirebaseAuth.getInstance();
        firebaseFirestore = FirebaseFirestore.getInstance();
        firebaseUser = firebaseAuth.getCurrentUser();

        // Save note when the FAB is clicked
        msavenote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String title = mcreatetitleofnote.getText().toString();
                String content = mcreatecontentofnote.getText().toString();

                if (title.isEmpty() || content.isEmpty()) {
                    Toast.makeText(getApplicationContext(), "Both fields are required", Toast.LENGTH_SHORT).show();
                } else {

                    mprogressbarofcreatenote.setVisibility(View.VISIBLE);

                    // Create a reference to a new document in the "myNotes" collection
                    DocumentReference documentReference = firebaseFirestore
                            .collection("notes")
                            .document(firebaseUser.getUid())  // User-specific notes collection
                            .collection("myNotes")
                            .document();  // Generates a unique document ID

                    // Prepare note data
                    Map<String, Object> note = new HashMap<>();
                    note.put("title", title);
                    note.put("content", content);

                    // Save the note to Firestore
                    documentReference.set(note).addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void unused) {
                            Toast.makeText(getApplicationContext(), "Note created successfully", Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(CreateNotes.this, NotesActivity.class));
                        }
                    }).addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            //mprogressbarofcreatenote.setVisibility(View.INVISIBLE);
                            Toast.makeText(getApplicationContext(), "Failed to create note", Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();  // Handle back navigation
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
//import android.widget.EditText;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.widget.Toolbar;
//
//import androidx.activity.EdgeToEdge;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.core.graphics.Insets;
//import androidx.core.view.ViewCompat;
//import androidx.core.view.WindowInsetsCompat;
//
//import com.google.android.gms.tasks.OnFailureListener;
//import com.google.android.gms.tasks.OnSuccessListener;
//import com.google.android.material.floatingactionbutton.FloatingActionButton;
//import com.google.firebase.auth.FirebaseAuth;
//import com.google.firebase.auth.FirebaseUser;
//import com.google.firebase.firestore.DocumentReference;
//import com.google.firebase.firestore.FirebaseFirestore;
//
//import java.util.HashMap;
//import java.util.Map;
//
//public class CreateNotes extends AppCompatActivity {
//
//    EditText mcreatetitleofnote, mcreatecontentofnote;
//    FloatingActionButton msavenote;
//    FirebaseAuth firebaseAuth;
//    FirebaseUser firebaseUser;
//    FirebaseFirestore firebaseFirestore;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_create_notes);
//
//        msavenote=findViewById(R.id.savenote);
//        mcreatecontentofnote=findViewById(R.id.createcontentofnote);
//        mcreatetitleofnote=findViewById(R.id.createtitleofnote);
//
//        Toolbar toolbar = findViewById(R.id.toolbarofcreatenote);
//        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//
//        firebaseAuth=FirebaseAuth.getInstance();
//        firebaseFirestore=FirebaseFirestore.getInstance();
//        firebaseUser=FirebaseAuth.getInstance().getCurrentUser();
//
//        msavenote.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                String title=mcreatetitleofnote.getText().toString();
//                String content=mcreatecontentofnote.getText().toString();
//                if (title.isEmpty()||content.isEmpty())
//                {
//                    Toast.makeText(getApplicationContext(),"Both field are required", Toast.LENGTH_SHORT).show();
//                }
//                else
//                {
//
//                    DocumentReference documentReference = firebaseFirestore
//                            .collection("notes")
//                            .document(firebaseUser.getUid())
//                            .collection("myNotes")
//                            .document("specificNoteId");
//                    Map<String, Object> note = new HashMap<>();
//                    note.put("title", title);
//                    note.put("content", content);
//
//                    documentReference.set(note).addOnSuccessListener(new OnSuccessListener<Void>() {
//                        @Override
//                        public void onSuccess(Void unused) {
//                            Toast.makeText(getApplicationContext(),"Note Created successfully", Toast.LENGTH_SHORT).show();
//                            startActivity(new Intent(CreateNotes.this, NotesActivity.class));
//                        }
//                    }).addOnFailureListener(new OnFailureListener() {
//                        @Override
//                        public void onFailure(@NonNull Exception e) {
//                            Toast.makeText(getApplicationContext(),"Failed to create note", Toast.LENGTH_SHORT).show();
//                            //startActivity(new Intent(CreateNotes.this, NotesActivity.class));
//                        }
//                    });
//
//                }
//            }
//        });
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId()==android.R.id.home){
//            getOnBackPressedDispatcher();
//        }
//        return super.onOptionsItemSelected(item);
//    }
//}