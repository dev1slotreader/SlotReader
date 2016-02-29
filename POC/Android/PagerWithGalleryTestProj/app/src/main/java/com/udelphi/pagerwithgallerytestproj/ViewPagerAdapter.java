package com.udelphi.pagerwithgallerytestproj;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

public class ViewPagerAdapter extends FragmentStatePagerAdapter{
    private Context context;

    public ViewPagerAdapter(FragmentManager fm, Context context){
        super(fm);
        this.context = context;
    }


    @Override
    public Fragment getItem(int position) {
        return PagerItemFragment.newInstance(position);
    }

    @Override
    public int getCount() {
        return context.getResources().getInteger(R.integer.fragments_count);
    }
}
