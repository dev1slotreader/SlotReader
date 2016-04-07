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
}
