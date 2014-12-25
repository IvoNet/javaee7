# RESTFull Security

In this section you will find a few examples on how to secure your RESTFull application.


## Basic Authentication

A Glassfish version of the basic authentication example from
“RESTful Java Web Services Security.”

    The main problem with this security implementation is that credentials are propagated
    in a plain way from the client to the server.
    This way, any sniffer could read the sent packages over the network.
    Excerpt From: Rene Enríquez. “RESTful Java Web Services Security.”

* Read the instructions in the index.html file of the project to get it to work.


## Digest Authentication

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


## Client Certificate Authentication

A Glassfish version of the client certificate authentication example from
“RESTful Java Web Services Security.”

    When the client attempts to access a protected resource, instead of providing
    a username or password, it presents the certificate to the server. This is the
    certificate that contains the user information for authentication; in other words,
    the credentials, besides a unique private-public key pair. The server determines
    if the user is legitimate through the CA. Then, it verifies whether the user has
    access to the resource. Also, you should know that this authentication mechanism
    must use HTTPS as the communication protocol as we don't have a secure channel
    and anyone could steal the client's identity.
    Excerpt From: Rene Enríquez. “RESTful Java Web Services Security.”

* Read the instructions in the index.html file of the project to get it to work.
