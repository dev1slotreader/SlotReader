package com.fivesysdev.slotreader;

import android.app.Application;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.LinearLayout;

public class MainActivity extends AppCompatActivity {
    private final int mTextPickerFragmentsCount = 5;

    private Application m_App;
    private Context m_Context;
    private LinearLayout mBoardLayout;

    // Fragments
    FragmentNumberPicker mFragmentNumberPicker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        setContentView(R.layout.activity_main);

        m_Context = this;
        m_App = (Application) this.getApplicationContext();
        mBoardLayout = (LinearLayout) findViewById(R.id.boardLayout);
        initFragments();
    }

    private void initFragments() {
        // Fragments
        for(int i = 0; i < mTextPickerFragmentsCount; i++) {
            mFragmentNumberPicker = new FragmentNumberPicker();

            FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
            fragmentTransaction.add(R.id.boardLayout, mFragmentNumberPicker);
            fragmentTransaction.commit();
        }
    }

}
