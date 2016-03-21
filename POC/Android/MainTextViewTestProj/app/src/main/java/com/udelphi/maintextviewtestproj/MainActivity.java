package com.udelphi.maintextviewtestproj;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private SlotView picker;
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
    private String[] ruAlphabet = new String[]{"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К",
            "Л", "М", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "ы", "ь", "Ю", "Я"};
    private CurrentSource currentSource;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        picker = (SlotView)findViewById(R.id.word_picker);
        picker.setSource(enAlphabet);
        currentSource = CurrentSource.EN;

        findViewById(R.id.ru_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.en_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.remove_picker_btn).setOnClickListener(this);
        findViewById(R.id.add_picker_btn).setOnClickListener(this);
        findViewById(R.id.a_btn).setOnClickListener(this);
        findViewById(R.id.o_btn).setOnClickListener(this);
        findViewById(R.id.y_btn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.en_alphabet_btn:
                picker.setSource(enAlphabet);
                currentSource = CurrentSource.EN;
                break;
            case R.id.ru_alphabet_btn:
                picker.setSource(ruAlphabet);
                currentSource = CurrentSource.RU;
                break;
            case R.id.a_btn:
                if(currentSource == CurrentSource.EN)
                    picker.moveValue("A"); //Roman alphabet
                else
                    picker.moveValue("А"); //Cyrillic
                break;
            case R.id.o_btn:
                if(currentSource == CurrentSource.EN)
                    picker.moveValue("O");
                else
                    picker.moveValue("О");
                break;
            case R.id.y_btn:
                if(currentSource == CurrentSource.EN)
                    picker.moveValue("Y");
                else
                    picker.moveValue("У");
                break;
            case R.id.remove_picker_btn:
                picker.removePicker();
                break;
            case R.id.add_picker_btn:
                picker.addPicker();
                break;
        }
    }

    private enum CurrentSource { EN, RU }
}
