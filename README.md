# README

# My Rails Application

## Overview

This application provides a platform where users can authenticate, create, manage, and interact with posts and comments. The application uses Ruby on Rails and PostgreSQL.

## Features

### Authentication and Authorization

- **User Authentication**
  - Users can sign up and log in using their email and password.
  - JWT (JSON Web Tokens) is used for API authentication.
  
- **User Model**
  - **Fields**:
    - `name`
    - `email`
    - `password`
    - `image`

- **Authentication**:
  - All API endpoints are protected and require authentication. 

### Post Management

- **Post Model**
  - **Fields**:
    - `title`
    - `body`
    - `author` (References the User model)
    - `tags` (Each post must have at least one tag)
    - `comments` (Associated with posts)
  
- **CRUD Operations**:
  - **Create**: Users can create posts.
  - **Edit/Delete**: Users can only edit or delete their own posts.
  - **Tags**: Users can update the tags of their posts.
  - **Expiration**: Posts are automatically deleted 24 hours after creation.

### Comment Management

- **Features**:
  - Users can add comments to any post.
  - Users can only edit or delete their own comments.

## Technology Stack

- **Framework**: Ruby on Rails
- **Database**: PostgreSQL

## Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-directory>


## How to run ?
1 - have docker installed to your machine
2 - run `docker-compose up` command

