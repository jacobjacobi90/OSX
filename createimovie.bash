#!/bin/bash

## cd to PlexConnect directory
cd __INSTALLERPATH__
cd ../..
PlexConnectPath=${PWD}

createplistbash.bash
stopbash.bash
startbash.bash

## check SSL certificate
file="${PlexConnectPath}/assets/certificates/trailers.pem"
if [ -f "$file" ]; then
    echo 'SSL certificate '$file' found. Skipping' 
    echo 'Settings.cfg changed to hijack www.icloud.com'
    echo 'Upload profile to ATV using this url http://www.icloud.com/trailers.cer'
else

## Trailers - hostname is www.icloud.com
## certificate good for 10 years
openssl req -new -nodes -newkey rsa:2048 -out ./assets/certificates/trailers.pem -keyout ./assets/certificates/trailers.key -x509 -days 3650 -subj "/C=US/CN=www.icloud.com"
openssl x509 -in ./assets/certificates/trailers.pem -outform der -out ./assets/certificates/trailers.cer && cat ./assets/certificates/trailers.key >> ./assets/certificates/trailers.pem

echo 'Generating Imovie certs'
echo 'Settings.cfg changed to hijack www.icloud.com'
echo 'Upload profile to ATV using this url http://www.icloud.com/trailers.cer'

fi

while : ; do
    [[ -f "/Applications/PlexConnect/Settings.cfg" ]] && break
    echo "Pausing until file exists."
    sleep 1
done
sed -i '' 's/trailers.apple.com/www.icloud.com/g' Settings.cfg
sed -i '' 's/video-api-secure.wsj.com/www.icloud.com/g' Settings.cfg

restartbash.bash

## Display Settings.cfg
FILE="/Applications/PlexConnect/Settings.cfg"
echo "*** File - $FILE contents ***"
cat $FILE
