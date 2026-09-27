CREATE TYPE role_name AS ENUM ('user', 'admin', 'moderator', 'financal_analyst');

CREATE TABLE role (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name role_name NOT NULL UNIQUE
);

CREATE TABLE user (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_wt_roles (
    role_id INT REFERENCES role(id),
    user_id INT REFERENCES user(id),
    PRIMARY KEY(role_id, user_id)
);
