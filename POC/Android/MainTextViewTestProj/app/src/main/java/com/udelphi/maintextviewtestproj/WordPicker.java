package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.graphics.Paint;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.NumberPicker;
import android.widget.TextView;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

public class WordPicker extends LinearLayout {
    int requiredValue = 0;
    Runnable movePikersRunnable;
    ArrayList<NumberPicker> pickers;
    String[] letters;
    Handler handler;



    public WordPicker(Context context){
        super(context);
        initView(context);
    }

    public WordPicker(Context context, AttributeSet attrs){
        super(context, attrs);
        initView(context);
    }

    public WordPicker(Context context, AttributeSet attrs, int defStyle){
        super(context, attrs, defStyle);
        initView(context);
    }



    private void initView(Context context) {
        letters = new String[]{
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
                "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        };
        movePikersRunnable = new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = NumberPicker.class.getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    for (NumberPicker picker : pickers) {
                        if (picker.getValue() != requiredValue)
                            method.invoke(picker, true);
                    }
                    OnPickersMoved();

                } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        };
        handler = new Handler();

        View view = inflate(context, R.layout.word_picker_layout, this);
        LinearLayout pickersContainer = (LinearLayout) view.findViewById(R.id.pickersContainer);
        pickers = new ArrayList<>();
        for (int i = 0; i <= pickersContainer.getChildCount(); i++) {
            View v = pickersContainer.getChildAt(i);
            if (v instanceof NumberPicker)
                pickers.add((NumberPicker) v);
        }
        for (NumberPicker picker : pickers) {
            picker.setMinValue(0);
            picker.setMaxValue(letters.length - 1);
            picker.setDisplayedValues(letters);

            try {
                Field mSelectionDivider = NumberPicker.class.getDeclaredField("mSelectionDivider");
                mSelectionDivider.setAccessible(true);
                Field mSelectorWheelPaint = NumberPicker.class.getDeclaredField("mSelectorWheelPaint");
                mSelectorWheelPaint.setAccessible(true);

                mSelectionDivider.set(picker, getResources().getDrawable(android.R.drawable.screen_background_light));

                for (int i = 0; i < picker.getChildCount(); i++) {
                    View child = picker.getChildAt(i);
                    if (child instanceof EditText)
                        ((EditText) child).setTextColor(getResources().getColor(android.R.color.white));
                    ((Paint) mSelectorWheelPaint.get(picker)).setColor(getResources().getColor(android.R.color.white));
                    picker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
                    picker.invalidate();
                }

            } catch (NoSuchFieldException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }

    public void moveValue(String value){
        setRequiredValue(value);
        if(needMoving())
            handler.post(movePikersRunnable);
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

    private void OnPickersMoved(){
        if (needMoving()) {
            handler.postDelayed(movePikersRunnable, 100);
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
}
