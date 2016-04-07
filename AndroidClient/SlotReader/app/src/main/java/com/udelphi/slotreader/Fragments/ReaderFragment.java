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
import com.udelphi.slotreader.Interfaces.OnSizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class ReaderFragment extends Fragment implements View.OnClickListener, BoardViewBase.MovingListener,
        OnSizeChangedListener{
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

    @Override
    public void onSizeChanged(int size) {
        boardView.setLettersCount(size);
        boardView.showWordImmediately(jsonHelper.getCurrentWord());
    }
}
