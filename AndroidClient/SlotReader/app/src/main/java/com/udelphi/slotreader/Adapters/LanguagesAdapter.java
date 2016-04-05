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

public class LanguagesAdapter extends ArrayAdapter<String>{
    private String[] languages;
    private TypedArray flagsIds;

    public LanguagesAdapter(Context context, String[] languages, int flagsIds) {
        super(context, R.layout.item_menu, languages);
        this.languages = languages;
        this.flagsIds = context.getResources().obtainTypedArray(flagsIds);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null)
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_menu, null);

        ((ImageView)convertView.findViewById(R.id.languages_flag_img))
                .setImageDrawable(getContext().getResources().getDrawable(flagsIds.getResourceId(position, -1)));
        ((TextView) convertView.findViewById(R.id.languages_language_tv)).setText(languages[position]);
        return convertView;
    }
}
