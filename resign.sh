IPA=$1
MOBILE_PROVISION=$2
CERT_NAME=$3

if [ $# -eq 0 ]; then
    echo "ERROR!! ./resign.sh XXX.ipa YYYY.mobileprovision "iPhone Distribution: ZZZZZ""
    exit
fi

pushd $(dirname $IPA)

rm -rf Payload

#extract the IPA
unzip $IPA
APP_NAME=$(ls Payload)

#remove useless stuff
rm -rf "Payload/$APP_NAME/_CodeSignature" "Payload/$APP_NAME/CodeResources"

#replace the mobile provision
cp $MOBILE_PROVISION "Payload/$APP_NAME/embedded.mobileprovision"

#code signing
codesign -f -s "$CERT_NAME" "Payload/$APP_NAME"

#pack the IPA
zip -qr "${IPA}_$(date +%s)" Payload

#remove the Payload
rm -rf Payload

popd
