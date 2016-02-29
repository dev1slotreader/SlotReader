package com.udelphi.pagerwithgallerytestproj;

import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.TextView;

public class GalleryAdapter extends BaseAdapter{
    private Context context;

    public GalleryAdapter(Context context){
        this.context = context;
    }

    @Override
    public int getCount() {
        return context.getResources().getInteger(R.integer.fragments_count);
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
            txt.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
            txt.setText(String.valueOf(position + 1));
            txt.setLayoutParams(new Gallery.LayoutParams(64, 64));
            txt.setGravity(Gravity.CENTER);
        }
        else
            txt = (TextView)convertView;
        return txt;
    }
}
