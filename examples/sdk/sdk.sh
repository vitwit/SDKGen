curl https://vitwit.com/api/api-doc.json -o /home/sys-597/work/vitwit/js-sdkgen/examples/swagger.json && js-sdkgen --json-file /home/sys-597/work/vitwit/js-sdkgen/examples/swagger.json --name MySDK --version 1.0.0 --base-url https://vitwit.com/api --required-headers a,b,c --optional-headers d,e,f 