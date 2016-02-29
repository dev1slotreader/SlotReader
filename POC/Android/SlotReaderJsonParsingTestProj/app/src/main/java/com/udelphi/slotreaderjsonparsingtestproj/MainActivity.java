package com.udelphi.slotreaderjsonparsingtestproj;


import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import org.json.JSONException;

import java.io.IOException;
import java.util.Random;

import com.udelphi.slotreaderjsonparsingtestproj.Model.JsonHelper;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{
    private JsonHelper jsonHelper;

    private TextView wordTv;
    private TextView wordSizeTv;
    private TextView languageTv;

    private int language_index;
    private int word_size_index;
    private int word_index;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        wordSizeTv = (TextView)findViewById(R.id.word_size_tv);
        languageTv = (TextView)findViewById(R.id.language_tv);
        wordTv = (TextView)findViewById(R.id.word_tv);
        wordTv.setOnClickListener(this);
        ImageButton incrementWordSizeBtn = (ImageButton) findViewById(R.id.next_word_size_btn);
        incrementWordSizeBtn.setOnClickListener(this);
        ImageButton decrementWordSizeBtn = (ImageButton) findViewById(R.id.previous_word_size_btn);
        decrementWordSizeBtn.setOnClickListener(this);
        ImageButton previousWordBtn = (ImageButton) findViewById(R.id.previous_word_btn);
        previousWordBtn.setOnClickListener(this);
        ImageButton nextWordBtn = (ImageButton) findViewById(R.id.next_word_btn);
        nextWordBtn.setOnClickListener(this);
        ImageButton previousLanguageBtn = (ImageButton) findViewById(R.id.previous_language_btn);
        previousLanguageBtn.setOnClickListener(this);
        ImageButton nextLanguageBtn = (ImageButton) findViewById(R.id.next_language_btn);
        nextLanguageBtn.setOnClickListener(this);

        word_size_index = 1;
        language_index = 0;
        word_index = 0;

        try {
            jsonHelper = new JsonHelper(getApplicationContext(), "slot_reader_source", "languages",
                    "charactersCount", "words");
            updateLanguage();
            updateWordSize();
            updateWords();
        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClick(View v) {
        try {
            switch (v.getId()){
                case R.id.previous_language_btn:
                    if(language_index == 0)
                        language_index = jsonHelper.getLanguagesLastIndex();
                    else
                        language_index--;
                    updateLanguage();
                    break;
                case R.id.next_language_btn:
                    if(language_index == jsonHelper.getLanguagesLastIndex())
                        language_index = 0;
                    else
                        language_index++;
                    updateLanguage();
                    break;
                case R.id.previous_word_size_btn:
                    if(word_size_index == 0)
                        word_size_index = jsonHelper.getWordSizesLastIndex();
                    else
                        word_size_index--;
                    updateWordSize();
                    break;
                case R.id.word_tv:
                    word_index = new Random().nextInt(jsonHelper.getWordsLastIndex());
                    updateWords();
                break;
                case R.id.next_word_size_btn:
                    if(word_size_index == jsonHelper.getWordSizesLastIndex()){
                        word_size_index = 0;
                    }
                    else
                        word_size_index++;
                    updateWordSize();
                    break;
                case R.id.next_word_btn:
                    if(word_index < jsonHelper.getWordsLastIndex())
                        word_index++;
                    else
                        word_index = 0;
                    updateWords();
                    break;
                case R.id.previous_word_btn:
                    if(word_index > 0)
                        word_index--;
                    else
                        word_index = jsonHelper.getWordsLastIndex();
                    updateWords();
                    break;
            }
        }catch (JSONException e){
            e.printStackTrace();
        }
    }

    private void updateLanguage() throws JSONException{
        languageTv.setText(jsonHelper.getLanguage(language_index));
        updateWords();
    }

    private void updateWordSize() throws JSONException {
        if(jsonHelper.getWordSize(word_size_index) == 0)
            wordSizeTv.setText((jsonHelper.getWordSize(jsonHelper.getWordSizesLastIndex()) + "+"));
        else
            wordSizeTv.setText(String.valueOf(jsonHelper.getWordSize(word_size_index)));
        updateWords();
    }

    private void updateWords() throws JSONException {
        String wordSizeStr = String.valueOf(jsonHelper.getWordSize(word_size_index));
        String language = jsonHelper.getLanguage(language_index);
        try{
            wordTv.setText(jsonHelper.getWord(word_index, language, wordSizeStr));
        }catch (IndexOutOfBoundsException e){
            wordTv.setText(jsonHelper.getWord(jsonHelper.getWordsLastIndex(), language, wordSizeStr));
        }
    }
}

