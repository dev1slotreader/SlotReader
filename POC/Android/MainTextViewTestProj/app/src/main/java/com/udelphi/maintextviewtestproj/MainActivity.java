package com.udelphi.maintextviewtestproj;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    WordPicker picker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        picker = (WordPicker)findViewById(R.id.word_picker);

                (findViewById(R.id.a_btn)).setOnClickListener(this);
        (findViewById(R.id.o_btn)).setOnClickListener(this);
        (findViewById(R.id.z_btn)).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.a_btn:
                picker.moveValue("A");
                break;
            case R.id.o_btn:
                picker.moveValue("O");
                break;
            case R.id.z_btn:
                picker.moveValue("Z");
                break;
        }
    }
}
