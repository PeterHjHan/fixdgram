# README

# Fixdgram API

FixdGram API exposes a REST API allowing any client to retrieve the data regarding to the application.

## Endpoint References

#### Headers

The following headers are required to make receive calls
* `Content-Type = 'application/json'`
* `Authorization = '[user-token]'`

The user-token can be retrieved by using the authentication api route

##### Authentication

| Method | Url |
| -------|:---:|
| POST| /api/authentication|

