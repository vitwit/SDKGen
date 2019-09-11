# vGen

vGen is API SDK generator, based on json file generated for api docs by Swagger or Goland or optionally your own json file with any shape with transform function. It can run in both browser(a tool can be made) and node.

```
npm i vwgen -g

vgen jsonFilePath=api-docs.json --isSwagger name=MyApp version=1.0.0

```

Below are parameter available for node cli while generating SDK.

| param          | use                                                                                          | optional or required                                                                                             |
| -------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `jsonFilePath` | path of json                                                                                 | required (if not provided will look for 'api-docs.json' file in current directory)                               |
| `jsFilePath`   | path of a js file which named exports two function `transformJson` and `transformOperations` | not required if json is already in below mentioned format or no operation's response data need to be transformed |
| `--isSwagger`  | pass this flag if json file generated by swagger                                             | required if json generated by swagger                                                                            |
| `--isGo`       | flag to be provided if json file generated using go docs                                     | required if json generated by go docs                                                                            |
| `baseURL`      | base url of your app, will be passed axios instance                                          | required                                                                                                         |
| `name`         | it will be name of generated sdk class                                                       | optional                                                                                                         |
| `version`      | version of sdk                                                                               | optional                                                                                                         |

so basically no command in required if you run following command with puting 'api-docs.json' file in current directory and the json file is in required format than a 'yourSDKName.js' file will be generated in current directory.

```
vwgen
```

any other parameter passed will be added to configs.headers which will be passed to axios instance.

these configs can overridden or more configs can be passed from frontend before intiating the class as below.

```js
SDKName.configs={
baseURL: process.env==='development'?"http:localhost:3000":"https://productionurl.com",
headers:{
  Authorization:getAccessToken();
 }
}
SDKName.getAuthorizationHeader =function(){
 return 'Bearer lkdsjfkladf;jf'
}

const myapp = new SDKName();
export default myapp;
```

Helpful methods or configs available before initialization.

| method                   | use                                                                                     | optional or required |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------------- |
| `configs`                | overide configs                                                                         | optional             |
| `getAuthorizationHeader` | will be called on every request to get authoraztion,can be updated after initialization | required             |

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

| function name                                          | use                                                                                                                             |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- |
| `transformJson`                                        | as mention above it will be called with given json file                                                                         |
|                                                        | will be passed the data coming from backend,                                                                                    |  |
| `transformOperatons`                                   | it should be a object with operationName as methods whichshould returned the desired format(might be helpful when backend might |
| change format but frontend still consuming old format) |
|                                                        |

## Using Generated SDK

any where in your application

```js
import myApp from "./path-of-file";
async function handleSignIn(name, password) {
  const { data, error } = await my.signIn({
    name,
    password
  });
}

async function getUser() {
  const { data, error } = await my.signIn({
    ...otherdata,
    _params: {
      //any query paramater
    },
    _pathParams: {
      userId: "fdkfdslfj" // this key should be same as in path i.e '/users/{userId}'
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
