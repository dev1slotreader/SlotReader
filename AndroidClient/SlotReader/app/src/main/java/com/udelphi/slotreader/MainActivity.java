package com.udelphi.slotreader;

import android.os.Build;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ListView;

import com.udelphi.slotreader.Adapters.LanguagesAdapter;
import com.udelphi.slotreader.Adapters.MenuAdapter;
import com.udelphi.slotreader.Fragments.ReaderFragment;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.enums.ScreenModes;

import org.json.JSONException;

import java.io.IOException;

public class MainActivity extends AppCompatActivity implements View.OnClickListener,
 DrawerLayout.DrawerListener{
    private JsonHelper jsonHelper;
    private DrawerLayout drawerLayout;
    private ListView drawerList;
    private ArrayAdapter<String> menuAdapter;
    private ArrayAdapter<String> skinsAdapter;
    private ArrayAdapter<String> languagesAdapter;
    private AdapterView.OnItemClickListener menuClickListener;
    private AdapterView.OnItemClickListener languageClickListener;
    private AdapterView.OnItemClickListener skinsClickListener;
    private boolean isDrawerOpend;
    private boolean isSubmenuOpend;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        try {
            jsonHelper = new JsonHelper(getApplicationContext(), "slot_reader_source", "languages",
                    "charactersCount", "words");
        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }

        menuAdapter = new MenuAdapter(getApplicationContext(),
                R.array.menu_items, R.array.menu_icons);
        skinsAdapter = new MenuAdapter(getApplicationContext(),
                R.array.boards_items, R.array.boards_icons);
        languagesAdapter = new LanguagesAdapter(getApplicationContext(),
                jsonHelper.getLanguages() ,R.array.flags);
        languageClickListener = new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                ((ReaderFragment) getSupportFragmentManager().findFragmentByTag(ReaderFragment.TAG))
                        .changeLanguage(position);
                drawerLayout.closeDrawer(drawerList);
                drawerList.setAdapter(menuAdapter);
                drawerList.setOnItemClickListener(menuClickListener);
            }
        };
        menuClickListener = new ListView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                switch (position){
                    case 0:
                        changeFragment(new ReaderFragment());
                        drawerList.setItemChecked(position, true);
                        drawerLayout.closeDrawer(drawerList);
                        break;
                    case 1:
                        drawerList.setAdapter(skinsAdapter);
                        drawerList.setOnItemClickListener(skinsClickListener);
                        isSubmenuOpend = true;
                        break;
                    case 3:
                        drawerList.setAdapter(languagesAdapter);
                        drawerList.setOnItemClickListener(languageClickListener);
                        isSubmenuOpend = true;
                        break;
                }
            }
        };
        skinsClickListener = new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                ReaderFragment readerFragment = (ReaderFragment)getSupportFragmentManager()
                        .findFragmentByTag(ReaderFragment.TAG);
                switch (position){
                    case 0:
                        readerFragment.changeSkin(getResources().getDrawable(R.drawable.board_black));
                        break;
                    case 1:
                        readerFragment.changeSkin(getResources().getDrawable(R.drawable.board_green));
                        break;
                    case 2:
                        readerFragment.changeSkin(getResources().getDrawable(R.drawable.board_white));
                        break;
                }
                drawerLayout.closeDrawer(drawerList);
                drawerList.setAdapter(menuAdapter);
                drawerList.setOnItemClickListener(menuClickListener);
            }
        };

        ImageButton menuBtn = (ImageButton)findViewById(R.id.menu_btn);
        assert menuBtn != null;
        menuBtn.setOnClickListener(this);
        drawerLayout = (DrawerLayout)findViewById(R.id.drawer_layout);
        drawerLayout.addDrawerListener(this);
        drawerList = (ListView)findViewById(R.id.left_drawer);
        drawerList.setAdapter(menuAdapter);
        drawerList.setOnItemClickListener(menuClickListener);
        menuClickListener.onItemClick(null, null, 0, 0);

        setScreenMode(ScreenModes.FULL_SCREEN);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.menu_btn:
                drawerLayout.openDrawer(drawerList);
                break;
        }
    }

    @Override
    public void onBackPressed() {
        if(isDrawerOpend && isSubmenuOpend) {
            drawerList.setAdapter(menuAdapter);
            drawerList.setOnItemClickListener(menuClickListener);
            isSubmenuOpend = false;
        }
        else if(isDrawerOpend && !isSubmenuOpend)
            drawerLayout.closeDrawer(drawerList);
        else
            super.onBackPressed();
    }

    public JsonHelper getJsonHelper(){
        return this.jsonHelper;
    }

    private void setScreenMode(ScreenModes mode){
        switch (mode) {
            case FULL_SCREEN:
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    getWindow().getDecorView().setSystemUiVisibility(
                              View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
                }else {
                    //TODO Implement
//                            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//                                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//                                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//                                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
//                                    | View.SYSTEM_UI_FLAG_FULLSCREEN);
//                    getWindow().getDecorView().setOnSystemUiVisibilityChangeListener(new View.OnSystemUiVisibilityChangeListener() {
//                        @Override
//                        public void onSystemUiVisibilityChange(int visibility) {
//                            if ((visibility & View.SYSTEM_UI_FLAG_FULLSCREEN) == 0) {
//                                new Handler().postDelayed(new Runnable() {
//                                    @Override
//                                    public void run() {
//                                        setScreenMode(ScreenModes.FULL_SCREEN);
//                                    }
//                                }, 5000);
//                            }
//                        }
//                    });
                }
                break;
            case NAVIGATION_VISIBLE:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    getWindow().getDecorView().setSystemUiVisibility(
                            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                    | View.SYSTEM_UI_FLAG_FULLSCREEN
                                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                    | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
                }else {
                    //TODO Implement
                }
        }
    }

    private void changeFragment(Fragment fragment){
        if(fragment != null){
            getSupportFragmentManager().beginTransaction()
                    .replace(R.id.content_frame, fragment, ReaderFragment.TAG)
                    .commit();
        }
    }

    @Override
    public void onDrawerSlide(View drawerView, float slideOffset) {

    }

    @Override
    public void onDrawerOpened(View drawerView) {
        setScreenMode(ScreenModes.NAVIGATION_VISIBLE);
        isDrawerOpend = true;
    }

    @Override
    public void onDrawerClosed(View drawerView) {
        setScreenMode(ScreenModes.FULL_SCREEN);
        drawerList.setAdapter(menuAdapter);
        isDrawerOpend = false;
    }

    @Override
    public void onDrawerStateChanged(int newState) {

    }
}
