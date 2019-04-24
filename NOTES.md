Wishlist
========

Things that would be nice but aren't currently planned.

## lib/compiler/optimize.fs

Compiling words to native along with elimination of stack use. Allocation of
registers is to be done via tracing the call flow graph constructed by forth
words. Handling of of an unknown number of items will yield stack code and exit
must push any remaining live items onto the stack before entering the next word.

## lib/data/{xml.fs,json.fs,sxml.fs,toml.fs,yaml.fs}

Parsers for DAG text formats.

## lib/graphics/opengl.fs

Bindings for OpenGL.

## lib/graphics/x11.fs

Words for interaction with the X11 protocol.

## lib/audio/openal.fs

## lib/audio/fft.fs

## games/io.md

Space exploration game.

### Mechanics

* Projectiles - range limited by arc, damage by velocity
* Fire - burns until fuel depleted, spreads via objects
* View - top down with items within a 360 camera fov shown if lights are on

### Audio

```
((x-4|t>>8)+3)|x+4
```

### UI

Stats screen

```
                       ___   __100%_ helmet
                     ,'   ',/
                     :     :
                      \   /
shoulders _20%__    ,-'   '-,
                \ ,'         ',
                  : :       : :          OXYGEN ██████████████▌   ▏
                  : :       : :          HEALTH ██████████▌       ▏
      chest _74%______      : :          HUNGER █████████████████▌▏
                  : :       : :          BATT   ██████▌           ▏
                  : :       : :          RADI   █▌                ▏
                  : '       ' :
                  '-:   :   :-'                        _________,__
     arms _100%__/  :   :   :  __45%_ knees   --------/     --- ___\
                    :   :   : /               |__,''', ,-__,,--/_;
                    ::  :  ::                       /_/  |__|      \__90%_ light
                    :   :   :
                    :   :   :            rounds _73/300__/
                    :   :   :
                     '--'--'
                            \__50%_ legs
```

Pause screen

```
▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄
██  ██ ██  ██ ██  ██ ██     ██     ██   █
██▄▄██ ██▄▄██ ██  ██ ██▄▄▄▄ ██▄▄▄▄ ██   █
██     ██  ██ ██  ██     ██ ██     ██   █
▄▄     ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄
```

Menu screen

```
▄▄▄  ▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄
██▀██▀██ ██     ██   █ ██  ██
██    ██ ██▄▄▄▄ ██   █ ██  ██
██    ██ ██     ██   █ ██  ██
▄▄    ▄▄ ▄▄▄▄▄▄ ▄▄   ▄ ▄▄▄▄▄▄
```

### Graphics

Misc characters

```
shade : ░ ▒ ▓
blocks: ▟ ▞ ▝ ▜ ▛ ▚ ▙ ▘ ▗ ▖ ▀ ▄
steps : █ ▇ ▆ ▅ ▄ ▃ ▂ ▁
bar   : █ ▉ ▊ ▋ ▌ ▍ ▎ ▏
ascii : !"#$%&'()*+,-./0123456789:;<=>?@
        ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`
        abcdefghijklmnopqrstuvwxyz{|}~
box   : ─│┌┐└┘├┤┬┴┼
geom  : ◯◜◝◞◟◠◡□■◁△▷▽◆◇◌●
brack : ❨ ❩ ❪ ❫ ❬ ❭ ❮ ❯ ❰ ❱ ❲ ❳ ❴ ❵
```

#### Example art (animation)

Title

```
▄▄▄▄ ▄▄▄▄▄▄
 ██  ██  ██
 ██  ██  ██
 ██  ██  ██
▄▄▄▄ ▄▄▄▄▄▄

▄▄▄▄ ▄▄▄▄▄▄
 ██  ██  ██
 ▄█▀ ▄█▀ ▄█▀
 ▀█▄ ▀█▄ ▀█▄
▄▄▄▄ ▄▄▄▄▄▄
```

Spinners

```
❰ ◜ loading ... ❱
❰ ◝ loading ... ❱
❰ ◟ loading ... ❱
❰ ◞ loading ... ❱
❰ ◯ complete    ❱
```
  ❱

Bars

```
OXYGEN ██████████████████▏
OXYGEN █████████████████▉▏
OXYGEN █████████████████▊▏
OXYGEN █████████████████▌▏
OXYGEN █████████████████▍▏
OXYGEN █████████████████▏▏
```

Notifications

```
        ❰ ❱
       ❰ I ❱
      ❰  IN ❱
     ❰ M INA ❱
    ❰ EM INAC ❱
   ❰ TEM INACT ❱
  ❰ STEM INACTI ❱
 ❰ YSTEM INACTIV ❱
❰ SYSTEM INACTIVE ❱
 ❰ YSTEM INACTIV ❱
  ❰ STEM INACTI ❱
   ❰ TEM INACT ❱
    ❰ EM INAC ❱
     ❰ M INA ❱
      ❰  IN ❱
       ❰ I ❱
        ❰ ❱

```

## games/levy.md

Adventure game.

### Unicode/ASCII art

Levy

```
┌───┬───┐
│ L │ E │ V   Y
└───┴───┘
```

Minerva

```
┌───┬───┐
│ M │ I │ N   E   R   V   A
└───┴───┘
```

vim: et
