package com.udelphi.slotreader.Adapters;

import android.content.Context;
import android.content.res.TypedArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.udelphi.slotreader.R;

public class MenuAdapter extends ArrayAdapter<String>{
    private String[] items;
    private TypedArray iconsIds;

    public MenuAdapter(Context context, int stringResId, int ImgResId) {
        super(context, R.layout.item_menu, stringResId);
        this.items = context.getResources().getStringArray(stringResId);
        this.iconsIds = context.getResources().obtainTypedArray(ImgResId);
    }

    @Override
    public int getCount() {
        return items.length;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null)
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_menu, null);

        ((ImageView)convertView.findViewById(R.id.languages_flag_img))
                .setImageDrawable(getContext().getResources().getDrawable(iconsIds.getResourceId(position, -1)));
        ((TextView) convertView.findViewById(R.id.languages_language_tv)).setText(items[position]);
        return convertView;
    }
}
