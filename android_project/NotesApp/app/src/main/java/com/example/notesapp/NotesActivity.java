package com.example.notesapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupMenu;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class NotesActivity extends AppCompatActivity {

    private FloatingActionButton mcreatenotesfab;
    private FirebaseAuth firebaseAuth;
    private RecyclerView mrecyclerview;
    private StaggeredGridLayoutManager staggeredGridLayoutManager;
    private FirebaseUser firebaseUser;
    private FirebaseFirestore firebaseFirestore;
    private FirestoreRecyclerAdapter<FirebaseModel, NoteViewHolder> noteAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notes);

        mcreatenotesfab = findViewById(R.id.createnotefab);
        firebaseAuth = FirebaseAuth.getInstance();
        firebaseUser = firebaseAuth.getCurrentUser();
        firebaseFirestore = FirebaseFirestore.getInstance();

        getSupportActionBar().setTitle("All Notes");

        mcreatenotesfab.setOnClickListener(v -> {
            startActivity(new Intent(NotesActivity.this, CreateNotes.class));
        });

        Query query = firebaseFirestore.collection("notes")
                .document(firebaseUser.getUid())
                .collection("myNotes")
                .orderBy("title", Query.Direction.ASCENDING);

        FirestoreRecyclerOptions<FirebaseModel> allusernotes = new FirestoreRecyclerOptions.Builder<FirebaseModel>()
                .setQuery(query, FirebaseModel.class)
                .build();

        noteAdapter = new FirestoreRecyclerAdapter<FirebaseModel, NoteViewHolder>(allusernotes) {
            @Override
            protected void onBindViewHolder(@NonNull NoteViewHolder noteViewHolder, int i, @NonNull FirebaseModel model) {
                ImageView popupbutton = noteViewHolder.itemView.findViewById(R.id.menupopbutton);

                int colourcode = getRandomColor();
                noteViewHolder.mnote.setBackgroundColor(noteViewHolder.itemView.getResources().getColor(colourcode, null));

                // Use the model's getters
                noteViewHolder.notetitle.setText(model.getTitle());
                noteViewHolder.notecontent.setText(model.getContent());

                String docId = noteAdapter.getSnapshots().getSnapshot(i).getId();

                noteViewHolder.itemView.setOnClickListener(v -> {
                    Intent intent = new Intent(v.getContext(), EditNoteActivity.class);
                    intent.putExtra("title", model.getTitle());
                    intent.putExtra("content", model.getContent());
                    intent.putExtra("noteId", docId);
                    v.getContext().startActivity(intent);
                });

                popupbutton.setOnClickListener(v -> {
                    PopupMenu popupMenu = new PopupMenu(v.getContext(), v);
                    popupMenu.setGravity(Gravity.END);
                    popupMenu.getMenu().add("Edit").setOnMenuItemClickListener(item -> {
                        Intent intent = new Intent(v.getContext(), EditNoteActivity.class);
                        intent.putExtra("title", model.getTitle());
                        intent.putExtra("content", model.getContent());
                        intent.putExtra("noteId", docId);
                        v.getContext().startActivity(intent);
                        return false;
                    });

                    popupMenu.getMenu().add("Delete").setOnMenuItemClickListener(item -> {
                        DocumentReference documentReference = firebaseFirestore.collection("notes")
                                .document(firebaseUser.getUid())
                                .collection("myNotes")
                                .document(docId);
                        documentReference.delete().addOnSuccessListener(unused ->
                                        Toast.makeText(v.getContext(), "This note is deleted", Toast.LENGTH_SHORT).show())
                                .addOnFailureListener(e ->
                                        Toast.makeText(v.getContext(), "Failed to delete", Toast.LENGTH_SHORT).show());
                        return false;
                    });

                    popupMenu.show();
                });
            }

            @NonNull
            @Override
            public NoteViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
                View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.notes_layout, parent, false);
                return new NoteViewHolder(view);
            }
        };

        mrecyclerview = findViewById(R.id.recyclerview);
        mrecyclerview.setHasFixedSize(true);
        staggeredGridLayoutManager = new StaggeredGridLayoutManager(2, StaggeredGridLayoutManager.VERTICAL);
        mrecyclerview.setLayoutManager(staggeredGridLayoutManager);
        mrecyclerview.setAdapter(noteAdapter);
    }

    public class NoteViewHolder extends RecyclerView.ViewHolder {
        private TextView notetitle;
        private TextView notecontent;
        LinearLayout mnote;

        public NoteViewHolder(@NonNull View itemView) {
            super(itemView);
            notetitle = itemView.findViewById(R.id.notetitle);
            notecontent = itemView.findViewById(R.id.notecontent);
            mnote = itemView.findViewById(R.id.note);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu with the logout option
        getMenuInflater().inflate(R.menu.menu, menu);

        // Get current user email from Firebase
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
        if (firebaseUser != null) {
            String userEmail = firebaseUser.getEmail();

            // Dynamically add the user's email to the menu above the "Logout" option
            if (userEmail != null) {
                menu.add(Menu.NONE, Menu.NONE, 0, "Logged in as: " + userEmail)
                        .setShowAsAction(MenuItem.SHOW_AS_ACTION_NEVER); // Show email in the overflow menu
            }
        }

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == R.id.logout) {
            // Handle logout action
            FirebaseAuth.getInstance().signOut();
            finish();
            startActivity(new Intent(NotesActivity.this, MainActivity.class));
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        getMenuInflater().inflate(R.menu.menu, menu);
//        return true;
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId() == R.id.logout) {
//            firebaseAuth.signOut();
//            finish();
//            startActivity(new Intent(NotesActivity.this, MainActivity.class));
//        }
//        return super.onOptionsItemSelected(item);
//    }

    @Override
    protected void onStart() {
        super.onStart();
        noteAdapter.startListening();
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (noteAdapter != null) {
            noteAdapter.startListening();
        }
    }

    private int getRandomColor() {
        List<Integer> colorcode = new ArrayList<>();
        colorcode.add(R.color.gray);
        colorcode.add(R.color.green);
        colorcode.add(R.color.pink);
        colorcode.add(R.color.lightgreen);
        colorcode.add(R.color.skyblue);
        colorcode.add(R.color.color1);
        colorcode.add(R.color.color2);
        colorcode.add(R.color.color3);
        colorcode.add(R.color.color4);
        colorcode.add(R.color.color5);

        Random random = new Random();
        int number = random.nextInt(colorcode.size());
        return colorcode.get(number);
    }
}


//package com.example.notesapp;
//import android.content.Intent;
//import android.os.Bundle;
//import android.view.LayoutInflater;
//import android.view.Menu;
//import android.view.MenuItem;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.LinearLayout;
//import android.widget.TextView;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.recyclerview.widget.RecyclerView;
//import androidx.recyclerview.widget.StaggeredGridLayoutManager;
//
//
//import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
//import com.firebase.ui.firestore.FirestoreRecyclerOptions;
//import com.google.android.material.floatingactionbutton.FloatingActionButton;
//import com.google.firebase.auth.FirebaseAuth;
//import com.google.firebase.auth.FirebaseUser;
//import com.google.firebase.firestore.FirebaseFirestore;
//import com.google.firebase.firestore.Query;
//
//public class NotesActivity extends AppCompatActivity {
//
//
//
//    FloatingActionButton mcreatenotesfab;
//    private FirebaseAuth firebaseAuth;
//
//    RecyclerView mrecyclerview;
//    StaggeredGridLayoutManager staggeredGridLayoutManager;
//    FirebaseUser firebaseUser;
//    FirebaseFirestore firebaseFirestore;
//    FirestoreRecyclerAdapter<FirebaseModel, NoteViewHolder> noteAdapter;
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_notes);
//
//        mcreatenotesfab=findViewById(R.id.createnotefab);
//        firebaseAuth=FirebaseAuth.getInstance();
//
//        firebaseUser=FirebaseAuth.getInstance().getCurrentUser();
//        firebaseFirestore=FirebaseFirestore.getInstance();
//
//        getSupportActionBar().setTitle("All Notes");
//
//        mcreatenotesfab.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                startActivity(new Intent(NotesActivity.this, CreateNotes.class));
//            }
//        });
//
//        Query query = firebaseFirestore.collection("notes")
//                .document(firebaseUser.getUid())
//                .collection("myNotes")
//                .orderBy("title", Query.Direction.ASCENDING);
//
//        FirestoreRecyclerOptions<FirebaseModel> allusernotes= new FirestoreRecyclerOptions.Builder<FirebaseModel>().setQuery(query,FirebaseModel.class).build();
//
//        noteAdapter = new FirestoreRecyclerAdapter<FirebaseModel, NoteViewHolder>(allusernotes) {
//            @Override
//            protected void onBindViewHolder(@NonNull NoteViewHolder noteViewholder, int position, @NonNull FirebaseModel model) {
//                noteViewholder.notetitle.setText(FirebaseModel.getTitle());
//                noteViewholder.notecontent.setText(FirebaseModel.getContent());
//            }
//
//            @NonNull
//            @Override
//            public NoteViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
//                View view= LayoutInflater.from(parent.getContext()).inflate(R.layout.notes_layout,parent,false);
//                return  new NoteViewHolder(view);
//            }
//        };
//
//        mrecyclerview=findViewById(R.id.recyclerview);
//        mrecyclerview.setHasFixedSize(true);
//        staggeredGridLayoutManager=new StaggeredGridLayoutManager(2, StaggeredGridLayoutManager.VERTICAL);
//        mrecyclerview.setLayoutManager(staggeredGridLayoutManager);
//        mrecyclerview.setAdapter(noteAdapter);
//
//    }
//
//    public class NoteViewHolder extends RecyclerView.ViewHolder
//    {
//        private TextView notetitle;
//        private TextView notecontent;
//        LinearLayout mnote;
//        public NoteViewHolder(@NonNull View itemView) {
//            super(itemView);
//
//            notetitle=itemView.findViewById(R.id.notetitle);
//            notecontent=itemView.findViewById(R.id.notecontent);
//            mnote=itemView.findViewById(R.id.note);
//        }
//    }
//
//
//
//
//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//
//
//        getMenuInflater().inflate(R.menu.menu,menu);
//        return true;
//    }
//
//
//    @Override
//    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
//        if (item.getItemId() == R.id.logout) {
//            firebaseAuth.signOut();
//            finish();
//            startActivity(new Intent(NotesActivity.this, MainActivity.class));
//        }
//        return super.onOptionsItemSelected(item);
//    }
//
//    @Override
//    protected void onStart() {
//        super.onStart();
//        noteAdapter.startListening();
//    }
//    @Override
//    protected void onStop() {
//        super.onStop();
//        if (noteAdapter!=null)
//        {
//            noteAdapter.stopListening();
//        }
//    }
//
//}