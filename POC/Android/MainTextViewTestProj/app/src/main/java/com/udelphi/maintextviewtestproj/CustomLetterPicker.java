package com.udelphi.maintextviewtestproj;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import java.util.Arrays;

public class CustomLetterPicker extends ScrollView {
    private Context context;
    private LinearLayout container;
    private boolean isWrapContent;
    private String[] source;
    private Runnable scrollerTask;
    private int itemHeight;
    private int initialPosition;
    private int newCheck = 400;

    public CustomLetterPicker(Context context){
        this(context, null);
    }

    public CustomLetterPicker(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        this.setVerticalScrollBarEnabled(false);
        this.setHorizontalScrollBarEnabled(false);
        container = new LinearLayout(context);
        container.setOrientation(LinearLayout.VERTICAL);
        this.addView(container);
        if(attrs.getAttributeValue("http://schemas.android.com/apk/res/android", "layout_height")
                .equals("-2"))
            this.isWrapContent = true;
        this.scrollerTask = new Runnable() {
            @Override
            public void run() {
                if(initialPosition == getScrollY()){
                    int residueY = initialPosition % itemHeight;
                    if(residueY == 0)
                        return;
                    initialPosition = residueY > itemHeight / 2 ?
                            initialPosition + residueY : initialPosition - residueY;
                    removeCallbacks(scrollerTask);
                    smoothScrollTo(0, initialPosition);
                }
                else{
                    initialPosition = getScrollY();
                    postDelayed(scrollerTask, newCheck);
                }
            }
        };
        this.setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN ||
                        event.getAction() == MotionEvent.ACTION_UP)
                    startScrollerTask();
                return false;
            }
        });
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
        if(itemHeight != getHeight() / 3) {
            itemHeight = getHeight() / 3;
            setItemsHeight(itemHeight);
        }
    }

    public void setSource(String[] source){
        if(!Arrays.equals(this.source, source)){
            this.source = source;
            for(int i = 0; i < source.length; i++){
                if (i < container.getChildCount())
                    ((TextView)container.getChildAt(i)).setText(source[i]);
                else{
                    TextView newTV = new TextView(context);
                    newTV.setGravity(Gravity.CENTER);
                    newTV.setText(source[i]);
                    newTV.setTextColor(context.getResources().getColor(android.R.color.white));
                    container.addView(newTV);
                    invalidate();
                }
            }
            if(getChildCount() > source.length){
                container.removeViews(source.length, getChildCount() - source.length);
            }
        }
    }

    private void setItemsHeight(int height){
        for(int i = 0; i < container.getChildCount(); i++) {
            View tv = container.getChildAt(i);
            if(tv instanceof TextView)
                ((TextView) tv).setHeight(height);
        }
    }

    public void startScrollerTask(){
        initialPosition = getScrollY();
        postDelayed(scrollerTask, newCheck);
    }
}
