# Client Certificate Authentication

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
