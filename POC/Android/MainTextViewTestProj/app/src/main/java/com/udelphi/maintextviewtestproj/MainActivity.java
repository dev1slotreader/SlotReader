package com.udelphi.maintextviewtestproj;

import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.NumberPicker;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainActivity extends AppCompatActivity {
    NumberPicker picker;
    Runnable moveValue;
    Handler handler;
    int requiredValue = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final String[] letters = new String[]{
          "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        };

        picker = (NumberPicker)findViewById(R.id.picker);
        picker.setMinValue(0);
        picker.setMaxValue(letters.length - 1);
        picker.setDisplayedValues(letters);

        handler = new Handler();
        moveValue = new Runnable() {
            @Override
            public void run() {
                Method method;
                try {
                    method = picker.getClass().getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    method.invoke(picker, true);
                    OnValueMoved();
                } catch (final NoSuchMethodException | InvocationTargetException | IllegalAccessException | IllegalArgumentException e) {
                    e.printStackTrace();
                }
            }
        };

        (findViewById(R.id.btn)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < letters.length; i++) {
                    if (letters[i].equals("W")) {
                        requiredValue = i;
                        if(picker.getValue() != requiredValue)
                            moveValue.run();
                    }
                }
            }
        });
    }

    private void OnValueMoved(){
        if(picker.getValue() != requiredValue - 1)
            handler.postDelayed(moveValue, 50);
    }
}
