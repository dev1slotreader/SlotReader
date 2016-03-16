package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.Arrays;

public class CustomLetterPicker extends LinearLayout {
    private Context context;
    private String[] source;
    private boolean isWrapContent;

    public CustomLetterPicker(Context context){
        this(context, null);
    }

    public CustomLetterPicker(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        if(attrs.getAttributeValue("http://schemas.android.com/apk/res/android", "layout_height")
                .equals("-2"))
            this.isWrapContent = true;
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        super.onLayout(changed, l, t, r, b);
        if(isWrapContent) {
            ViewGroup.LayoutParams params = getLayoutParams();
            params.width = 64;
            params.height = 192;
            setLayoutParams(params);
        }

        setItemsHeight(getHeight()/3);
    }

    public void setSource(String[] source){
        if(!Arrays.equals(this.source, source)){
            this.source = source;
            for(int i = 0; i < source.length; i++){
                if (i < getChildCount())
                    ((TextView)getChildAt(i)).setText(source[i]);
                else{
                    TextView newTV = new TextView(context);
                    newTV.setGravity(Gravity.CENTER);
                    newTV.setText(source[i]);
                    addView(newTV);
                    invalidate();
                }
            }
            if(getChildCount() > source.length){
                removeViews(source.length, getChildCount() - source.length);
            }
        }
    }

    private void setItemsHeight(int height){
        for(int i = 0; i < getChildCount(); i++) {
            View tv = getChildAt(i);
            if(tv instanceof TextView)
                ((TextView) tv).setHeight(height);
        }
    }
}
