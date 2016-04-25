package com.udelphi.slotreader.Adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.udelphi.slotreader.R;

import java.util.ArrayList;
import java.util.HashMap;

public class DictionaryAdapter extends ArrayAdapter<String>{
    private int textColorId;
    private String[] words;
    private HashMap<String,Boolean> selections;

    public DictionaryAdapter(Context context, String[] words) {
        super(context, R.layout.fragment_dictionary, words);
        this.words = words;
        this.textColorId = getContext().getResources().getColor(android.R.color.white);
        this.selections = new HashMap<>();
        resetSelections();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null)
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_dictionary, null);
        TextView tv = (TextView)convertView.findViewById(R.id.dictionary_item_text);
        tv.setText(words[position]);
        tv.setTextColor(textColorId);

        convertView.setBackgroundColor(getContext().getResources().getColor(selections.get(words[position]) ?
        R.color.colorSelectedItem : android.R.color.transparent));

        return convertView;
    }

    public void changeTextColor(int textColorId){
        this.textColorId = textColorId;
        notifyDataSetChanged();
    }

    public void changeWords(String[] words){
        this.words = words;
        notifyDataSetChanged();
    }

    public void setSelection(int position){
        for(int i = 0; i < selections.size(); i++) {
            if(i == position)
                selections.put(words[i], !selections.get(words[i]));
            else
                selections.put(words[i], false);
        }
        notifyDataSetChanged();
    }

    public void addSelection(int position){
        selections.put(words[position], !selections.get(words[position]));
        notifyDataSetChanged();
    }

    public String[] getSelections(){
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < selections.size(); i++)
            if(selections.get(words[i]))
                builder.append(words[i]).append(" ");
        return builder.toString().split(" ");
    }

    // Will not use multi-selection state
    public int getSelectedPosition(){
        for (int i = 0; i < selections.size(); i++)
            if(selections.get(words[i]))
                return i;
        return -1;
    }

    public void resetSelections(){
        selections.clear();
        for (String word : words)
            selections.put(word, false);
        notifyDataSetChanged();
    }

    public boolean hasSelection(){
        for(int i = 0; i < selections.size(); i++)
            if(selections.get(words[i]))
                return true;
        return false;
    }

    public boolean isSelected(int position){
        return selections.get(words[position]);
    }
}
