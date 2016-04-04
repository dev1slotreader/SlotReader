package com.udelphi.slotreader.Controlls;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.NumberPicker;

import com.udelphi.slotreader.Abstractions.BoardView;
import com.udelphi.slotreader.Exceptions.InvalidInputException;
import com.udelphi.slotreader.R;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;

public class SlotView extends BoardView{
    private ArrayList<Integer> requiredValues;
    private Runnable movePikersRunnable;
    private ArrayList<NumberPicker> pickers;
    private String[] values;
    private Handler handler;
    private int textColorId;
    private Drawable divider;
    private int columnsCount = 0;
    private MovingListener movingListener;

    public SlotView(Context context) {
        this(context, null);
    }

    public SlotView(Context context, AttributeSet attrs){
        this(context, attrs, 0);
    }

    public SlotView(Context context, AttributeSet attrs, int defStyle){
        super(context, attrs, defStyle);
        pickers = new ArrayList<>();
        requiredValues = new ArrayList<>();
        movePikersRunnable = new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = NumberPicker.class.getDeclaredMethod("changeValueByOne", boolean.class);
                    method.setAccessible(true);
                    for (int i = 0; i < pickers.size(); i++) {
                        if ( i < requiredValues.size() && pickers.get(i).getValue() != requiredValues.get(i))
                            method.invoke(pickers.get(i), pickers.get(i).getValue() < requiredValues.get(i));
                    }
                    OnPickersMoved();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        };
        handler = new Handler();

        TypedArray obtainAttrs = context.getTheme().obtainStyledAttributes(
                attrs,
                R.styleable.SlotView,
                0, 0);
        textColorId =  obtainAttrs.getColor(R.styleable.SlotView_textColor, -1);
        divider = obtainAttrs.getDrawable(R.styleable.SlotView_dividerDrawable);
        setLettersCount(obtainAttrs.getInt(R.styleable.SlotView_columns, 1));
    }

    @Override
    public void setValues(String[] values){
        if(!Arrays.equals(this.values, values))
            this.values = values;
        for (NumberPicker picker : pickers) {
            initPicker(picker);
        }
    }

    @Override
    public void showWord(String word){
        requiredValues.clear();
        determinePickersPositions(word);
        setLettersCount(word.length());
        if(needMoving()) {
            handler.post(movePikersRunnable);
            if(movingListener != null)
                movingListener.onMovingStarted();
        }
    }

    @Override
    public void showWordImmediately(String word) {
        super.showWordImmediately(word);
        determinePickersPositions(word);
        setLettersCount(word.length());
        for(int i = 0; i < pickers.size(); i++)
            pickers.get(i).setValue(requiredValues.get(i));
    }

    @Override
    public String readWord(){
        StringBuilder builder = new StringBuilder();
        for(NumberPicker picker : pickers){
            builder.append(values[picker.getValue()]);
        }
        return builder.toString();
    }

    @Override
    public void addLetter(){
        NumberPicker newPicker = new NumberPicker(getContext());
        newPicker.setLayerType(LAYER_TYPE_HARDWARE, null);
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

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        addView(newPicker);
        columnsCount++;
    }

    @Override
    public void removeLetter(){
        if(getChildCount() > 1) {
            removeViewAt(getChildCount() - 1);
            pickers.remove(pickers.size() - 1);
            columnsCount--;
        }
    }

    @Override
    public void setLettersCount(int count){
        int dif = count - columnsCount;
        if(dif < 0)
            for(int i = 1; i <= dif * -1; i++)
                removeLetter();
        else if (dif > 0)
            for(int i = 1; i <= dif; i++)
                addLetter();
    }

    @Override
    public void setMovingListener(MovingListener movingListener) {
        this.movingListener = movingListener;
    }

    private void initPicker(NumberPicker picker){
        if(values != null) {
            picker.setDisplayedValues(null);
            picker.setMinValue(0);
            picker.setMaxValue(values.length - 1);
            picker.setDisplayedValues(values);
        }
    }

    public void determinePickersPositions(String word){
        requiredValues.clear();
        int pickerValueIndex;
        for(int i = 0; i < word.length(); i++){
            if(i < word.length()) {
                String currentSymbol = word.substring(i, i + 1).toUpperCase();
                pickerValueIndex = 0;
                while (!values[pickerValueIndex].equals(currentSymbol))
                    pickerValueIndex++;
                requiredValues.add(pickerValueIndex);
            }
        }
    }

    private void OnPickersMoved(){
        if (needMoving())
            handler.postDelayed(movePikersRunnable, 75);
        else{
            handler.removeCallbacks(movePikersRunnable);
            if(movingListener != null)
                movingListener.onMovingEnded();
        }
    }

    private boolean needMoving(){
        boolean result = false;
        for(NumberPicker picker : pickers) {
            if (pickers.indexOf(picker) < requiredValues.size() &&
                    picker.getValue() != requiredValues.get(pickers.indexOf(picker))) {
                result = true;
                break;
            }
        }
        return result;
    }
}
