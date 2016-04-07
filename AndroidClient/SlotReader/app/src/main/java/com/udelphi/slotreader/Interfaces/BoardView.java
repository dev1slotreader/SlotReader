package com.udelphi.slotreader.Interfaces;

import android.graphics.drawable.Drawable;

public interface BoardView {
    void setValues(String[] values);
    void showWord(String word);
    void showWordImmediately(String word);
    String readWord();
    void addLetter();
    void removeLetter();
    void setLettersCount(int count);
    void setDivider(Drawable divider);
    void setTextColor(int color);
    void setMovingListener(MovingListener movingListener);

    interface MovingListener{
        void onMovingStarted();
        void onMovingEnded();
    }
}
