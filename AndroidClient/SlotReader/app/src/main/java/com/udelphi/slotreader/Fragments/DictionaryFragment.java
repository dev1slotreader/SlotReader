package com.udelphi.slotreader.Fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Toast;

import com.udelphi.slotreader.Adapters.DictionaryAdapter;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class DictionaryFragment extends Fragment implements View.OnClickListener, SizeChangedListener,
        BoardSkinChangedListener{
    public static String TAG = "DictionaryFragment";
    private enum States{ base, removing_set, adding_from_keyboard, editing }
    private enum Appearances{ base, confirmation }

    private ListView list;

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
        this.jsonHelper = ((MainActivity)getActivity()).getJsonHelper();
        this.adapter = new DictionaryAdapter(getContext(), jsonHelper.getWords());
        this.boardSkinPosition = getArguments().getInt("boardSkinPosition");
        this.state = States.removing_set;
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
                        adapter.setSelection(position);
                        break;
                    case removing_set:
                        adapter.addSelection(position);
                        break;
                }
            }
        });
        setSkin(boardSkinPosition);
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
        for(String word : words)
            builder.append(word).append(" ");
        builder.append("...");
        Toast.makeText(getContext(), builder.toString(), Toast.LENGTH_SHORT).show();
    }

    private void replaceWord(String oldWord, String newWord){
        Toast.makeText(getContext(), "Replacing " + oldWord + "by" + newWord, Toast.LENGTH_SHORT).show();
    }

    private void setState(States state){
        switch (state){
            case base:
                break;
            case removing_set:
                break;
            case adding_from_keyboard:
                break;
            case editing:
                break;
        }
    }

    private void setAppearance(Appearances appearance){
        switch (appearance){
            case base:

                break;
            case confirmation:
                break;
        }
    }
}
