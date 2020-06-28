Server mock
===

This is a simple program to mock any API, any path, any response body, status (well, not really, but coming soon). Simply run as `ruby mock-server.rb <port> <path-to.json>`. First parameter is the desired port, while the second parameter is the path to a JSON with the following structure:

```json
[
  {
    "path": "/mocked/path",
    "method": "POST",
    "status": 200, 
    "body": {
      "name":"alesaurio",
      "favourite_number":42
    }
  }
]
```
`method` should be one of the HTTP methods (GET, POST, etc) upper case. Body can be anything: complex object, just an int, a string, whatever.
