# RESTFull Security

In this section you will find a few examples on how to secure your RESTFull application.


## Basic Authentication

    The main problem with this security implementation is that credentials are propagated in a plain way from the client to the server.
    This way, any sniffer could read the sent packages over the network.
    Excerpt From: Rene Enríquez. “RESTful Java Web Services Security.”

* Read the instructions in the index.html file of the project to get it to work.


## Digest Authentication


    This authentication method makes use of a hash function to encrypt the password
    entered by the user before sending it to the server. This, obviously, makes it
    much safer than the basic authentication method, in which the user's password
    travels in plain text that can be easily read by whoever intercepts it. To
    overcome such drawbacks, digest md5 authentication applies a function on the
    combination of the values of the username, realm of application security,
    and password. As a result, we obtain an encrypted string that can hardly
    be interpreted by an intruder.

* Read the instructions in the index.html file of the project to get it to work.
