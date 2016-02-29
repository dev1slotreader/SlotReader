package com.udelphi.pagerwithgallerytestproj;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class PagerItemFragment extends Fragment{
    private static final String PAGER_NUMBER_KEY = "pager_number";

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_pager_item, container, false);
        ((TextView)view.findViewById(R.id.fragment_name_tv))
                .setText(String.valueOf("FRAGMENT " + (getArguments().getInt(PAGER_NUMBER_KEY) + 1)));
        return view;
    }

    public static PagerItemFragment newInstance(int pagerNum) {
        Bundle args = new Bundle();
        args.putInt(PAGER_NUMBER_KEY, pagerNum);
        PagerItemFragment fragment = new PagerItemFragment();
        fragment.setArguments(args);
        return fragment;
    }
}
