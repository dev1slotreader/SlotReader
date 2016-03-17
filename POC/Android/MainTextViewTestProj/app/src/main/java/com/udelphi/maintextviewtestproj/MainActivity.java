package com.udelphi.maintextviewtestproj;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private CustomLetterPicker customPicker;
    private WordPicker picker;
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
    private String[] ruAlphabet = new String[]{"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К",
            "Л", "М", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "ы", "ь", "Ю", "Я"};
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        customPicker = (CustomLetterPicker)findViewById(R.id.custom_picker);
        customPicker.setSource(enAlphabet);
        picker = (WordPicker)findViewById(R.id.word_picker);

        findViewById(R.id.ru_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.en_alphabet_btn).setOnClickListener(this);
        (findViewById(R.id.a_btn)).setOnClickListener(this);
        (findViewById(R.id.o_btn)).setOnClickListener(this);
        (findViewById(R.id.y_btn)).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.en_alphabet_btn:
                customPicker.setSource(enAlphabet);
                break;
            case R.id.ru_alphabet_btn:
                customPicker.setSource(ruAlphabet);
                break;
            case R.id.a_btn:
                picker.moveValue("A");
                break;
            case R.id.o_btn:
                picker.moveValue("O");
                break;
            case R.id.y_btn:
                picker.moveValue("Y");
                break;
        }
    }
}
