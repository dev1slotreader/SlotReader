package com.udelphi.slotreader.Adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.udelphi.slotreader.R;

public class DictionaryAdapter extends ArrayAdapter<String>{
    private int textColorId;
    private String[] words;

    public DictionaryAdapter(Context context, String[] words, int textColorId) {
        super(context, R.layout.fragment_dictionary, words);
        this.textColorId = textColorId;
        this.words = words;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null)
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_dictionary, null);

        TextView tv = (TextView)convertView.findViewById(R.id.dictionary_item_tv);
        tv.setText(words[position]);
        tv.setTextColor(getContext().getResources().getColor(textColorId));

        return convertView;
    }
}
