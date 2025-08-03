import os

build_command = 'flutter packages pub run build_runner build --delete-conflicting-outputs'

## splash screen command
# build_command = 'flutter pub run flutter_native_splash:create'

## launcher icon command
# build_command = 'flutter pub run flutter_launcher_icons'
os.system(build_command)