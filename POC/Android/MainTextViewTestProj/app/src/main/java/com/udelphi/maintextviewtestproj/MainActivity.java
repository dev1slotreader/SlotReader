package com.udelphi.maintextviewtestproj;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity implements View.OnClickListener,
        SlotView.OnMovingStartedListener, SlotView.OnMovingEndedListener{

    private SlotView slotView;
    private TextView movingIndicator;
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
    private String[] ruAlphabet = new String[]{"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К",
            "Л", "М", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "ы", "ь", "Ю", "Я"};
    private CurrentSource currentSource;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        slotView = (SlotView)findViewById(R.id.word_picker);
        slotView.setOnMovingStartedListener(this);
        slotView.setOnMovingEndedListener(this);
        slotView.setValues(enAlphabet);
        currentSource = CurrentSource.EN;

        movingIndicator = (TextView)findViewById(R.id.moving_indicator);

        findViewById(R.id.ru_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.en_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.decrement_size).setOnClickListener(this);
        findViewById(R.id.increment_size).setOnClickListener(this);
        findViewById(R.id.size_1).setOnClickListener(this);
        findViewById(R.id.size_3).setOnClickListener(this);
        findViewById(R.id.size_4).setOnClickListener(this);
        findViewById(R.id.size_5).setOnClickListener(this);
        findViewById(R.id.a_btn).setOnClickListener(this);
        findViewById(R.id.o_btn).setOnClickListener(this);
        findViewById(R.id.y_btn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.en_alphabet_btn:
                slotView.setValues(enAlphabet);
                currentSource = CurrentSource.EN;
                break;
            case R.id.ru_alphabet_btn:
                slotView.setValues(ruAlphabet);
                currentSource = CurrentSource.RU;
                break;
            case R.id.decrement_size:
                slotView.removeColumn();
                break;
            case R.id.increment_size:
                slotView.addColumn();
                break;
            case R.id.a_btn:
                if(currentSource == CurrentSource.EN)
                    slotView.moveToValue("A"); //Roman alphabet
                else
                    slotView.moveToValue("А"); //Cyrillic
                break;
            case R.id.o_btn:
                if(currentSource == CurrentSource.EN)
                    slotView.moveToValue("O"); //Roman alphabet
                else
                    slotView.moveToValue("О"); //Cyrillic
                break;
            case R.id.y_btn:
                if(currentSource == CurrentSource.EN)
                    slotView.moveToValue("Y"); //Roman alphabet
                else
                    slotView.moveToValue("У"); //Cyrillic
                break;
            case R.id.size_1:
                slotView.setColumnsCount(1);
                break;
            case R.id.size_3:
                slotView.setColumnsCount(3);
                break;
            case R.id.size_4:
                slotView.setColumnsCount(4);
                break;
            case R.id.size_5:
                slotView.setColumnsCount(5);
                break;
        }
    }

    @Override
    public void onMovingEnded() {
        movingIndicator.setVisibility(View.GONE);
    }

    @Override
    public void onMovingStarted() {
        movingIndicator.setVisibility(View.VISIBLE);
    }

    private enum CurrentSource { EN, RU }
}
