package mff.example.application;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;

public class mffEditText extends EditText implements TextWatcher {
    public mffEditText(Context context) {
        super(context);
        // The height comes from the form (SetBounds): no minimum height of the theme (48dp) and a small vertical padding,
        // else the text is cut in a TextBox of the designer height (about 30)
        setMinHeight(0);
        setMinimumHeight(0);
        int dp2 = Math.round(2 * context.getResources().getDisplayMetrics().density);
        setPadding(getPaddingLeft(), dp2, getPaddingRight(), dp2);
        setGravity(android.view.Gravity.CENTER_VERTICAL | android.view.Gravity.START);
    }

    public void afterTextChanged(Editable s) {
    }

    // SearchBox (setSearchLook): the search glass at the start, the clear button at the end while there is a text,
    // like the search input of the Web; a tap on the clear button clears the text (onTextChanged: OnChange)
    boolean searchLook;

    public void setSearchLook() {
        if (searchLook) return;
        searchLook = true;
        setCompoundDrawablePadding(Math.round(4 * getResources().getDisplayMetrics().density));
        addTextChangedListener(new TextWatcher() {
            public void afterTextChanged(Editable s) { updateSearchLook(); }
            public void beforeTextChanged(CharSequence s, int start, int count, int after) { }
            public void onTextChanged(CharSequence s, int start, int before, int count) { }
        });
        updateSearchLook();
    }

    private android.graphics.drawable.Drawable searchIcon(int id) {
        android.graphics.drawable.Drawable d = getResources().getDrawable(id).mutate();
        int size = Math.round(getTextSize() * 1.3f);
        d.setBounds(0, 0, size, size);
        d.setColorFilter(getCurrentHintTextColor(), android.graphics.PorterDuff.Mode.SRC_IN);
        return d;
    }

    void updateSearchLook() {
        setCompoundDrawablesRelative(searchIcon(android.R.drawable.ic_menu_search), null,
            length() > 0 && isEnabled() ? searchIcon(android.R.drawable.ic_menu_close_clear_cancel) : null, null);
    }

    @Override
    public boolean onTouchEvent(android.view.MotionEvent e) {
        if (searchLook && length() > 0 && isEnabled() && getCompoundDrawablesRelative()[2] != null) {
            boolean rtl = getLayoutDirection() == LAYOUT_DIRECTION_RTL;
            boolean onClear = rtl ? e.getX() <= getTotalPaddingLeft() : e.getX() >= getWidth() - getTotalPaddingRight();
            if (onClear) {
                if (e.getActionMasked() == android.view.MotionEvent.ACTION_UP) setText("");
                return true;
            }
        }
        return super.onTouchEvent(e);
    }

    public void beforeTextChanged(CharSequence s, int start, int count,
                                  int after) {
    }

    public native void onTextChanged(CharSequence s, int start, int before, int count);
}
