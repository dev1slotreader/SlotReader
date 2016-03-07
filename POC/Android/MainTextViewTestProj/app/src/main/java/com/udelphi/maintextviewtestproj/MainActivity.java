package com.udelphi.maintextviewtestproj;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.NumberPicker;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    int requiredValue = 0;
    ArrayList<NumberPicker> pickers;
    Handler handler;
    Runnable movePikersRunnable;
    String[] letters;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        letters = new String[]{
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
                "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        };

        handler = new Handler();
        movePikersRunnable = new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = NumberPicker.class.getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    for(NumberPicker picker : pickers) {
                        if (picker.getValue() != requiredValue)
                            method.invoke(picker, true);
                    }
                    OnPickersMoved();

                } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        };

        LinearLayout pickersContainer = (LinearLayout)findViewById(R.id.pickersContainer);
        pickers = new ArrayList<>();
        for(int i = 0; i <= pickersContainer.getChildCount(); i++) {
            View v = pickersContainer.getChildAt(i);
            if (v instanceof NumberPicker)
                pickers.add((NumberPicker)v);
        }
        for(NumberPicker picker : pickers){
            picker.setMinValue(0);
            picker.setMaxValue(letters.length - 1);
            picker.setDisplayedValues(letters);
        }


        (findViewById(R.id.a_btn)).setOnClickListener(this);
        (findViewById(R.id.o_btn)).setOnClickListener(this);
        (findViewById(R.id.z_btn)).setOnClickListener(this);
    }

    private void OnPickersMoved(){
        if (needMoving()) {
            handler.postDelayed(movePikersRunnable, 75);
        }
        else handler.removeCallbacks(movePikersRunnable);
    }

    private boolean needMoving(){
        boolean result = false;
        for(NumberPicker picker : pickers) {
            if (picker.getValue() != requiredValue) {
                result = true;
                break;
            }
        }
        return result;
    }

    private void setRequiredValue(String symbol){
        try {
            while (!letters[requiredValue].equals(symbol))
                requiredValue++;
        }catch (IndexOutOfBoundsException e) {
            requiredValue = 0;
            setRequiredValue(symbol);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.a_btn:
                setRequiredValue("A");
                if (needMoving())
                    handler.post(movePikersRunnable);
                break;
            case R.id.o_btn:
                setRequiredValue("O");
                if (needMoving())
                    handler.post(movePikersRunnable);
                break;
            case R.id.z_btn:
                setRequiredValue("Z");
                if (needMoving())
                    handler.post(movePikersRunnable);
                break;
        }
    }
}
