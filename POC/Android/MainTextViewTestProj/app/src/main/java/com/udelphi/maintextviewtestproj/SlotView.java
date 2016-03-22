package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
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
    private int requiredValue = 0;
    private Runnable movePikersRunnable;
    private ArrayList<NumberPicker> pickers;
    private String[] values;
    private Handler handler;
    private int textColorId;
    private Drawable divider;
    private int columnsCount = 0;
    private OnMovingStartedListener onMovingStartedListener;
    private OnMovingEndedListener onMovingEndedListener;

    public SlotView(Context context){
        super(context);
    }

    public SlotView(Context context, AttributeSet attrs){
        super(context, attrs);
        pickers = new ArrayList<>();
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

        TypedArray obtainAttrs = context.getTheme().obtainStyledAttributes(
                attrs,
                R.styleable.SlotView,
                0, 0);
        textColorId =  obtainAttrs.getColor(R.styleable.SlotView_text_color, -1);
        int dividerId =  obtainAttrs.getColor(R.styleable.SlotView_divider_style, -1);
        switch (dividerId){
            case 0:
                divider = getResources().getDrawable(android.R.drawable.divider_horizontal_dark);
                break;
            case 1:
                divider = getResources().getDrawable(android.R.drawable.divider_horizontal_bright);
                break;
        }
        setColumnsCount(obtainAttrs.getInt(R.styleable.SlotView_columns, 1));
    }

    public SlotView(Context context, AttributeSet attrs, int defStyle){
        super(context, attrs, defStyle);
    }

    public void setValues(String[] source){
        if(!Arrays.equals(this.values, source))
            this.values = source;
        for (NumberPicker picker : pickers) {
            initPicker(picker);
        }
    }

    public void moveToValue(String value){
        setRequiredValue(value);
        if(needMoving()) {
            handler.post(movePikersRunnable);
            if(onMovingStartedListener != null)
                onMovingStartedListener.onMovingStarted();
        }
    }

    public void addColumn(){
        NumberPicker newPicker = new NumberPicker(getContext());
        pickers.add(newPicker);
        LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        params.weight = 1;
        newPicker.setLayoutParams(params);
        initPicker(newPicker);
        try {
            Field mSelectionDivider = NumberPicker.class.getDeclaredField("mSelectionDivider");
            mSelectionDivider.setAccessible(true);
            Field mSelectorWheelPaint = NumberPicker.class.getDeclaredField("mSelectorWheelPaint");
            mSelectorWheelPaint.setAccessible(true);

            mSelectionDivider.set(newPicker, divider);

            for (int i = 0; i < newPicker.getChildCount(); i++) {
                View child = newPicker.getChildAt(i);
                if (child instanceof EditText)
                    ((EditText) child).setTextColor(textColorId);
                ((Paint) mSelectorWheelPaint.get(newPicker)).setColor(textColorId);
                newPicker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
                newPicker.invalidate();
            }

        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
        addView(newPicker);
        columnsCount++;
    }

    public void removeColumn(){
        if(getChildCount() > 1) {
            removeViewAt(getChildCount() - 1);
            pickers.remove(pickers.size() - 1);
            columnsCount--;
        }
    }

    public void setColumnsCount(int count){
            int dif = count - columnsCount;
            if(dif < 0)
                for(int i = 1; i <= dif * -1; i++)
                    removeColumn();
            else if (dif > 0)
                for(int i = 1; i <= dif; i++)
                    addColumn();
    }

    private void initPicker(NumberPicker picker){
        if(values != null) {
            picker.setDisplayedValues(null);
            picker.setMinValue(0);
            picker.setMaxValue(values.length - 1);
            picker.setDisplayedValues(values);
        }
    }

    public void setOnMovingStartedListener(OnMovingStartedListener onMovingStartedListener) {
        this.onMovingStartedListener = onMovingStartedListener;
    }

    public void setOnMovingEndedListener(OnMovingEndedListener onMovingEndedListener) {
        this.onMovingEndedListener = onMovingEndedListener;
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
        if (needMoving())
            handler.postDelayed(movePikersRunnable, 100);
        else{
            handler.removeCallbacks(movePikersRunnable);
            if(onMovingEndedListener != null)
                onMovingEndedListener.onMovingEnded();
        }
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

    protected interface OnMovingStartedListener{
        void onMovingStarted();
    }

    protected interface OnMovingEndedListener{
        void onMovingEnded();
    }
}
