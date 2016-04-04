package com.udelphi.slotreader.Model;
import android.content.Context;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;

public class JsonHelper {
    private JSONArray languages;
    private JSONArray wordSizes;
    private JSONArray words;
    private JSONObject words_json;
    private String curWordArrStr;
    private int language_index;
    private int word_size_index = 1;
    private int word_index = 0;

    public JsonHelper(Context context, String sourceFileName, String languagesTag,
                      String wordSizesTag, String wordsTag) throws IOException, JSONException {
        JSONObject all_data_json = readJsonFormAssets(context, sourceFileName);
        this.curWordArrStr = "en1";
        this.words_json = new JSONObject(all_data_json.getString(wordsTag));
        this.languages = all_data_json.getJSONArray(languagesTag);
        this.wordSizes = all_data_json.getJSONArray(wordSizesTag);
        this.words = words_json.getJSONArray(curWordArrStr);
        this.language_index = getLanguageIndex(context.getResources().getConfiguration().locale.getLanguage());
        this.language_index = language_index > -1 ? language_index : getLanguageIndex("en");
    }

    public Boolean hasWord(String word){
        return  words.toString().contains(word.toLowerCase());
    }

    public String getLanguage(int index) throws JSONException {
        return  languages.getString(index);
    }

    public int getLanguageIndex(String languageName) throws JSONException{
        for(int i = 0; i < languages.length(); i++)
            if(getLanguage(i).equals(languageName))
                return  i;
        return -1;
    }

    public void setLanguage(int language_index){
        this.language_index = language_index;
        this.word_index = 0;
    }

    public void setWordSizeIndex(int word_size_index){
        this.word_size_index = word_size_index;
        this.word_index = 0;
    }

    public void setCurrentWord(String word) {
        for(int i = 0; i < words.length(); i++) {
            try {
                if (words.getString(i).equals(word)) {
                    word_index = i;
                    return;
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    public String getCurrentWord() {
        try {
            updateWords(getLanguage(language_index), wordSizes.getString(word_size_index));
            return words.getString(word_index);
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getNextWord() {
        if(word_index + 1 < words.length())
            word_index++;
        else if(word_index + 1 == words.length())
            word_index = 0;
        else word_index = words.length() - 1;
        try {
            updateWords(getLanguage(language_index), wordSizes.getString(word_size_index));
            return words.getString(word_index);
        } catch (JSONException e) {
            e.printStackTrace();
            return getPreviousWord();
        }
    }

    public String getPreviousWord(){
        if(word_index - 1 < words.length())
           word_index--;
        else if(word_index - 1 == 0)
            word_index = words.length() - 1;
        else
            word_index = 0;
        try {
            updateWords(getLanguage(language_index), wordSizes.getString(word_size_index));
            return words.getString(word_index);
        } catch (JSONException e) {
            e.printStackTrace();
            return getNextWord();
        }
    }

    public String[] getAlphabet(){
        try {
            JSONArray jsonAlphabet = words_json.getJSONArray(getLanguage(language_index) + 1);
            String[] result = new String[jsonAlphabet.length()];
            for(int i = 0; i < jsonAlphabet.length(); i++)
                result[i] = jsonAlphabet.getString(i);
            return result;
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    private JSONObject readJsonFormAssets(Context context, String sourceFileName)
            throws JSONException, IOException{
        InputStream input = context.getAssets().open(sourceFileName);
        int size = input.available();
        byte[] buffer = new byte[size];
        input.read(buffer);
        input.close();
        return new JSONObject(new String(buffer, "UTF-8"));
    }

    private void updateWords(String language, String wordSize) throws JSONException {
        if(!curWordArrStr.equals(language + wordSize)){
            curWordArrStr = language + wordSize;
            words = words_json.getJSONArray(curWordArrStr);
        }
    }
}

