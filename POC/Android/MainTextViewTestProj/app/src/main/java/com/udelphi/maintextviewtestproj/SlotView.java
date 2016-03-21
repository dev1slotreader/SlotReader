package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.graphics.Paint;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.NumberPicker;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;

public class SlotView extends LinearLayout {
    int requiredValue = 0;
    Runnable movePikersRunnable;
    ArrayList<NumberPicker> pickers;
    String[] values;
    Handler handler;

    public SlotView(Context context){
        super(context);
        initView();
    }

    public SlotView(Context context, AttributeSet attrs){
        super(context, attrs);
        initView();
    }

    public SlotView(Context context, AttributeSet attrs, int defStyle){
        super(context, attrs, defStyle);
        initView();
    }

    private void initView() {
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
        pickers = new ArrayList<>();
        for (int i = 0; i <= this.getChildCount(); i++) {
            View v = this.getChildAt(i);
            if (v instanceof NumberPicker)
                pickers.add((NumberPicker) v);
        }
    }

    public void addColumn(){
        NumberPicker newPicker = new NumberPicker(getContext());
        pickers.add(newPicker);
        LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        params.weight = 1;
        newPicker.setLayoutParams(params);
        setPickerValues(newPicker);
        try {
            Field mSelectionDivider = NumberPicker.class.getDeclaredField("mSelectionDivider");
            mSelectionDivider.setAccessible(true);
            Field mSelectorWheelPaint = NumberPicker.class.getDeclaredField("mSelectorWheelPaint");
            mSelectorWheelPaint.setAccessible(true);

            mSelectionDivider.set(newPicker, getResources().getDrawable(android.R.drawable.screen_background_light));

            for (int i = 0; i < newPicker.getChildCount(); i++) {
                View child = newPicker.getChildAt(i);
                if (child instanceof EditText)
                    ((EditText) child).setTextColor(getResources().getColor(android.R.color.white));
                ((Paint) mSelectorWheelPaint.get(newPicker)).setColor(getResources().getColor(android.R.color.white));
                newPicker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
                newPicker.invalidate();
            }

        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
        addView(newPicker);
    }

    public void removeColumn(){
        removeViewAt(getChildCount() - 1);
    }

    public void setValues(String[] source){
        if(!Arrays.equals(this.values, source))
            this.values = source;
        for (NumberPicker picker : pickers) {
            setPickerValues(picker);
        }
    }

    private void setPickerValues(NumberPicker picker){
        if(values != null) {
            picker.setDisplayedValues(null);
            picker.setMinValue(0);
            picker.setMaxValue(values.length - 1);
            picker.setDisplayedValues(values);
        }
    }

    public void moveValue(String value){
        setRequiredValue(value);
        if(needMoving())
            handler.post(movePikersRunnable);
    }

    private void setRequiredValue(String symbol){
        try {
            while (!values[requiredValue].equals(symbol))
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
