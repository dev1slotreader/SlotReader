package com.udelphi.maintextviewtestproj;
import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity implements View.OnClickListener,
        SlotView.OnMovingStartedListener, SlotView.OnMovingEndedListener{

    private SlotView slotView;
    private TextView movingIndicator;
    private EditText editText;
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
    private String[] ruAlphabet = new String[]{"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К",
            "Л", "М", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "ы", "ь", "Ю", "Я"};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        slotView = (SlotView)findViewById(R.id.word_picker);
        slotView.setOnMovingStartedListener(this);
        slotView.setOnMovingEndedListener(this);
        slotView.setValues(enAlphabet);

        movingIndicator = (TextView)findViewById(R.id.moving_indicator);
        editText = (EditText)findViewById(R.id.input);
        editText.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
                    InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
                    try {
                        slotView.showWord(editText.getText().toString().toUpperCase());
                    } catch (SlotView.InvalidSymbolException e) {
                        Toast.makeText(getApplicationContext(), "Include invalid symbol: " +
                                        e.getInvalidSymbol() + ".", Toast.LENGTH_SHORT).show();
                    }
                    return true;
                }
                return false;
            }
        });

        findViewById(R.id.ru_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.en_alphabet_btn).setOnClickListener(this);
        findViewById(R.id.decrement_size).setOnClickListener(this);
        findViewById(R.id.increment_size).setOnClickListener(this);
        findViewById(R.id.size_1).setOnClickListener(this);
        findViewById(R.id.size_3).setOnClickListener(this);
        findViewById(R.id.size_4).setOnClickListener(this);
        findViewById(R.id.size_5).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.en_alphabet_btn:
                slotView.setValues(enAlphabet);
                break;
            case R.id.ru_alphabet_btn:
                slotView.setValues(ruAlphabet);
                break;
            case R.id.decrement_size:
                slotView.removeColumn();
                break;
            case R.id.increment_size:
                slotView.addColumn();
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
}
