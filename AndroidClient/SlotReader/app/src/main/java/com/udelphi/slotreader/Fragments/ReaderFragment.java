package com.udelphi.slotreader.Fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Gallery;
import android.widget.ImageButton;
import android.widget.TextView;

import com.udelphi.slotreader.Abstractions.BoardView;
import com.udelphi.slotreader.Adapters.GalleryAdapter;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

import org.json.JSONException;

import java.io.IOException;

public class ReaderFragment extends Fragment implements View.OnClickListener{
    private BoardView boardView;
    private JsonHelper jsonHelper;

    private String[] enAlphabet = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
            "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            jsonHelper = new JsonHelper(getActivity().getApplicationContext(), "slot_reader_source", "languages",
                    "charactersCount", "words");
        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_reader, null);
        boardView = (BoardView)view.findViewById(R.id.word_picker);

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
                    value = value.substring(0, value.length() - 1);
                    boardView.setLettersCount(Integer.valueOf(value));
                }
                jsonHelper.setWord_size_index(position);
                String w = jsonHelper.getCurrentWord();
                boardView.showWord(w);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        ImageButton nextBtn = (ImageButton)view.findViewById(R.id.next_btn);
        nextBtn.setOnClickListener(this);
        ImageButton previousBtn = (ImageButton)view.findViewById(R.id.previous_btn);
        previousBtn.setOnClickListener(this);

        return view;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.next_btn:
                boardView.showWord(jsonHelper.getNextWord());
                break;
            case R.id.previous_btn:
                boardView.showWord(jsonHelper.getPreviousWord());
                break;
        }
    }
}
