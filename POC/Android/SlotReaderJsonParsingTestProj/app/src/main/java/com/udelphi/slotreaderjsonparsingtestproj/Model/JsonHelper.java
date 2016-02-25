package com.udelphi.slotreaderjsonparsingtestproj.Model;
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

    public JsonHelper(Context context, String sourceFileName, String languagesTag,
                      String wordSizesTag, String wordsTag) throws IOException, JSONException {
        JSONObject all_data_json = readJsonFormAssets(context, sourceFileName);
        this.curWordArrStr = "en1";
        this.words_json = new JSONObject(all_data_json.getString(wordsTag));
        this.languages = all_data_json.getJSONArray(languagesTag);
        this.wordSizes = all_data_json.getJSONArray(wordSizesTag);
        this.words = words_json.getJSONArray(curWordArrStr);
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

    public String getLanguage(int index) throws JSONException {
        return  languages.getString(index);
    }
    public  int getLanguagesLastIndex(){
        return languages.length() - 1;
    }

    public int getWordSize(int index) throws JSONException {
        return  wordSizes.getInt(index);
    }
    public  int getWordSizesLastIndex(){
        return wordSizes.length() - 1;
    }

    public String getWord(int index, String language, String wordSize) throws JSONException {
        if(!curWordArrStr.equals(language + wordSize)){
            curWordArrStr = language + wordSize;
            words = words_json.getJSONArray(curWordArrStr);
        }
        return  words.getString(index);
    }
    public int getWordsLastIndex(){
        return words.length() - 1;
    }
}

