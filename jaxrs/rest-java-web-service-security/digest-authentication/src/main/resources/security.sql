DROP TABLE "GROUPS_USERS";
DROP TABLE "USERS";
DROP TABLE "GROUPS";


CREATE TABLE GROUPS
(
    GROUP_ID VARCHAR(20) PRIMARY KEY NOT NULL
);

CREATE TABLE USERS
(
    USER_ID  VARCHAR(100) PRIMARY KEY NOT NULL,
    PASSWORD VARCHAR(128)             NOT NULL
);

CREATE TABLE GROUPS_USERS
(
    GROUP_ID VARCHAR(20)  NOT NULL,
    USER_ID  VARCHAR(100) NOT NULL,
    FOREIGN KEY (GROUP_ID) REFERENCES GROUPS (GROUP_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
);
