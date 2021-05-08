export SCRIPTS="${HOME}/.bin"

pathappend() {
	for ARG in "$@"; do
		test -d "${ARG}" || continue
		case ":${PATH}:" in
		*:${ARG}:*) continue ;;
		esac
		export PATH="${PATH:+"${PATH}:"}${ARG}"
	done
}

pathprepend() {
	for ARG in "$@"; do
		test -d "${ARG}" || continue
		case ":${PATH}:" in
		*:${ARG}:*) continue ;;
		esac
		export PATH="${ARG}${PATH:+":${PATH}"}"
	done
}

cdpathappend() {
	for ARG in "$@"; do
		test -d "${ARG}" || continue
		case ":${CDPATH}:" in
		*:${ARG}:*) continue ;;
		esac
		export CDPATH="${CDPATH:+"${CDPATH}:"}${ARG}"
	done
}

cdpathprepend() {
	for ARG in "$@"; do
		test -d "${ARG}" || continue
		case ":${CDPATH}:" in
		*:${ARG}:*) continue ;;
		esac
		export CDPATH="${ARG}${CDPATH:+":${CDPATH}"}"
	done
}

pathprepend \
	"${SCRIPTS}" \
	"${HOME}/.local/bin" \
	"${HOME}/.cargo/bin" \
	"${HOME}/.node/bin" \
  "${HOME}/go/bin" \
	"${HOME}/bin"

pathappend \
	"/usr/local/opt/coreutils/libexec/gnubin" \
	"/usr/local/bin" \
	"/usr/local/sbin" \
	"/usr/sbin" \
	"/usr/bin" \
	"/sbin" \
	"/bin"

cdpathprepend "./"
if test -n "${HOME}/code"; then
  cdpathappend "${HOME}/code"
  cdpathappend "$HOME"
  cdpathappend "${HOME}/.config"
fi
