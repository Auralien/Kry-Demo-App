# KRY app code assignment
One of our developers built a simple weather reporting app. The app has a list of locations with weather information. Locations are fetched using a HTTP GET but the server is a bit flakey and sometimes fail. 

Unfortunately the app is not complete and it's up to you to complete it. There is a backlog of features to implement and some nice to have (bonus) features. 

The backend server is a bit unstable which the app needs to handle.

## Backlog (required):

We need 2 new features in this task: *add* and *remove* locations.

All API requests require a `X-Api-Key` HTTP header. One `X-Api-Key` is generated for you on app install and is used when fetching current stored locations.

### 1. Add a new location 

Implement the functionality to add a new location. 

**URL** : `https://app-code-test.kry.pet/locations`

**Required header**: `X-Api-Key`

**Method**: `POST`

**Data constraints**

Provide name of location and weather together with temperature. All fields are required except `id`. If `id` is omitted, one will be created for you.

```json
{
    "id": "optional string",
    "name": "location name",
    "status": "SUNNY",
    "temperature": 20
}
```

#### Success Response

**Code** : `200`

**Content** : 
```json
{
    "id": "optional string",
    "name": "location name",
    "status": "SUNNY",
    "temperature": 20
}
```

#### Error Response

**Condition** : If required field is missing

**Code** : `400`

##### Or unknown

**Code** : `500`

### 2. Remove a location 

Implement the functionality to remove a location. Parameter `:id` is required to identify which location should be deleted.

**URL** : `https://app-code-test.kry.pet/locations/:id`

**Required header**: `X-Api-Key`

**Method**: `DELETE`

**Data constraints**

`id` of location

#### Success Response

**Code** : `200`

#### Error Response

**Condition** : If `id` missing or invalid.

**Code** : `400`

##### Or unknown

**Code** : `500`

## Nice to haves (optional):

- Add nice animations
- Improvements to code
- Tests

Spend two to four hours working on this assignment - make sure to finish the issues you start.

Put the code in a GitHub repository and send us the link (niklas.holmqvist@kry.se) when you're done. 

Good luck! ☺️
