package com.udelphi.pagerwithgallerytestproj;

import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Gallery;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final ViewPager pager = (ViewPager) findViewById(R.id.view_pager);
        pager.setAdapter(new ViewPagerAdapter(getSupportFragmentManager(), getApplicationContext()));
        final Gallery gallery = (Gallery) findViewById(R.id.gallery);
        pager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                gallery.setSelection(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        gallery.setAdapter(new GalleryAdapter((getApplicationContext())));
        gallery.setSpacing(2);
        gallery.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                pager.setCurrentItem(position);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }
}
