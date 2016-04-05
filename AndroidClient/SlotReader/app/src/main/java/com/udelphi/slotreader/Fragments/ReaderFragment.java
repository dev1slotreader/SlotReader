package com.udelphi.slotreader.Fragments;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Gallery;
import android.widget.ImageButton;
import android.widget.TextView;

import com.udelphi.slotreader.Abstractions.BoardViewBase;
import com.udelphi.slotreader.Adapters.GallerySizeAdapter;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class ReaderFragment extends Fragment implements View.OnClickListener, BoardViewBase.MovingListener{
    public static String TAG = "ReaderFragment";
    private BoardViewBase boardView;
    private JsonHelper jsonHelper;
    private boolean isMoving;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_reader, null);
        jsonHelper = ((MainActivity)getActivity()).getJsonHelper();

        boardView = (BoardViewBase)view.findViewById(R.id.word_picker);
        assert boardView != null;
        boardView.setValues(jsonHelper.getAlphabet());
        boardView.setMovingListener(this);

        Gallery gallery = (Gallery) view.findViewById(R.id.size_switch);
        assert gallery != null;
        gallery.setAdapter(new GallerySizeAdapter((getActivity().getApplicationContext())));
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
                jsonHelper.setWordSizeIndex(position);
                boardView.showWordImmediately(jsonHelper.getCurrentWord());
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
                if(!isMoving) {
                    checkShownWord();
                    boardView.showWord(jsonHelper.getNextWord());
                }
                break;
            case R.id.previous_btn:
                if(!isMoving){
                    checkShownWord();
                    boardView.showWord(jsonHelper.getPreviousWord());
                }
                break;
        }
    }

    @Override
    public void onMovingStarted() {
        isMoving = true;
    }

    @Override
    public void onMovingEnded() {
        isMoving = false;
    }

    public void changeLanguage(int language_index){
        jsonHelper.setLanguage(language_index);
        boardView.setValues(jsonHelper.getAlphabet());
    }

    public void changeSkin(Drawable skin){
        boardView.setBackground(skin);
    }

    private void checkShownWord(){
        String shownWord = boardView.readWord().toLowerCase();
        String currentWord = jsonHelper.getCurrentWord().toLowerCase();
        if(!shownWord.equals(currentWord) && jsonHelper.hasWord(shownWord))
            jsonHelper.setCurrentWord(shownWord);
    }
}
