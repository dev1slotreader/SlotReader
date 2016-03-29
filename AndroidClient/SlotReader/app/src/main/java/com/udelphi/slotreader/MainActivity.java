package com.udelphi.slotreader;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Gallery;
import android.widget.TextView;

import com.udelphi.slotreader.Abstractions.BoardView;
import com.udelphi.slotreader.Adapters.GalleryAdapter;

public class MainActivity extends AppCompatActivity {
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}; //Remove after parser import

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final BoardView boardView = (BoardView) findViewById(R.id.word_picker);
        assert boardView != null;
        boardView.setValues(enAlphabet);

        Gallery gallery = (Gallery) findViewById(R.id.size_switch);
        assert gallery != null;
        gallery.setAdapter(new GalleryAdapter((getApplicationContext())));
        gallery.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String value = ((TextView)view).getText().toString();
                try {
                    boardView.setLettersCount(Integer.valueOf(value));
                }catch (NumberFormatException ignored){
                    boardView.setLettersCount(Integer.valueOf(value.substring(0, value.length() - 1)));
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }
}
