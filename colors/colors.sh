export COLORSCHEME_NAME="base16"
export COLORSCHEME_TYPE="londontube"
export COLORSCHEME_LIGHT="light"
export COLORSCHEME="$COLORSCHEME_NAME-$COLORSCHEME_TYPE.$COLORSCHEME_LIGHT"
export COLORSCHEME_DIR="/home/meatcar/dots/colors/$COLORSCHEME_NAME/"

ln -sf "$COLORSCHEME_DIR"/vim/"$COLORSCHEME_NAME"-"$COLORSCHEME_TYPE".vim /home/meatcar/.vim/colors/meatcar.vim
