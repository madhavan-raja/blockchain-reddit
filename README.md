# Blockchain Reddit

## Endpoints

- `CreateSubreddit(subredditName)`: Create a subreddit with a name
- `GetSubreddits()`: Get a list of all subreddits
- `VerifySubreddit(subredditName)`: Verify if a subreddit exists
- `CreatePost(postID, subredditName, postTitle, postBody)`: Create a post in a subreddit with some parameters
- `GetPosts(subredditName)`: Get all the posts in a subreddit
- `GetPost(postID)`: Get the post with the `postID`
- `ModifyPost(postID, postTitle, postBody)`: Modify the title and body of a post
- `ChangeOwnership(postID, subredditName)`: Modify the subreddit name of a post
