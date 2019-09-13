# SDKgen

SDKGen is Javascript API SDK Code generator, based on json file generated for api docs by Swagger or Goland or optionally your own json file with any shape with transform function. It just requires a apidoc definition (swagger/godac style supported now) and it generates the Javascript SDK for you. It can run in both browser(a tool can be made) and node.

clone the repo

```sh
git clone https://github.com/vitwit/SDKGen.git
cd SDKGen
npm install
node bin/sdkgen jsonFilePath=api-docs.json --isSwagger/--isGo name=MySDK version=1.0.0 baseUrl=http://google.com --headers accountId=true authorization
```

Below are parameter available for node cli while generating SDK.

| param                                                 | use                                                                                                                                           | optional or required                                                                                             |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `jsonFilePath`                                        | path of json                                                                                                                                  | required (if not provided will look for 'api-docs.json' file in current directory)                               |
| `jsFilePath`                                          | path of a js file which named exports two function `transformJson` and `transformOperations`                                                  | not required if json is already in below mentioned format or no operation's response data need to be transformed |
| `--isSwagger`                                         | pass this flag if json file generated by swagger                                                                                              | required if json generated by swagger                                                                            |
| `--isGo`                                              | flag to be provided if json file generated using go docs                                                                                      | required if json generated by go docs                                                                            |
| `baseUrl`                                             | base url of your app, will be passed axios instance                                                                                           | required                                                                                                         |
| `name`                                                | it will be name of generated sdk class                                                                                                        | optional                                                                                                         |
| `version`                                             | version of sdk                                                                                                                                | optional                                                                                                         |
| `--headers anyoptionalheader anyrequriredheader=true` | after `--headers` flag every will be considered header, if passed true those will be required to pass when initiate the sdk class on frontend |

any other parameter passed will be added to configs.headers which will be passed to axios instance.

these configs can overridden or more configs can be passed from frontend before intiating the class as below.

```js
const myapp = new SDKName();
myapp.setHeader("Authorization", "Bearer fkdsfakfdsfj");
myapp.setBaseUrl("http://localhost/8000");
// you can also get any header value set by you calling getHeader
myapp.getHeader("Authorization");
export { myapp };
```

The json file mentioned above should have following data structure.(make sure you write `operationId` in your node backend inline comments for swagger generated API docs)

```json
[
  {
    "operationName": "createUser",
    "requestMethod": "POST",
    "url": "/users/create",
    "isFormData": "true"
  },
  {
    "operationName": "updateUser",
    "requestMethod": "PUT",
    "url": "/users/{userId}",
    "isFormData": "true"
  }
]
```

If not, you should provide a JavaScript file which will be called with provided json file,
it should return that file in above format.
This JavaScript file can name export these two function.

| function name        | use                                                                                                                                                                                    |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `transformJson`      | as mention above it will be called with given json file                                                                                                                                |
|                      | will be passed the data coming from backend,                                                                                                                                           |  |
| `transformOperatons` | it should be a object with operationName as methods whichshould returned the desired format(might be helpful when backend might change format but frontend still consuming old format) |

## Using Generated SDK

any where in your application you can call sdk methods like this, provide it body data obj while calling, you can pass formdata same as this and it will internally will do `(new FormData).append(key,value)` wherever needed.

```js
import myApp from "./path-of-file";
async function handleSignIn(name, password) {
  const { data, error } = await my.signIn({
    name,
    password
  });
}
```

To pass path params and query params you have `_params` and `-pathParams` that you can pass in same object. They are automatically extracted from other body params. `_pathParams` keys are placeholders in api path i.e for path `orgs/{orgId}/users/{userId}` `orgId` and `userId` are `_pathParams`.

###### note: In your json file of api docs path should follow this same structure for placeholder all others like /orgs/:orgId or orgs/ORGID/ will result in silent errors.

```js
async function getUser() {
  const { data, error } = await my.signIn({
    ...otherdata,
    _params: {
      //any query paramater
    },
    _pathParams: {
      userId: "5ef23df923a3453edfa9ed35fe" // this key should be same as in path i.e '/users/{userId}'
    }
  });
}
```

###### note: It will handle error for you, so you will not get errors in catch block but in response only.

### What's so cool about this?

You don't have to deal with calling API's, managing API constants, handling errors, approriate headers, params,path params etc.
On top of that if backend change data structure of response, they can provide a object `transformOperations` with key as operationName functions which
will take current data structure and provide the previous version for one who opt to use old version.

### What Next

- make a browser tool
- make it generate Reducers for react, handle calling them using action creator internally

```

```
