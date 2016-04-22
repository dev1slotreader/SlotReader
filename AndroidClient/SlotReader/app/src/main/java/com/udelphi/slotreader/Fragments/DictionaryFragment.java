package com.udelphi.slotreader.Fragments;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.udelphi.slotreader.Adapters.DictionaryAdapter;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;
import com.udelphi.slotreader.StaticClasses.ScreenController;

public class DictionaryFragment extends Fragment implements View.OnClickListener, SizeChangedListener,
        BoardSkinChangedListener, TextView.OnEditorActionListener{
    public static String TAG = "DictionaryFragment";

    private enum States{ base, selected, removing_set, input }
    private enum Appearances{ base, selected, confirmation }

    private ListView list;
    private ImageButton leftBtn;
    private ImageButton rightBtn;
    private EditText input;

    private RemoveWordBtnHandler removeWordBtnHandler;
    private AddWordBtnHandler addWordBtnHandler;
    private EditWordBtnHandler editWordBtnHandler;
    private ConfirmWordsRemovingBtnHandler confirmWordsRemovingBtnHandler;
    private CancelBtnHandler cancelBtnHandler;

    private JsonHelper jsonHelper;
    private DictionaryAdapter adapter;
    private int boardSkinPosition;
    private States state;

    public static DictionaryFragment newInstance(int boardSkinPosition){
        DictionaryFragment fragment = new DictionaryFragment();
        Bundle args = new Bundle();
        args.putInt("boardSkinPosition", boardSkinPosition);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.addWordBtnHandler = new AddWordBtnHandler();
        this.removeWordBtnHandler = new RemoveWordBtnHandler();
        this.editWordBtnHandler = new EditWordBtnHandler();
        this.confirmWordsRemovingBtnHandler = new ConfirmWordsRemovingBtnHandler();
        cancelBtnHandler = new CancelBtnHandler();
        this.jsonHelper = ((MainActivity) getActivity()).getJsonHelper();
        this.adapter = new DictionaryAdapter(getContext(), jsonHelper.getWords());
        this.boardSkinPosition = getArguments().getInt("boardSkinPosition");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_dictionary, null);
        list = (ListView)view.findViewById(R.id.dictionary_list);
        list.setAdapter(adapter);
        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                switch (state){
                    case base:
                        changeSelection(position);
                        break;
                    case selected:
                        changeSelection(position);
                        break;
                    case removing_set:
                        adapter.addSelection(position);
                        break;
                }
            }

            private void changeSelection(int position){
                adapter.setSelection(position);
                if(adapter.isSelected(position) && state != States.selected)
                    setState(States.selected);
            }
        });
        leftBtn = (ImageButton)view.findViewById(R.id.left_FAB);
        rightBtn = (ImageButton)view.findViewById(R.id.right_FAB);

        setSkin(boardSkinPosition);
        setState(States.base);
        return view;
    }

    @Override
    public void onClick(View v) {

    }

    @Override
    public void onBoardSkinChanged(int position) {
        boardSkinPosition = position;
        if(isVisible())
            setSkin(boardSkinPosition);
    }

    @Override
    public void onSizeChanged(int size) {
        adapter.changeWords(jsonHelper.getWords());
        setState(States.base);
        adapter.resetSelections();
    }

    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        if(actionId == EditorInfo.IME_ACTION_DONE){
            if(state == States.selected){
                replaceWord(adapter.getSelections()[0], v.getText().toString());
                setState(States.base);
                adapter.resetSelections();
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        ScreenController.setScreenMode(getActivity(), ScreenController.ScreenModes.FULL_SCREEN);
                    }
                }, 1000);
                return true;
            }
        }
        return false;
    }

    private void setSkin(int position){
        list.setBackground(getResources().getDrawable(getResources()
                .obtainTypedArray(R.array.boards_backgrounds).getResourceId(position, -1)));
        switch (position){
            case 2:
                adapter.changeTextColor(getResources().getColor(R.color.light_skin_text_color));
                list.setDivider(getResources().getDrawable(android.R.drawable.divider_horizontal_bright));
                break;
            default:
                adapter.changeTextColor(getResources().getColor(R.color.dark_skin_text_color));
                list.setDivider(getResources().getDrawable(android.R.drawable.divider_horizontal_dark));
        }
    }

    private void addWord(String word){
        Toast.makeText(getContext(), "Adding " + word, Toast.LENGTH_SHORT).show();
    }

    private void removeWords(String[] words){
        StringBuilder builder = new StringBuilder();
        builder.append("Removing: ");
        for(int i = 0; i < words.length; i++)
            builder.append(words[i]).append(i == words.length - 1 ? "" : ", ");
        builder.append("...");
        adapter.resetSelections();
        Toast.makeText(getContext(), builder.toString(), Toast.LENGTH_SHORT).show();
    }

    private void replaceWord(String oldWord, String newWord){
        Toast.makeText(getContext(), "Replacing " + oldWord + " by " + newWord, Toast.LENGTH_SHORT).show();
    }

    private void setState(States state){
        this.state = state;
        switch (state){
            case base:
                leftBtn.setOnClickListener(removeWordBtnHandler);
                rightBtn.setOnClickListener(addWordBtnHandler);
                setAppearance(Appearances.base);
                break;
            case selected:
                leftBtn.setOnClickListener(removeWordBtnHandler);
                rightBtn.setOnClickListener(editWordBtnHandler);
                setAppearance(Appearances.selected);
                break;
            default:
                setAppearance(Appearances.confirmation);
                rightBtn.setOnClickListener(confirmWordsRemovingBtnHandler);
                leftBtn.setOnClickListener(cancelBtnHandler);
        }
    }

    private void setAppearance(Appearances appearance){
        switch (appearance){
            case base:
                leftBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_remove));
                rightBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_add));
                break;
            case selected:
                leftBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_remove));
                rightBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_edit));
                break;
            case confirmation:
                leftBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_cancel));
                rightBtn.setImageDrawable(getContext().getResources().getDrawable(R.mipmap.btn_confirm));
                break;
        }
    }

    private class RemoveWordBtnHandler implements View.OnClickListener{

        @Override
        public void onClick(View v) {
            if(adapter.hasSelection() && (state == States.base || state == States.selected)){
                String[] selectedWords = adapter.getSelections();
                removeWords(selectedWords);
                setState(States.base);
            } else {
                if(state == States.base) {
                    setState(States.removing_set);
                }
                else if(state == States.removing_set){
                    setState(States.base);
                    adapter.resetSelections();
                }
            }
        }
    }

    private class ConfirmWordsRemovingBtnHandler implements View.OnClickListener{
        @Override
        public void onClick(View v) {
            if(adapter.hasSelection()){
                switch (state) {
                    case removing_set:
                        removeWords(adapter.getSelections());
                        setState(States.base);
                        break;
                    case input:
                        int itemPosition = adapter.getSelectedPosition() - list.getFirstVisiblePosition();
                        if(!(itemPosition < 0 || itemPosition >= list.getChildCount())) {
                            input = (EditText) ((list.getChildAt(itemPosition))
                                    .findViewById(R.id.dictionary_item_text));
                            replaceWord(jsonHelper.getWords()[adapter.getSelectedPosition()],
                                    input.getText().toString());
                            input.setFocusableInTouchMode(false);
                            input.setFocusable(false);
                        }
                        setState(States.base);
                        ScreenController.setScreenMode(getActivity(), ScreenController.ScreenModes.FULL_SCREEN);
                        break;
                }
            }
        }
    }

    private class CancelBtnHandler implements View.OnClickListener{

        @Override
        public void onClick(View v) {
            setState(States.base);
            adapter.resetSelections();
        }
    }

    private class AddWordBtnHandler implements View.OnClickListener{
        @Override
        public void onClick(View v) {
            InputMethodManager imm = (InputMethodManager) getContext()
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            if(imm != null){
                imm.toggleSoftInput(InputMethodManager.SHOW_IMPLICIT, 0);
            }
        }
    }

    private class EditWordBtnHandler implements View.OnClickListener{
        DoneActionHandler doneHandler;

        public EditWordBtnHandler(){
            doneHandler = new DoneActionHandler();
        }

        @Override
        public void onClick(View v) {
            int itemPosition = adapter.getSelectedPosition() - list.getFirstVisiblePosition();
            if(!(itemPosition < 0 || itemPosition >= list.getChildCount())) {
                input = (EditText) ((list.getChildAt(itemPosition))
                        .findViewById(R.id.dictionary_item_text));
                input.setFocusableInTouchMode(true);
                input.requestFocus();
                input.setOnEditorActionListener(doneHandler);
                ((InputMethodManager)getActivity().getSystemService(Context.INPUT_METHOD_SERVICE))
                        .showSoftInput(input, 0);
                setState(States.input);
            }
        }

        private class DoneActionHandler implements TextView.OnEditorActionListener{

            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if(actionId == EditorInfo.IME_ACTION_DONE){
                    ScreenController.setScreenMode(getActivity(), ScreenController.ScreenModes.FULL_SCREEN);
                    input.setFocusableInTouchMode(false);
                }
                return false;
            }
        }
    }
}
