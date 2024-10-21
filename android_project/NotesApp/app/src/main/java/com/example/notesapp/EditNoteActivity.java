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
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.appcompat.widget.Toolbar;
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
//public class EditNoteActivity extends AppCompatActivity {
//
//    private EditText mEditTitleOfNote, mEditContentOfNote;
//    private FloatingActionButton mSaveEditNote;
//    private FirebaseAuth firebaseAuth;
//    private FirebaseFirestore firebaseFirestore;
//    private FirebaseUser firebaseUser;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_edit_note);
//
//        mEditTitleOfNote = findViewById(R.id.edittitleofnote);
//        mEditContentOfNote = findViewById(R.id.editcontentofnote);
//        mSaveEditNote = findViewById(R.id.saveeditnote);
//
//        Intent data = getIntent();
//        firebaseFirestore = FirebaseFirestore.getInstance();
//        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
//
//        Toolbar toolbar = findViewById(R.id.toolbarofeditnote);
//        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//
//        // Retrieve and set the note title and content from the Intent
//        String noteTitle = data.getStringExtra("title");
//        String noteContent = data.getStringExtra("content");
//        mEditTitleOfNote.setText(noteTitle); // Corrected this line
//        mEditContentOfNote.setText(noteContent); // Corrected this line
//
//        mSaveEditNote.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                String newTitle = mEditTitleOfNote.getText().toString();
//                String newContent = mEditContentOfNote.getText().toString();
//
//                if (newTitle.isEmpty() || newContent.isEmpty()) {
//                    Toast.makeText(getApplicationContext(), "Something is empty", Toast.LENGTH_SHORT).show();
//                    return;
//                } else {
//                    DocumentReference documentReference = firebaseFirestore.collection("notes")
//                            .document(firebaseUser.getUid())
//                            .collection("myNotes")
//                            .document(data.getStringExtra("noteId"));
//                    Map<String, Object> note = new HashMap<>();
//                    note.put("title", newTitle);
//                    note.put("content", newContent);
//                    documentReference.set(note).addOnSuccessListener(new OnSuccessListener<Void>() {
//                        @Override
//                        public void onSuccess(Void unused) {
//                            Toast.makeText(getApplicationContext(), "Note is updated", Toast.LENGTH_SHORT).show();
//                            startActivity(new Intent(EditNoteActivity.this, NotesActivity.class));
//                            finish(); // Optionally call finish to prevent going back to this activity
//                        }
//                    }).addOnFailureListener(new OnFailureListener() {
//                        @Override
//                        public void onFailure(@NonNull Exception e) {
//                            Toast.makeText(getApplicationContext(), "Failed to update", Toast.LENGTH_SHORT).show();
//                        }
//                    });
//                }
//            }
//        });
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId() == android.R.id.home) {
//            onBackPressed(); // Handle back navigation
//            return true;
//        }
//        return super.onOptionsItemSelected(item);
//    }
//}


package com.example.notesapp;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
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

public class EditNoteActivity extends AppCompatActivity {

    private EditText mEditTitleOfNote, mEditContentOfNote;
    private FloatingActionButton mSaveEditNote;
    private FirebaseAuth firebaseAuth;
    private FirebaseFirestore firebaseFirestore;
    private FirebaseUser firebaseUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_note);

        mEditTitleOfNote = findViewById(R.id.edittitleofnote);
        mEditContentOfNote = findViewById(R.id.editcontentofnote);
        mSaveEditNote = findViewById(R.id.saveeditnote);

        Intent data = getIntent();
        firebaseFirestore = FirebaseFirestore.getInstance();
        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        Toolbar toolbar = findViewById(R.id.toolbarofeditnote);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        // Retrieve and set the note title and content from the Intent
        String noteTitle = data.getStringExtra("title");
        String noteContent = data.getStringExtra("content");
        mEditTitleOfNote.setText(noteTitle);
        mEditContentOfNote.setText(noteContent);

        mSaveEditNote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveNote();
            }
        });
    }

    private void saveNote() {
        String newTitle = mEditTitleOfNote.getText().toString();
        String newContent = mEditContentOfNote.getText().toString();
        Intent data = getIntent();

        if (newTitle.isEmpty() || newContent.isEmpty()) {
            Toast.makeText(getApplicationContext(), "Something is empty", Toast.LENGTH_SHORT).show();
            return;
        } else {
            DocumentReference documentReference = firebaseFirestore.collection("notes")
                    .document(firebaseUser.getUid())
                    .collection("myNotes")
                    .document(data.getStringExtra("noteId"));
            Map<String, Object> note = new HashMap<>();
            note.put("title", newTitle);
            note.put("content", newContent);
            documentReference.set(note).addOnSuccessListener(new OnSuccessListener<Void>() {
                @Override
                public void onSuccess(Void unused) {
                    Toast.makeText(getApplicationContext(), "Note is updated", Toast.LENGTH_SHORT).show();
                    startActivity(new Intent(EditNoteActivity.this, NotesActivity.class));
                    finish(); // Close this activity
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    Toast.makeText(getApplicationContext(), "Failed to update", Toast.LENGTH_SHORT).show();
                }
            });
        }
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed(); // Handle back navigation
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @SuppressLint("MissingSuperCall")
    @Override
    public void onBackPressed() {
        // Trigger the save operation when back is pressed
        saveNote();
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
//import org.w3c.dom.Document;
//
//import java.util.HashMap;
//import java.util.Map;
//
//public class EditNoteActivity extends AppCompatActivity {
//
//
//    Intent data;
//    EditText medittitleofnote, meditcontentofnote;
//    FloatingActionButton msaveeditnote;
//    FirebaseAuth firebaseAuth;
//    FirebaseFirestore firebaseFirestore;
//    FirebaseUser firebaseUser;
//
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_edit_note);
//
//        medittitleofnote=findViewById(R.id.edittitleofnote);
//        meditcontentofnote=findViewById(R.id.editcontentofnote);
//        msaveeditnote=findViewById(R.id.saveeditnote);
//
//        data=getIntent();
//        firebaseFirestore=FirebaseFirestore.getInstance();
//        firebaseUser=FirebaseAuth.getInstance().getCurrentUser();
//
//        Toolbar toolbar=findViewById(R.id.toolbarofeditnote);
//        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//
//
//        String notetitle = data.getStringExtra("title");
//        String notecontent = data.getStringExtra("content");
//        meditcontentofnote.setText(notecontent);
//        medittitleofnote.setText(notecontent);
//
//
//        msaveeditnote.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                String newtitle=medittitleofnote.getText().toString();
//                String newcontent=meditcontentofnote.getText().toString();
//
//                if (newtitle.isEmpty()||newcontent.isEmpty())
//                {
//                    Toast.makeText(getApplicationContext(),"Something is empty", Toast.LENGTH_SHORT).show();
//                    return;
//                }
//                else
//                {
//                    DocumentReference documentReference=firebaseFirestore.collection("notes")
//                            .document(firebaseUser.getUid())
//                            .collection("myNotes")
//                            .document(data.getStringExtra("noteId"));
//                    Map<String,Object> note = new HashMap<>();
//                    note.put("title",newtitle);
//                    note.put("content", newcontent);
//                    documentReference.set(note).addOnSuccessListener(new OnSuccessListener<Void>() {
//                        @Override
//                        public void onSuccess(Void unused) {
//                            Toast.makeText(getApplicationContext(),"Note is updated", Toast.LENGTH_SHORT).show();
//                            startActivity(new Intent(EditNoteActivity.this, NotesActivity.class));
//                        }
//                    }).addOnFailureListener(new OnFailureListener() {
//                        @Override
//                        public void onFailure(@NonNull Exception e) {
//                            Toast.makeText(getApplicationContext(),"Failed to updated", Toast.LENGTH_SHORT).show();
//
//                        }
//                    });
//                }
//            }
//        });
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
//}