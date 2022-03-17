**| English | [简体中文](README.md) | <a href="#" title="Corresponding documentation is temporarily unavailable.">繁體中文</a> |**

# Video Downloaders One-Click Deployment Batch (Windows)

![language](https://img.shields.io/badge/language-batchfile-c1f12e)
![platform](https://img.shields.io/badge/platform-Windows_7/8/10;_32/64--bit-brightgreen?logo=windows)
![GitHub repo size](https://img.shields.io/github/repo-size/LussacZheng/video-downloader-deploy?logo=github)
![version](https://img.shields.io/github/package-json/v/LussacZheng/video-downloader-deploy_info?color=important)

A One-Click batch script for the deployment and quickstart of **[You-Get][you-get] , [Youtube-dl][youtube-dl] , [Lux][lux] , and [FFmpeg][ffmpeg]** .

- No need to install Python, one-click to deploy a portable version of you-get, youtube-dl.
- This portable deployment is based on the embeddable version of Python.
- Besides one-click deployment, the upgrades of you-get, youtube-dl, lux in the future can also be carried out with one-click.

## Getting Started

Download [One-Click Deployment Batch](https://github.com/LussacZheng/video-downloader-deploy/archive/master.zip) . Unzip and run `Deploy.bat` .

Demo.gif ( 2 min 52 s ) :  
![demo.gif](https://s2.ax1x.com/2019/08/17/muTbIs.gif)

*This demo was recorded in Simplified Chinese. If your system language is not Chinese, this batch will automatically display in English.*  
*Please [create a new issue](https://github.com/LussacZheng/video-downloader-deploy/issues) if you want to help improve the translation quality or add more supported languages.*

### Note

- For the folder where `Deploy.bat` is located,
  - You can only move or rename the entire folder as a whole. The name of this folder or the file path should NOT contains special punctuation like: `!@$;%^&` ;
  - After the deployment, you can delete all the files downloaded in directory `res\download\` , to save storage;
  - Except the video files downloaded under the `Download\` directory, please do NOT change other files inside.
- If the batch has a run-time error (such as download speed is too slow), please refer to [FAQ](https://github.com/LussacZheng/video-downloader-deploy/wiki/FAQ) or [Submit new issue](https://github.com/LussacZheng/video-downloader-deploy/issues) .

### FFmpeg

> The absence of FFmpeg will affect the merging of multiple-parts videos, but has nothing to do with the downloading of videos.

This portable version does NOT deploy FFmpeg by default. To deploy FFmpeg, re-run `Deploy.bat` and select `Deploy FFmpeg`.

### alias

Run `Deploy.bat` and select `Aliases Management` to add customize aliases.

> Before adding a custom alias, please try `Import default alias`. Then start the `Download_Video.bat`, input `open` and ENTER.

Take several aliases, which might be commonly used, as examples and references:

| Alias                                    | Function                                                           |
| :--------------------------------------- | :----------------------------------------------------------------- |
| open = `explorer .\`                     | Open the current directory, which is `Download\`                   |
| proxy &asymp; `set HTTP(S)_PROXY=...`    | Quickly enable/disable proxy for current CMD window (`proxy help`) |
| yb = `youtube-dl -f bestvideo+bestaudio` | Use youtube-dl to download the video of best quality               |
| yf = `youtube-dl -F`                     | Use youtube-dl to list all available formats of requested videos   |
| lc = `lux -c cookies.txt`              | Use lux to download, with cookies loaded                         |
| ygc = `you-get -c cookies.txt`           | Use you-get to download, with cookies loaded                       |
| ...                                      | ...                                                                |

**Notice**: The name of customize alias is preferably a combination of letters, numbers, dashes and/or underscores. It should match the RegExp `^[\w\-]+$`, and particularly no whitespace or the special punctuations mentioned above. In addition, the alias must NOT be the same as the command, otherwise it will cause an endless loop.

---

## Others

### Git

If you have installed [Git](https://git-scm.com/), it is recommended to get the scripts through `git clone` . So that you can get updates through `git pull` in the future.

```shell
git clone https://github.com/LussacZheng/video-downloader-deploy.git
```

Only if you previously got the scripts through `git clone`, you can update through `git pull`.

```shell
git pull
```

### Source

- `7za.exe`
  
  ```
  Version:    v19.00
  MD5:        43141e85e7c36e31b52b22ab94d5e574
  Source:     https://sourceforge.net/projects/sevenzip/files/7-Zip/19.00/
  From:       "7z1900-extra.7z" \7za.exe
  ```

- `wget.exe`

  ```
  Version:    v1.20.3 , win32
  MD5:        f8247397ae65792524d949c825969391
  Source:     http://www.gnu.org/software/wget/faq.html#download
              https://eternallybored.org/misc/wget/
  From:       "wget-1.20.3-win32.zip" \wget.exe
  ```

- `get-pip.py`

  ```
  Version:    v19.2.2 (pip for bootstrap)
  MD5:        7f66b79bf181521f6851a75848aad8b2
  Source:     https://bootstrap.pypa.io/get-pip.py
  ```

### License

|            Project             |                 License                 |
| :----------------------------: | :-------------------------------------: |
|       [you-get][you-get]       |     [MIT License][you-get license]      |
|    [youtube-dl][youtube-dl]    |   [The Unlicense][youtube-dl license]   |
|         [lux][lux]         |      [MIT License][lux license]       |
| [FFmpeg Builds][ffmpeg builds] |    [GPL 3.0][ffmpeg builds license]     |
|        [Python][python]        | [PSF LICENSE AGREEMENT][python license] |

### More information

Check [Wiki](https://github.com/LussacZheng/video-downloader-deploy/wiki) for more information.

<!-- Reference Links -->

[you-get]: https://github.com/soimort/you-get
[you-get license]: https://github.com/soimort/you-get/blob/develop/LICENSE.txt
[youtube-dl]: https://github.com/ytdl-org/youtube-dl
[youtube-dl license]: https://github.com/ytdl-org/youtube-dl/blob/master/LICENSE
[lux]: https://github.com/iawia002/lux
[lux license]: https://github.com/iawia002/lux/blob/master/LICENSE
[ffmpeg]: https://ffmpeg.org
[ffmpeg builds]: https://ffmpeg.zeranoe.com/builds/
[ffmpeg builds license]: http://www.gnu.org/licenses/gpl-3.0.html
[python]: https://www.python.org
[python license]: https://docs.python.org/3.7/license.html#terms-and-conditions-for-accessing-or-otherwise-using-python
