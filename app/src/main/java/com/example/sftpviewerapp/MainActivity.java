package com.example.sftpviewerapp;

import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    private EditText usernameInput, passwordInput, hostInput;
    private Button connectButton;
    private ListView listView;
    private SFTPManager sftpManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        usernameInput = findViewById(R.id.username);
        passwordInput = findViewById(R.id.password);
        hostInput = findViewById(R.id.host);
        connectButton = findViewById(R.id.connectBtn);
        listView = findViewById(R.id.listView);
        sftpManager = new SFTPManager();

        connectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String username = usernameInput.getText().toString();
                String password = passwordInput.getText().toString();
                String host = hostInput.getText().toString();

                if (!username.isEmpty() && !password.isEmpty() && !host.isEmpty()) {
                    new FetchFilesTask(username, password, host).execute();
                } else {
                    Toast.makeText(MainActivity.this, "Please enter all credentials.", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private class FetchFilesTask extends AsyncTask<Void, Void, List<String>> {
        private final String username, password, host;

        public FetchFilesTask(String username, String password, String host) {
            this.username = username;
            this.password = password;
            this.host = host;
        }

        @Override
        protected List<String> doInBackground(Void... voids) {
            try {
                sftpManager.connect(username, password, host, 22);
                return sftpManager.listFiles("/remote/path");
            } catch (Exception e) {
                Log.e("SFTP", "Error fetching files", e);
                return null;
            }
        }

        @Override
        protected void onPostExecute(List<String> result) {
            if (result != null) {
                ArrayAdapter<String> adapter = new ArrayAdapter<>(MainActivity.this, android.R.layout.simple_list_item_1, result);
                listView.setAdapter(adapter);
            } else {
                Toast.makeText(MainActivity.this, "Connection or retrieval failed.", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        sftpManager.disconnect();
    }
}
