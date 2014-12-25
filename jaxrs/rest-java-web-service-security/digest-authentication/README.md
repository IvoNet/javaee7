# Digest Authentication

A Glassfish version of the digest authentication example from
“RESTful Java Web Services Security.”

    This authentication method makes use of a hash function to encrypt the password
    entered by the user before sending it to the server. This, obviously, makes it
    much safer than the basic authentication method, in which the user's password
    travels in plain text that can be easily read by whoever intercepts it. To
    overcome such drawbacks, digest md5 authentication applies a function on the
    combination of the values of the username, realm of application security,
    and password. As a result, we obtain an encrypted string that can hardly
    be interpreted by an intruder.
    Excerpt From: Rene Enríquez. “RESTful Java Web Services Security.”

* Read the instructions in the index.html file of the project to get it to work.
