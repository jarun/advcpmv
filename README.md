![advcpmv](https://web.archive.org/web/20131217004029im_/http://beatex.org/web/advcopy/advcpmv-screen-20130313.png)

## Advanced Copy ##

Advanced Copy is a mod for the GNU cp and GNU mv tools which adds a progress bar and provides some info on what's going on. It was written by Florian Zwicke and released under the GPL.

This repository exists because the [Advanced Copy](http://beatex.org/web/advancedcopy.html) website appears to be dead. You can still find it via the [Internet Archive](https://web.archive.org/web/20131115171331/http://beatex.org/web/advancedcopy.html).

advcpmv-0.5-8.21.patch was the last patch released by the author (on February 14, 2013). advcpmv-0.6-8.24.patch (and following) are simply a rebase of that on top of the 8.24 version of coreutils.

## Build instructions

Run the following command to download, patch, compile coreutils and generate the files: `./advcpmv/advcp` and `./advcpmv/advmv`.

```
curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh && (cd advcpmv && sh install.sh)
```

To install an older version than the latest one, you can specify the version by passing it as an argument to the install script (at the end of the command, before the closing parenthesis). For example, if you want to install `advcpmv-0.8-8.32.patch` you would modify the command above like so.

```
... && (cd advcpmv && sh install.sh 0.8 8.32)
```

## Usage

### Change your behaviour

You can install the binaries and use `cpg -g` and `mvg -g` instead of cp and mv:

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
echo alias cp '/usr/local/bin/advcp -g' >> ~/.bashrc
echo alias mv '/usr/local/bin/advmv -g' >> ~/.bashrc
```

## Upstream merge

The original author sent the patch to the team, that maintains the GNU CoreUtils. They won't merge this patch, because mv and cp are feature complete.
