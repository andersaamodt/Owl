package app.wizardry.owl;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.graphics.Color;
import android.text.InputType;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

public final class MainActivity extends Activity {
    private SharedPreferences prefs;
    private TextView remoteStatus;
    private EditText remoteHost;
    private EditText remoteKey;
    private EditText remotePort;
    private EditText remotePassword;
    private CheckBox remoteHasPassword;
    private CheckBox remoteSavePassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("owl-mobile", MODE_PRIVATE);

        ScrollView scroll = new ScrollView(this);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(28, 28, 28, 28);
        root.setBackgroundColor(Color.rgb(247, 247, 242));
        scroll.addView(root);

        TextView title = new TextView(this);
        title.setText("Inbox");
        title.setTextSize(24);
        title.setTextColor(Color.rgb(24, 33, 35));
        root.addView(title, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        TextView screenTitle = sectionTitle("Screens");
        root.addView(screenTitle);
        addScreenRow(root, "Inbox");
        addScreenRow(root, "Timeline");
        addScreenRow(root, "People");
        addScreenRow(root, "Groups");
        addScreenRow(root, "Settings");
        addScreenRow(root, "Remote Setup");

        EditText composer = new EditText(this);
        composer.setHint("Message");
        composer.setSingleLine(false);
        root.addView(composer, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        Button send = new Button(this);
        send.setText("Send");
        root.addView(send, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        addRemoteSetup(root);
        setContentView(scroll);
    }

    private TextView sectionTitle(String label) {
        TextView view = new TextView(this);
        view.setText(label);
        view.setTextSize(18);
        view.setTextColor(Color.rgb(35, 54, 54));
        view.setPadding(0, 28, 0, 8);
        return view;
    }

    private TextView bodyText(String label) {
        TextView view = new TextView(this);
        view.setText(label);
        view.setTextSize(14);
        view.setTextColor(Color.rgb(78, 86, 83));
        view.setPadding(0, 4, 0, 8);
        return view;
    }

    private void addScreenRow(LinearLayout root, String label) {
        TextView row = bodyText(label);
        row.setTextSize(16);
        root.addView(row, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    private EditText field(String hint, String key) {
        EditText edit = new EditText(this);
        edit.setHint(hint);
        edit.setSingleLine(true);
        edit.setText(prefs.getString(key, ""));
        edit.setPadding(0, 4, 0, 4);
        return edit;
    }

    private void addRemoteSetup(LinearLayout root) {
        root.addView(sectionTitle("Remote Mail Server"));
        root.addView(bodyText("Step through the same Owl remote setup flow: save SSH details, save authentication, deploy, verify, set up TLS, send a test email, then check remote mail."));

        remoteHost = field("user@203.0.113.8", "remote.host");
        remoteKey = field("~/.ssh/id_ed25519", "remote.key");
        remotePort = field("SSH port", "remote.port");
        root.addView(remoteHost, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(remoteKey, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(remotePort, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        Button saveTarget = new Button(this);
        saveTarget.setText("Save Remote Target");
        saveTarget.setOnClickListener(v -> saveRemoteTarget());
        root.addView(saveTarget, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        remoteHasPassword = new CheckBox(this);
        remoteHasPassword.setText("SSH key has password");
        remoteHasPassword.setChecked(prefs.getBoolean("remote.hasPassword", false));
        root.addView(remoteHasPassword);

        remotePassword = field("SSH key password", "remote.password");
        remotePassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        root.addView(remotePassword, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        remoteSavePassword = new CheckBox(this);
        remoteSavePassword.setText("Save password on this device");
        remoteSavePassword.setChecked(prefs.getBoolean("remote.savePassword", false));
        root.addView(remoteSavePassword);

        Button saveAuth = new Button(this);
        saveAuth.setText("Save Authentication");
        saveAuth.setOnClickListener(v -> saveRemoteAuth());
        root.addView(saveAuth, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        addWorkflowButton(root, "Deploy Remote Server", "Deploy starts from the saved SSH target. Use desktop Owl for the actual SSH deploy until the mobile backend bridge is available.");
        addWorkflowButton(root, "Verify Remote Setup", "Verification checks Owl binaries, daemon health, SMTP reachability, DNS, and mail folders on the saved target.");
        addWorkflowButton(root, "Set Up Remote TLS", "Remote TLS setup uses Owl's remote certificate flow after DNS points at the mail server.");
        addWorkflowButton(root, "Send Test Email", "The test email step confirms the public route reaches the remote Owl receiver.");
        addWorkflowButton(root, "Check Remote Mail", "Remote sync pulls server mail folders back into local Owl without deleting remote mail.");

        remoteStatus = bodyText(remoteSummary());
        root.addView(remoteStatus, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    private void addWorkflowButton(LinearLayout root, String title, String detail) {
        Button button = new Button(this);
        button.setText(title);
        button.setOnClickListener(v -> setRemoteStatus(title + ": " + detail));
        root.addView(button, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(bodyText(detail));
    }

    private void saveRemoteTarget() {
        String port = normalizedPort();
        if (!validPort(port)) {
            setRemoteStatus("SSH port must be 1-65535.");
            return;
        }
        prefs.edit()
            .putString("remote.host", remoteHost.getText().toString().trim())
            .putString("remote.key", remoteKey.getText().toString().trim())
            .putString("remote.port", port)
            .apply();
        setRemoteStatus("Remote target saved. " + remoteSummary());
    }

    private void saveRemoteAuth() {
        prefs.edit()
            .putBoolean("remote.hasPassword", remoteHasPassword.isChecked())
            .putBoolean("remote.savePassword", remoteSavePassword.isChecked())
            .putString("remote.password", remoteHasPassword.isChecked() ? remotePassword.getText().toString() : "")
            .apply();
        setRemoteStatus("Remote authentication saved. " + remoteSummary());
    }

    private String normalizedPort() {
        String port = remotePort.getText().toString().trim();
        if (port.startsWith(":")) {
            port = port.substring(1);
        }
        return port;
    }

    private boolean validPort(String port) {
        if (port.length() == 0) {
            return true;
        }
        try {
            int parsed = Integer.parseInt(port);
            return parsed >= 1 && parsed <= 65535;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private String remoteSummary() {
        String host = prefs.getString("remote.host", "");
        String key = prefs.getString("remote.key", "");
        String port = prefs.getString("remote.port", "");
        if (host.length() == 0 || key.length() == 0) {
            return "Set host and SSH key, then deploy.";
        }
        return "Target: " + host + (port.length() == 0 ? "" : " - SSH port: " + port);
    }

    private void setRemoteStatus(String text) {
        if (remoteStatus != null) {
            remoteStatus.setText(text);
        }
    }
}
