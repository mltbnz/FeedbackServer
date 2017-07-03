## About

The Feedbacktool is an API written in Swift to save Feedback to a DB.
The app runs on heroku under [Feedbacktool](https://feedbacktoolapp.herokuapp.com/)

## Usage

#### Feedback

GET, POST, DELETE, UPDATE

##### POST
To post a feedback to the API.
```javascript
{
	"id": "1",
	"project_id": 1,
	"feedback": "You are so awesome ❤️",
	"os": "iOS",
	"stars": 5
}
```

##### GET
Gets all feedback from the API.
```
localhost:8080/feedback
```

##### SHOW
Show a specific feedback identified by its id.
```
localhost:8080/feedback/1
```


#### Project

GET, POST, DELETE, UPDATE

##### POST
To post a project to the API.
```javascript
{
	"id": "1",
	"name": "Tool"
}
```

##### GET
Gets all project from the API.
```
localhost:8080/project
```

##### SHOW
Show all feedbacks related to the project. Append the project id
```
localhost:8080/project/1
```
