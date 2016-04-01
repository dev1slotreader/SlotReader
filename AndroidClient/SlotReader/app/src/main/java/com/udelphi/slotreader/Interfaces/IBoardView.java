package com.udelphi.slotreader.Interfaces;

import com.udelphi.slotreader.Exceptions.InvalidInputException;

public interface IBoardView {
    void setValues(String[] values);
    void showWord(String word);
    void showWordImmediately(String word);
    String readWord();
    void addLetter();
    void removeLetter();
    void setLettersCount(int count);
    void setMovingListener(MovingListener movingListener);

    interface MovingListener{
        void onMovingStarted();
        void onMovingEnded();
    }
}
