# Reddit on the Blockchain
A lower-scale variation of [Reddit](https://www.reddit.com/) (mixed with some features from [4chan](https://www.4chan.org/)) that runs on the Blockchain. Users can create subreddits and posts, and modify said posts. The use of media and subreddit moderation is not supported at the moment. Every user is anonymous, and thus no account creation is required.

This is a course project created by Madhavan Raja, Ava Caiola, and Ashish Rastogi for CSE 598: Engineering Blockchain Application (Fall '23) at Arizona State University.

## Installation
This application is written in Solidity and [Remix](https://remix.ethereum.org/) can be used to deploy and run this application.

- In Remix, open the menu beside "Workspaces" and click on "Clone".
- Paste the Git Repository URL in the dialog that opens: `https://github.com/madhavan-raja/blockchain-reddit.git`.
- Open the file `contracts/WeirdReddit.sol`.
- Compile the file using the Green Play Button in the tab bar (or press `CTRL + S`).
- Open the "Deploy and Run Transactions" section on the sidebar.
- Select any environment. `Remix VM` would be good enough for testing.
- Select "WeirdReddit" as the contract to deploy and set the gas limits accordingly.
- Click on "Deploy".
- Under "Deployed Contracts", expand the contract that was just deployed.
- Use the functions provided there to invoke operations (described in the following section) on the Blockchain.

## Usage
The following endpoints can be invoked:
- `createSubreddit(subredditName)`: Create a subreddit with the specified name
- `getSubreddits()`: Get a list of all subreddits
- `createPost(id, subredditName, postTitle, postContent)`: Create a post in a subreddit with the specified parameters
- `getPosts()`: Get all posts
- `getPostsInSubreddit(subredditName)`: Get all the posts in the specified subreddit
- `getPost(postID)`: Get the post with the specified ID
- `modifyPost(postID, postTitle, postBody)`: Modify the title and body of a post with the specified ID
- `changeSubreddit(postID, subredditName)`: Modify the subreddit of a post with the specified ID
