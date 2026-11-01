![advcpmv](https://web.archive.org/web/20131217004029im_/http://beatex.org/web/advcopy/advcpmv-screen-20130313.png)

## Advanced Copy

Advanced Copy is a mod for the GNU cp and GNU mv tools which adds a progress bar and provides some info on what's going on. It was written by Florian Zwicke and released under the GPL.

This repository exists because the [Advanced Copy](http://beatex.org/web/advancedcopy.html) website appears to be dead. You can still find it via the [Internet Archive](https://web.archive.org/web/20131115171331/http://beatex.org/web/advancedcopy.html).

advcpmv-0.5-8.21.patch was the last patch released by the author (on February 14, 2013). Patches for newer releases are maintained in this project. Feel free to raise PRs for the most recent releases.

<a href="https://github.com/sponsors/jarun" target="_blank"><img src="https://img.shields.io/badge/sponsor-advcpmv-deeppink.svg" alt="GitHub Sponsors"></a>

## Build instructions

Requires the following dependencies:

- patch
- gcc

Run the following command to download, patch, compile coreutils and generate the files: `./advcpmv/advcp` and `./advcpmv/advmv`.

Bash:

```
curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh && (cd advcpmv && sh install.sh)
```

Fish:

```
curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh; and begin; cd advcpmv; and sh install.sh; end
```

To install an older version than the latest one, you can specify the version by passing it as an argument to the install script (at the end of the command, before the closing parenthesis). For example, if you want to install `advcpmv-0.8-8.32.patch` you would modify the command above like so.

```
... sh install.sh 0.8 8.32 ...
```

Alternatively, if you have already cloned this repository, you can run `install.sh` with the path to one of the patch files as the only argument, and it will infer the advcpmv and coreutils versions from the filename.

```
sh install.sh advcpmv-0.8-8.32.patch
```

## Usage

### Copy the binaries in `$PATH`

Copy the binaries and use `cpg -g` and `mvg -g` instead of cp and mv:

```
sudo mv ./advcpmv/advcp /usr/local/bin/cpg
sudo mv ./advcpmv/advmv /usr/local/bin/mvg
```

Progress bar does not work with reflink (introduced v9.0 onwards). So reflink is disabled if using progress bar, left unchanged otherwise.

### Alias

You can install the binaries and create aliases for bash (or whatever you use)

```
sudo mv ./advcpmv/advcp /usr/local/bin/
sudo mv ./advcpmv/advmv /usr/local/bin/
```

Bash:

```
echo -e 'alias cp=\x27/usr/local/bin/cpg -g\x27' >> ~/.bashrc
echo -e 'alias mv=\x27/usr/local/bin/mvg -g\x27' >> ~/.bashrc
```

Fish:

```
echo "alias cp '/usr/local/bin/advcp -g'" >> ~/.config/fish/config.fish
echo "alias mv '/usr/local/bin/advmv -g'" >> ~/.config/fish/config.fish
```

### Function

The following functions work in Bash, Zsh, Ksh, Dash, and other POSIX-compatible shells. They keep the system `cp` and `mv` as the default and use Advanced Copy only when called with `-g`:

```
cp() {
	if [ "$1" = "-g" ]; then
		shift
		/usr/local/bin/advcp -g "$@"
	else
		command cp "$@"
	fi
}

mv() {
	if [ "$1" = "-g" ]; then
		shift
		/usr/local/bin/advmv -g "$@"
	else
		command mv "$@"
	fi
}
```

Fish does not support this function syntax; use the Fish aliases above instead.

```
## Upstream merge

The original author sent the patch to the team, that maintains the GNU CoreUtils. They won't merge this patch, because mv and cp are feature complete.
```
