package mff.example.application;

import androidx.appcompat.app.AppCompatActivity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class mffActivity extends AppCompatActivity implements View.OnClickListener, View.OnLayoutChangeListener {

    // Used to load the 'native-lib' library on application startup.
    static {
        try {
            System.loadLibrary("mff-app");
        } catch (Exception ex) {
            Log.println(0, "log_tag", ex.getMessage());
        }
    }

    // Configured from FreeBasic side via the Form.ExternalEventAction / Form.ExternalEventExtra
    // properties (see updateExternalEventFilter below) — no need to edit this file.
    private String scannerIntentExtra = "";
    private boolean scannerReceiverRegistered = false;

    private final BroadcastReceiver scannerReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String data = intent.getStringExtra(scannerIntentExtra);
            if (data == null) {
                // fall back to the first string extra found, in case the scanner
                // uses a different extra name than the configured one
                Bundle extras = intent.getExtras();
                if (extras != null) {
                    for (String key : extras.keySet()) {
                        Object value = extras.get(key);
                        if (value instanceof String) {
                            data = (String) value;
                            break;
                        }
                    }
                }
            }
            if (data != null) {
                onExternalEvent(data);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        onCreate(findViewById(R.id.layout));

        // Example of a call to a native method
        //Button btn = findViewById(R.id.button7);
        //btn.setText(stringFromJNI());
    }

    /**
     * Called from the native library (FreeBasic side) whenever the Form's
     * ExternalEventAction / ExternalEventExtra properties are set. (Re)registers
     * the barcode scanner broadcast receiver with the given intent action and
     * extra key. Passing an empty/null action disables the receiver.
     */
    public void updateExternalEventFilter(String action, String extra) {
        if (scannerReceiverRegistered) {
            try {
                unregisterReceiver(scannerReceiver);
            } catch (Exception ex) {
                Log.println(0, "log_tag", ex.getMessage());
            }
            scannerReceiverRegistered = false;
        }
        scannerIntentExtra = extra != null ? extra : "";
        if (action != null && !action.isEmpty()) {
            registerReceiver(scannerReceiver, new IntentFilter(action));
            scannerReceiverRegistered = true;
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        // Some scanner apps/SDKs return data via startActivityForResult/onNewIntent
        // instead of a broadcast. Forward it the same way if present.
        if (intent != null && scannerReceiverRegistered) {
            String data = intent.getStringExtra(scannerIntentExtra);
            if (data != null) {
                onExternalEvent(data);
            }
        }
    }

    @Override
    protected void onDestroy() {
        if (scannerReceiverRegistered) {
            try {
                unregisterReceiver(scannerReceiver);
            } catch (Exception ex) {
                Log.println(0, "log_tag", ex.getMessage());
            }
            scannerReceiverRegistered = false;
        }
        super.onDestroy();
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public native void onCreate(Object layout);

    @Override
    public native void onClick(View view);

    @Override
    public native void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom);

    /**
     * A native method that is implemented by the 'native-lib' native library.
     * Called whenever data from an external source (e.g. a barcode/QR scanner) is
     * received, forwarding it to the Form's OnExternalEvent event.
     */
    public native void onExternalEvent(String data);
}