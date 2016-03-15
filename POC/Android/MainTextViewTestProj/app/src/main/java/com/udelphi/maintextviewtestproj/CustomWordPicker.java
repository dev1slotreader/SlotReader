package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.Arrays;

public class CustomWordPicker extends LinearLayout {
    private Context context;
    private String[] source;

    public CustomWordPicker(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
    }

    public void setSource(String[] source){
        if(!Arrays.equals(this.source, source)){
            this.source = source;
            for(int i = 0; i < source.length; i++){
                if (i < getChildCount())
                    ((TextView)getChildAt(i)).setText(source[i]);
                else{
                    TextView newTV = new TextView(context);
                    newTV.setText(source[i]);
                    addView(newTV);
                }
            }
            if(getChildCount() > source.length){
                removeViews(source.length, getChildCount() - source.length);
            }
        }
    }
}
