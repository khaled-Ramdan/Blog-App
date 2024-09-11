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
   git clone https://github.com/khaled-Ramdan/Blog-App.git
   cd Blog-App


## How to run?
- have docker installed on your machine
- run `docker-compose up` command

## Demo 


https://github.com/user-attachments/assets/8147a1dc-238a-4dd1-827f-f176647c10ab



## Posts Schedule Deletion


https://github.com/user-attachments/assets/2637326d-10fc-4ae3-81d7-a4ab79c9df43

- This Video is to validate Job Deletion of posts after 24 hours of creating them. In this case, the time was reduced to 10 seconds to ensure posts were deleted. 
- note: The `/sidekiq` route is removed from the uploaded code version to maintain security.

## Routes Testing

- you can use the command `rspec` to test your API end points.
![specs](https://github.com/user-attachments/assets/f5be5e2c-ca19-47e1-ac8b-0e633794ea3f)



