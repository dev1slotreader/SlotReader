package com.udelphi.slotreader.Adapters;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.TextView;

import com.udelphi.slotreader.R;

public class GalleryAdapter extends BaseAdapter{
    private Context context;
    private String[] sizes;
    private int[] colors;

    public GalleryAdapter(Context context){
        this.context = context;
        this.sizes = context.getResources().getStringArray(R.array.sizes);
        this.colors = context.getResources().getIntArray(R.array.size_btn_colors);
    }

    @Override
    public int getCount() {
        return sizes.length;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        TextView txt;
        if(convertView == null){
            txt = new TextView(context);
            GradientDrawable background = (GradientDrawable)context.getResources().getDrawable(R.drawable.img_btn_normal);
            assert background != null;
            background.setColor(colors[position]);
            txt.setBackground(background);
            txt.setText(sizes[position]);
            txt.setLayoutParams(new Gallery.LayoutParams(48, 48));
            txt.setGravity(Gravity.CENTER);
        }
        else
            txt = (TextView)convertView;
        return txt;
    }
}
