# Emscripten

## Build

```
mkdir build
cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DLIRI_DATA_DIR=data/
emmake make
```

## Link

```
em++ -flto -O3 -fno-exceptions -fno-rtti *.o -o index.html -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","mod"]' -sASYNCIFY -sASYNCIFY_IGNORE_INDIRECT -sASYNCIFY_ONLY=@../../../../funcs.txt --preload-file ../../../../data/@data/ --preload-file ../../../../Sounds/@Sounds/ -sENVIRONMENT=web -sEXPORTED_RUNTIME_METHODS=['allocate'] --closure 1 -sINITIAL_HEAP=32mb
```
