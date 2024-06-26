# Emscripten

## Build

```
mkdir build
cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DLIRI_DATA_DIR=data/
```

## Link

```
emcc -flto -O3 *.o -o index.html -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","mod"]' -sASYNCIFY --preload-file data/ --preload-file Sounds/ -sINITIAL_MEMORY=128mb -sENVIRONMENT=web --closure 1 -sEXPORTED_RUNTIME_METHODS=['allocate']
```
