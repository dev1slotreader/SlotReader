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

public class MainActivity extends AppCompatActivity {
    int requiredValue = 0;
    ArrayList<NumberPicker> pickers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final String[] letters = new String[]{
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
                "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
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


        (findViewById(R.id.btn)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int i = 0;
                while (!letters[i].equals("W"))
                    i++;

                for (int pickerIndex = 0; pickerIndex < letters.length; pickerIndex++) {
                    requiredValue = i;
                    for (pickerIndex = 0; pickerIndex < pickers.size(); pickerIndex++)
                        if (pickers.get(pickerIndex).getValue() != requiredValue) {
                            final int pickerIndexFinal = pickerIndex;
                            new Runnable() {
                                Method method;
                                Handler handler = new Handler();

                                @Override
                                public void run() {
                                    try {
                                        NumberPicker picker = pickers.get(pickerIndexFinal);
                                        method = picker.getClass().getDeclaredMethod("changeValueByOne", boolean.class);
                                        method.setAccessible(true);
                                        method.invoke(picker, true);
                                        if (picker.getValue() != requiredValue)
                                            method.invoke(picker, true);
                                        if (picker.getValue() != requiredValue - 1)
                                            handler.postDelayed(this, 50);
                                    } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                                        e.printStackTrace();
                                    }
                                }
                            }.run();
                        }
                    }
                }
        });
    }
}
