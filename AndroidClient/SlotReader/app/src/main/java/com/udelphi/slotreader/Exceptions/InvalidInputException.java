package com.udelphi.slotreader.Exceptions;

public class InvalidInputException extends Exception{
    String invalidSymbol;

    public InvalidInputException(String invalidSymbol){
        this.invalidSymbol = invalidSymbol.equals(" ")? "'space'" : invalidSymbol;
    }

    public String getInvalidSymbol() {
        return invalidSymbol;
    }
}
