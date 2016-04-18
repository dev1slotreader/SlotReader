package com.udelphi.slotreader;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Gallery;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import com.udelphi.slotreader.Adapters.GallerySizeAdapter;
import com.udelphi.slotreader.Adapters.LanguagesAdapter;
import com.udelphi.slotreader.Adapters.MenuAdapter;
import com.udelphi.slotreader.Fragments.DictionaryFragment;
import com.udelphi.slotreader.Fragments.ReaderFragment;
import com.udelphi.slotreader.Interfaces.BoardSkinChangedListener;
import com.udelphi.slotreader.Interfaces.SizeChangedListener;
import com.udelphi.slotreader.Model.JsonHelper;
import com.udelphi.slotreader.StaticClasses.ScreenController;
import com.udelphi.slotreader.StaticClasses.ScreenController.ScreenModes;

import org.json.JSONException;

import java.io.IOException;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements View.OnClickListener,
 DrawerLayout.DrawerListener, AdapterView.OnItemSelectedListener{
    private JsonHelper jsonHelper;
    private DrawerLayout drawerLayout;
    private ArrayAdapter<String> menuAdapter;
    private ArrayAdapter<String> skinsAdapter;
    private ArrayAdapter<String> languagesAdapter;
    private AdapterView.OnItemClickListener menuClickListener;
    private AdapterView.OnItemClickListener languageClickListener;
    private AdapterView.OnItemClickListener skinsClickListener;
    private ArrayList<SizeChangedListener> sizeChangedListeners;
    private ArrayList<BoardSkinChangedListener> boardSkinChangedListeners;

    private boolean isDrawerOpened;
    private boolean isSubmenuOpened;
    private int boardSkinPosition;
    private int lettersCount;

    private ListView drawerList;
    private EditText input;
    private Gallery gallery;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        sizeChangedListeners = new ArrayList<>();
        boardSkinChangedListeners = new ArrayList<>();
        boardSkinPosition = 1;
        lettersCount = 1;

        try {
            jsonHelper = new JsonHelper(getApplicationContext(), "slot_reader_source", "languages",
                    "charactersCount", "words");
        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }

        gallery = (Gallery)findViewById(R.id.size_switch);
        assert gallery != null;
        gallery.setAdapter(new GallerySizeAdapter(getApplicationContext()));
        gallery.setOnItemSelectedListener(this);
        gallery.setUnselectedAlpha(0.3f);
        input = (EditText) findViewById(R.id.input);

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
                        Fragment homeFrag = getSupportFragmentManager().findFragmentByTag(ReaderFragment.TAG);
                        if(homeFrag == null) {
                            homeFrag = ReaderFragment.newInstance(boardSkinPosition, lettersCount);
                            sizeChangedListeners.add((SizeChangedListener)homeFrag);
                            boardSkinChangedListeners.add((BoardSkinChangedListener)homeFrag);
                        }
                        changeFragment(homeFrag);
                        drawerList.setItemChecked(position, true);
                        drawerLayout.closeDrawer(drawerList);
                        break;
                    case 1:
                        drawerList.setAdapter(skinsAdapter);
                        drawerList.setOnItemClickListener(skinsClickListener);
                        isSubmenuOpened = true;
                        break;
                    case 2:
                        Fragment dictFrag = getSupportFragmentManager().findFragmentByTag(DictionaryFragment.TAG);
                        if(dictFrag == null) {
                            dictFrag = DictionaryFragment.newInstance(boardSkinPosition);
                            sizeChangedListeners.add((SizeChangedListener)dictFrag);
                            boardSkinChangedListeners.add((BoardSkinChangedListener)dictFrag);
                        }
                        changeFragment(dictFrag);
                        drawerList.setItemChecked(position, true);
                        drawerLayout.closeDrawer(drawerList);
                        break;
                    case 3:
                        drawerList.setAdapter(languagesAdapter);
                        drawerList.setOnItemClickListener(languageClickListener);
                        isSubmenuOpened = true;
                        break;
                }
            }
        };
        skinsClickListener = new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                for(BoardSkinChangedListener listener : boardSkinChangedListeners)
                    listener.onBoardSkinChanged(position);
                drawerLayout.closeDrawer(drawerList);
                drawerList.setAdapter(menuAdapter);
                drawerList.setOnItemClickListener(menuClickListener);
                boardSkinPosition = position;
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
    }

    @Override
    protected void onResume() {
        super.onResume();
        ScreenController.setScreenMode(this, ScreenModes.FULL_SCREEN);
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
        if(isDrawerOpened && isSubmenuOpened) {
            drawerList.setAdapter(menuAdapter);
            drawerList.setOnItemClickListener(menuClickListener);
            isSubmenuOpened = false;
        }
        else if(isDrawerOpened && !isSubmenuOpened)
            drawerLayout.closeDrawer(drawerList);
        else
            super.onBackPressed();
    }

    @Override
    public void onDrawerSlide(View drawerView, float slideOffset) {

    }

    @Override
    public void onDrawerOpened(View drawerView) {
        ScreenController.setScreenMode(this, ScreenModes.NAVIGATION_VISIBLE);
        isDrawerOpened = true;
    }

    @Override
    public void onDrawerClosed(View drawerView) {
        ScreenController.setScreenMode(this, ScreenModes.FULL_SCREEN);
        drawerList.setAdapter(menuAdapter);
        isDrawerOpened = false;
    }

    @Override
    public void onDrawerStateChanged(int newState) {

    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        int value;
        String valueStr = ((TextView) view).getText().toString();
        jsonHelper.setWordSizeIndex(position);
        try {
            value = Integer.valueOf(valueStr);
            notifySizeChangedListeners(value);
        } catch (NumberFormatException ignored) {
            value = Integer.valueOf(valueStr.substring(0, valueStr.length() - 1));
            notifySizeChangedListeners(value);
        }
        lettersCount = value;
    }

    public JsonHelper getJsonHelper(){
        return this.jsonHelper;
    }

    public void initInput(TextView.OnEditorActionListener listener){
        gallery.setVisibility(View.INVISIBLE);
        input.setVisibility(View.VISIBLE);
        input.setFocusableInTouchMode(true);
        input.requestFocus();
        ((InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE))
                .showSoftInput(input, 0);
        input.setOnEditorActionListener(listener);
    }

    public void showGallery(){
        input.setVisibility(View.GONE);
        gallery.setVisibility(View.VISIBLE);
    }

    private void changeFragment(Fragment fragment){
        if(fragment != null){
            getSupportFragmentManager().beginTransaction()
                    .replace(R.id.content_frame, fragment, fragment.getTag())
                    .commit();
        }
    }

    private void notifySizeChangedListeners(int size){
        for(SizeChangedListener listener : sizeChangedListeners)
            listener.onSizeChanged(size);
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {

    }
}
