Manages `TERMINFO` files that add escape sequences for italic,
and overwrite conflicting sequences for standout text.

Graciously borrowed from [wincent/wincent](https://github.com/wincent/wincent/tree/master/aspects/terminfo)

To check that the terminal does the right thing:

```sh
echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`
```
