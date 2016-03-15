package com.udelphi.maintextviewtestproj;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private CustomLetterPicker picker;
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
    private String[] ruAlphabet = new String[]{"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К",
            "Л", "М", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "ы", "ь", "Ю", "Я"};
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        picker = (CustomLetterPicker)findViewById(R.id.custom_picker);
        picker.setSource(enAlphabet);

        findViewById(R.id.ru_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.en_alphabet_btn).setOnClickListener(this);
        (findViewById(R.id.a_btn)).setOnClickListener(this);
        (findViewById(R.id.o_btn)).setOnClickListener(this);
        (findViewById(R.id.z_btn)).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.en_alphabet_btn:
                picker.setSource(enAlphabet);
                break;
            case R.id.ru_alphabet_btn:
                picker.setSource(ruAlphabet);
                break;
        }
    }
}
