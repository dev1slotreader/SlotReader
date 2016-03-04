package com.udelphi.maintextviewtestproj;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.NumberPicker;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainActivity extends AppCompatActivity {
    NumberPicker picker1;
    NumberPicker picker2;
    Runnable moveValue1;
    Runnable moveValue2;
    Handler handler1;
    Handler handler2;
    int requiredValue = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final String[] letters = new String[]{
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
                "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        };

        picker1 = (NumberPicker)findViewById(R.id.picker1);
        picker1.setMinValue(0);
        picker1.setMaxValue(letters.length - 1);
        picker1.setDisplayedValues(letters);

        picker2 = (NumberPicker)findViewById(R.id.picker2);
        picker2.setMinValue(0);
        picker2.setMaxValue(letters.length - 1);
        picker2.setDisplayedValues(letters);

        handler1 = new Handler();
        moveValue1 = new Runnable() {
            @Override
            public void run() {
                Method method;
                try {
                    method = picker1.getClass().getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    if (picker1.getValue() != requiredValue)
                        method.invoke(picker1, true);
                    if(picker1.getValue() != requiredValue - 1)
                        handler1.postDelayed(moveValue1, 50);
                } catch (final NoSuchMethodException | InvocationTargetException | IllegalAccessException | IllegalArgumentException e) {
                    e.printStackTrace();
                }
            }
        };
        handler2 = new Handler();
        moveValue2 = new Runnable() {
            @Override
            public void run() {
                Method method;
                try {
                    method = picker2.getClass().getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    if (picker2.getValue() != requiredValue)
                        method.invoke(picker2, true);
                    if (picker2.getValue() != requiredValue - 1)
                        handler2.postDelayed(moveValue2, 50);
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
                        if (picker1.getValue() != requiredValue)
                            moveValue1.run();
                        if (picker2.getValue() != requiredValue)
                            moveValue2.run();
                    }
                }
            }
        });
    }
}
