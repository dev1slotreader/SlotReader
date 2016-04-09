package com.udelphi.slotreader.Fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;

import com.udelphi.slotreader.Abstractions.BoardViewBase;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class ReaderFragment extends Fragment implements View.OnClickListener, BoardViewBase.MovingListener,
        SizeChangedListener, BoardSkinChangedListener{
    public static String TAG = "ReaderFragment";
    private BoardViewBase boardView;
    private JsonHelper jsonHelper;
    private boolean isMoving;
    int boardSkinPosition;

    public static ReaderFragment newInstance(int boardSkinPosition){
        ReaderFragment fragment = new ReaderFragment();
        Bundle args = new Bundle();
        args.putInt("boardSkinPosition", boardSkinPosition);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.boardSkinPosition = getArguments().getInt("boardSkinPosition");
    }

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
    public void onResume() {
        super.onResume();
        setSkin(boardSkinPosition);
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

    @Override
    public void onSizeChanged(int size) {
        boardView.setLettersCount(size);
        boardView.showWordImmediately(jsonHelper.getCurrentWord());
    }

    @Override
    public void onBoardSkinChanged(int position) {
        boardSkinPosition = position;
        if(isVisible())
            setSkin(boardSkinPosition);
    }

    private void checkShownWord(){
        String shownWord = boardView.readWord().toLowerCase();
        String currentWord = jsonHelper.getCurrentWord().toLowerCase();
        if(!shownWord.equals(currentWord) && jsonHelper.hasWord(shownWord))
            jsonHelper.setCurrentWord(shownWord);
    }

    private void setSkin(int position){
        boardView.setBackground(getResources().getDrawable(getResources()
                .obtainTypedArray(R.array.boards_backgrounds).getResourceId(position, -1)));
        switch (position){
            case 2:
                boardView.setTextColor(getResources().getColor(R.color.light_skin_text_color));
                boardView.setDivider(getResources().getDrawable(android.R.drawable.divider_horizontal_bright));
                break;
            default:
                boardView.setTextColor(getResources().getColor(R.color.dark_skin_text_color));
                boardView.setDivider(getResources().getDrawable(android.R.drawable.divider_horizontal_dark));
        }
    }
}
