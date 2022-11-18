if [[ $OSTYPE == 'darwin'* ]]; then
    export LDFLAGS="-L/usr/local/opt/readline/lib"
    export CPPFLAGS="-I/usr/local/opt/readline/include"
    export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
fi
