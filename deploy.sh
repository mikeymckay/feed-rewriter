#!/usr/bin/bash
coffee -c index.coffee; zip -q -r lambdaFunction.zip .; aws lambda update-function-code --function-name pluralisticBiteSized --zip-file fileb://lambdaFunction.zip
