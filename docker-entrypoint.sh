#!/usr/bin/env bash

twilio plugins:update

echo "y" | \
twilio login "$TWILIO_ACCOUNT_SID" \
  --force \
  --auth-token "$TWILIO_AUTH_TOKEN" \
  --profile "upfit.ai" \
  --region "IE1" \
  --silent

twilio profiles:use upfit.ai
twilio profiles:list

echo 'y' | npx browserslist@latest --update-db
npm run deploy:twilio-cli -- --override
REACT_APP_SET_AUTH=passcode npm run build && twilio rtc:apps:video:deploy --authentication=passcode --app-directory ./build
twilio rtc:apps:video:view
# twilio rtc:apps:video:delete

exec "$@"
