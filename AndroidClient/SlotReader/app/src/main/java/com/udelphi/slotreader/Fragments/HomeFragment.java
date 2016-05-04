package com.udelphi.slotreader.Fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.NumberPicker;
import android.widget.Toast;

import com.udelphi.slotreader.Abstractions.BoardViewBase;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.OnSizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class HomeFragment extends Fragment implements View.OnClickListener, BoardViewBase.MovingListener,
        OnSizeChangedListener, BoardSkinChangedListener, NumberPicker.OnScrollListener{
    public static String TAG = "ReaderFragment";
    private MainActivity activity;
    private BoardViewBase boardView;
    private JsonHelper jsonHelper;
    private boolean isMoving;
    private int boardSkinPosition;
    private int lettersCount;

    public static HomeFragment newInstance(int boardSkinPosition, int lettersCount){
        HomeFragment fragment = new HomeFragment();
        Bundle args = new Bundle();
        args.putInt("boardSkinPosition", boardSkinPosition);
        args.putInt("lettersCount", lettersCount);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.activity = (MainActivity) getActivity();
        this.boardSkinPosition = getArguments().getInt("boardSkinPosition");
        this.lettersCount = getArguments().getInt("lettersCount");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_home, null);
        jsonHelper = ((MainActivity)getActivity()).getJsonHelper();

        boardView = (BoardViewBase)view.findViewById(R.id.board_view);
        assert boardView != null;
        boardView.setValues(jsonHelper.getAlphabet());
        boardView.setMovingListener(this);
        boardView.setOnScrollListener(this);

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
        setLettersCount(lettersCount);
        activity.addOnSizeChangedListener(this);
    }

    @Override
    public void onPause() {
        super.onPause();
        activity.removeOnSizeChangedListener(this);
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
        setLettersCount(size);
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

    private void setLettersCount(int lettersCount){
        this.lettersCount = lettersCount;
        if(isVisible()) {
            boardView.setLettersCount(lettersCount);
            boardView.showWordImmediately(jsonHelper.getCurrentWord());
            boardView.setOnScrollListener(this);
        }
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

    @Override
    public void onScrollStateChange(NumberPicker view, int scrollState) {
        if (scrollState == NumberPicker.OnScrollListener.SCROLL_STATE_IDLE) {
            Toast.makeText(getContext(), "Word changed to " + boardView.readWord(), Toast.LENGTH_SHORT).show();
        }
    }
}
