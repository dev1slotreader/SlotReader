package com.udelphi.slotreader.Controlls;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.widget.EditText;

import com.udelphi.slotreader.Interfaces.OnInputCanceledListener;
import com.udelphi.slotreader.R;
import com.udelphi.slotreader.StaticClasses.ScreenController;

public class BackHandlerEditText extends EditText {
    private String word;
    private OnInputCanceledListener canceledListener;

    public BackHandlerEditText(Context context) {
        this(context, null);
    }
    public BackHandlerEditText(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }
    public BackHandlerEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void setOnInputCancelListener(OnInputCanceledListener cancelListener){
        this.canceledListener = cancelListener;
    }

    @Override
    public void setText(CharSequence text, BufferType type) {
        super.setText(text, type);
        word = text.toString();
    }

    @Override
    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK &&
                event.getAction() == KeyEvent.ACTION_UP) {
            Activity activity = null;
            Context context = getContext();
            while (context instanceof ContextWrapper) {
                if (context instanceof Activity) {
                    activity = (Activity)context;
                }
                context = ((ContextWrapper)context).getBaseContext();
            }
            ScreenController.setScreenMode(activity, ScreenController.ScreenModes.FULL_SCREEN);
            if(getId() == R.id.new_word_input) {
                setText("");
                setVisibility(GONE);
            }
            else {
                setText(word);
                if(canceledListener != null)
                canceledListener.onInputCanceled(this);
            }
        }
        return super.dispatchKeyEvent(event);
    }
}
