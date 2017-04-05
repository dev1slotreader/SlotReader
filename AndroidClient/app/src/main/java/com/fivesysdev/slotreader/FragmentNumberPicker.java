package com.fivesysdev.slotreader;

import android.app.Application;
import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.NumberPicker;

import java.util.Random;

/*
 * Created by user on 08.06.2017.
 */

public class FragmentNumberPicker extends Fragment {
    private View mView;
    private Application mApp;
    private Context mContext;
    private NumberPicker mNumberPicker;

    private String[] mArrTextChars = new String['Z' - 'A' + 1];
    private int mCurrentIndex = 0;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        mApp = (Application) getActivity().getApplication();
        mContext = mApp.getApplicationContext();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        mView = inflater.inflate(R.layout.fragment_numberpicker, container, false);

        mNumberPicker = (NumberPicker) mView.findViewById(R.id.numberPicker);

        initTextArray();
        initNumberPicker();

        return mView;
    }

    private void initNumberPicker() {
        mNumberPicker.setMinValue(0);
        mNumberPicker.setMaxValue(mArrTextChars.length - 1);
        mNumberPicker.setDisplayedValues(mArrTextChars);
        mNumberPicker.setValue(new Random().nextInt(mArrTextChars.length - 1));
    }

    private void initTextArray() {
        int i = 0;
        for(int j = 'A'; j <= 'Z'; j++) {
            mArrTextChars[i] = "" + (char) j;
            i++;
        }
    }
}