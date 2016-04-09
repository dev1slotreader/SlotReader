package com.udelphi.slotreader.Fragments;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.udelphi.slotreader.Adapters.DictionaryAdapter;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class DictionaryFragment extends Fragment implements View.OnClickListener, SizeChangedListener,
        BoardSkinChangedListener{
    public static String TAG = "DictionaryFragment";

    private JsonHelper jsonHelper;
    private DictionaryAdapter adapter;
    private ListView list;
    private int boardSkinPosition;

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
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_dictionary, null);
        list = (ListView)view.findViewById(R.id.dictionary_list);
        list.setAdapter(adapter);
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
}
