export COLORSCHEME_DIR="/home/meatcar/dots/colors/templates"
export COLORSCHEME_NAME="base16"
export COLORSCHEME_TYPE="dracula"
export COLORSCHEME_LIGHT="dark"
COLORSCHEME="$COLORSCHEME_NAME-$COLORSCHEME_TYPE.$COLORSCHEME_LIGHT"
if [ -f "$COLORSCHEME_DIR"/shell/scripts/"$COLORSCHEME".sh ]; then
    export COLORSCHEME
else
    export COLORSCHEME="$COLORSCHEME_NAME-$COLORSCHEME_TYPE"
fi

if readlink ~/.vim/colors/meatcar.vim | grep -v -E "$COLORSCHEME.vim$" >/dev/null 2>&1;
then
    ln -sf "$COLORSCHEME_DIR"/vim/colors/"$COLORSCHEME".vim /home/meatcar/.vim/colors/meatcar.vim
fi
