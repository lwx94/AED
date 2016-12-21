@echo off
set work_path=G:\School\thesis\DS4_T\
G:
cd G:\School\thesis\DS4_T\
for /R %work_path% %%s in (*.mp4) do (
echo %%s
G:\School\thesis\ffmpeg-20161130-4e6d1c1-win64-static\ffmpeg-20161130-4e6d1c1-win64-static\bin\ffmpeg.exe -i "%%s" "%%s.wav"
)
pause