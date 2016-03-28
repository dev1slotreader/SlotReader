package com.udelphi.slotreader;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.udelphi.slotreader.Abstractions.BoardView;

public class MainActivity extends AppCompatActivity {
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}; //Remove after parser import

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        BoardView boardView = (BoardView) findViewById(R.id.word_picker);
        boardView.setValues(enAlphabet);
    }
}
