package com.udelphi.slotreader.Fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Gallery;
import android.widget.TextView;

import com.udelphi.slotreader.Abstractions.BoardView;
import com.udelphi.slotreader.Adapters.GalleryAdapter;
import com.udelphi.slotreader.R;

public class ReaderFragment extends Fragment{
    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_reader, null);
        final BoardView boardView = (BoardView)view.findViewById(R.id.word_picker);

        assert boardView != null;
        boardView.setValues(enAlphabet);

        Gallery gallery = (Gallery) view.findViewById(R.id.size_switch);
        assert gallery != null;
        gallery.setAdapter(new GalleryAdapter((getActivity().getApplicationContext())));
        gallery.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String value = ((TextView) view).getText().toString();
                try {
                    boardView.setLettersCount(Integer.valueOf(value));
                } catch (NumberFormatException ignored) {
                    boardView.setLettersCount(Integer.valueOf(value.substring(0, value.length() - 1)));
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        return view;
    }
}
