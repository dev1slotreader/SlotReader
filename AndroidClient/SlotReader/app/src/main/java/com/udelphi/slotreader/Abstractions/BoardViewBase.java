package com.udelphi.slotreader.Abstractions;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

import com.udelphi.slotreader.Interfaces.BoardView;

public abstract class BoardViewBase extends LinearLayout implements BoardView {
    public BoardViewBase(Context context){
        this(context, null);
    }

    public BoardViewBase(Context context, AttributeSet attrs){
        this(context, attrs, 0);
    }

    public BoardViewBase(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public void setValues(String[] values) {

    }

    @Override
    public void showWord(String word){

    }

    @Override
    public void showWordImmediately(String word) {

    }

    @Override
    public String readWord() {
        return null;
    }

    @Override
    public void addLetter() {

    }

    @Override
    public void removeLetter() {

    }

    @Override
    public void setLettersCount(int count) {

    }

    @Override
    public void setMovingListener(MovingListener movingListener) {

    }
}
