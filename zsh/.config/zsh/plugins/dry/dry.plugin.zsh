if [ "$(uname)" = "Darwin" ]; then
	if command -v dry &> /dev/null; then
		dry 0.0166666666667 > /dev/null
	fi
fi
