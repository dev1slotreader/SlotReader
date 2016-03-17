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
    public static enum Style { LIGHT, LIGHT_WITH_DIVIDERS, DARK, DARK_WITH_DIVIDERS, DEFAULT }

    int requiredValue = 0;
    Runnable movePikersRunnable;
    ArrayList<NumberPicker> pickers;
    String[] letters;
    Handler handler;
    Style style = Style.DEFAULT;



    public WordPicker(Context context){
        super(context);
//        this.style = style;
        initView(context);
    }

    public WordPicker(Context context, AttributeSet attrs){
        super(context, attrs);
//        this.style = style;
        initView(context);
    }

    public WordPicker(Context context, AttributeSet attrs, int defStyle){
        super(context, attrs, defStyle);
//        this.style = style;
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
            style = Style.LIGHT_WITH_DIVIDERS;
            setDividerStyle(picker);
        }

    }

    public void moveValue(String value){
        setRequiredValue(value);
        if(needMoving())
            handler.post(movePikersRunnable);
    }

    public void setStyle(Style style){
        this.style = style;
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

    private void setDividerStyle(NumberPicker picker){
        try {
            Field mSelectionDivider = NumberPicker.class.getDeclaredField("mSelectionDivider");
            mSelectionDivider.setAccessible(true);
            switch (style){
                case LIGHT_WITH_DIVIDERS:
                    mSelectionDivider.set(picker, getResources().getDrawable(android.R.drawable.screen_background_light));
                    setLightText(picker);
                    break;
                case LIGHT:
                    mSelectionDivider.set(picker, getResources().getDrawable(R.drawable.transparent_divider));
                    setLightText(picker);
                    break;
                case DARK_WITH_DIVIDERS:
                    mSelectionDivider.set(picker, getResources().getDrawable(android.R.drawable.screen_background_dark));
                    setDarkText(picker);
                    break;
                case DARK:
                    mSelectionDivider.set(picker, getResources().getDrawable(android.R.drawable.screen_background_dark_transparent));
                    setDarkText(picker);
                    break;
            }
        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
    }
    private void setLightText(NumberPicker picker) throws NoSuchFieldException, IllegalAccessException {
        Field mSelectorWheelPaint = NumberPicker.class.getDeclaredField("mSelectorWheelPaint");
        mSelectorWheelPaint.setAccessible(true);
        for (int i = 0; i < picker.getChildCount(); i++) {
            View child = picker.getChildAt(i);
            if (child instanceof EditText)
                ((EditText) child).setTextColor(getResources().getColor(android.R.color.white));
            ((Paint) mSelectorWheelPaint.get(picker)).setColor(getResources().getColor(android.R.color.white));
            picker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
            picker.invalidate();
        }
    }

    private void setDarkText(NumberPicker picker)throws NoSuchFieldException, IllegalAccessException {
        Field mSelectorWheelPaint = NumberPicker.class.getDeclaredField("mSelectorWheelPaint");
        mSelectorWheelPaint.setAccessible(true);
        for (int i = 0; i < picker.getChildCount(); i++) {
            View child = picker.getChildAt(i);
            if (child instanceof EditText)
                ((EditText) child).setTextColor(getResources().getColor(android.R.color.background_dark));
            ((Paint) mSelectorWheelPaint.get(picker)).setColor(getResources().getColor(android.R.color.background_dark));
            picker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
            picker.invalidate();
        }
    }
}
