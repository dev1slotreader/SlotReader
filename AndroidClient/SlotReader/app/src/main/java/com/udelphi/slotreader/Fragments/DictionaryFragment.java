package com.udelphi.slotreader.Fragments;


import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.MainActivity;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.R;

public class DictionaryFragment extends Fragment implements View.OnClickListener, SizeChangedListener,
        BoardSkinChangedListener{
    public static String TAG = "DictionaryFragment";

    private JsonHelper jsonHelper;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.jsonHelper = ((MainActivity)getActivity()).getJsonHelper();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_dictionary, null);
        ((ListView)view.findViewById(R.id.dictionary_list))
                .setAdapter(new ArrayAdapter<>(getActivity().getApplicationContext(),
                        android.R.layout.simple_list_item_1, jsonHelper.getWords()));
        return view;
    }

    @Override
    public void onClick(View v) {

    }

    @Override
    public void onBoardSkinChanged(int position) {

    }

    @Override
    public void onSizeChanged(int size) {

    }
}
