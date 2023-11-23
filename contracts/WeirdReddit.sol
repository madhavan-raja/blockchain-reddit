// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title WeirdReddit
 * @dev Write and view posts on WeirdReddit
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract WeirdReddit {
    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    struct Subreddit {
        string subredditName;
    }

    struct Post {
        string id;
        string subredditName;
        string title;
        string content;
    }

    Subreddit[] subreddits;
    Post[] posts;

    /**
     * @dev Create a subreddit
     * @param subredditName Name of the new subreddit
     */
    function createSubreddit(string memory subredditName) public {
        require(!verifySubreddit(subredditName), "Subreddit already exists.");
        
        Subreddit memory newSubreddit = Subreddit(subredditName);
        subreddits.push(newSubreddit);
    }

    /**
     * @dev Check whether a subreddit exists 
     * @return Whether a subreddit exists
     */
    function verifySubreddit(string memory subredditName) private view returns (bool) {
        for (uint i = 0; i < subreddits.length; ++i) {
            if (compare(subreddits[i].subredditName, subredditName)) {
                return true;
            }
        }

        return false;
    }

    /**
     * @dev Return the values of all subreddits 
     * @return Values of all subreddits
     */
    function getSubreddits() public view returns (Subreddit[] memory) {
        return subreddits;
    }

    /**
     * @dev Create a post
     * @param subredditName Name of the new subreddit
     */
    function createPost(string memory id, string memory subredditName, string memory postTitle, string memory postContent) public {
        require(!verifyPost(id), "Post with ID already exists.");
        require(verifySubreddit(subredditName), "Subreddit does not exist.");

        Post memory newPost = Post(id, subredditName, postTitle, postContent);
        posts.push(newPost);
    }

    /**
     * @dev Get the index of the post with some ID 
     * @return The index of the post with some ID
     */
    function getPostIndex(string memory id) private view returns (uint) {
        for (uint i = 0; i < posts.length; ++i) {
            if (compare(posts[i].id, id)) {
                return i;
            }
        }

        return posts.length;
    }

    /**
     * @dev Check whether a post exists 
     * @return Whether a post exists
     */
    function verifyPost(string memory id) private view returns (bool) {
        return getPostIndex(id) < posts.length;
    }

    /**
     * @dev Return all posts
     * @return Values of all posts
     */
    function getPosts() public view returns (Post[] memory) {
        return posts;
    }

    /**
     * @dev Return all posts in a subreddit
     * @return Values of all posts in a subreddit
     */
    function getPostsInSubreddit(string memory subredditName) public view returns (Post[] memory) {
        require(verifySubreddit(subredditName), "Subreddit does not exist.");

        uint filterSize = 0;
        uint index = 0;

        for (uint i = 0; i < posts.length; ++i) {
            if (compare(posts[i].subredditName, subredditName)) {
                ++filterSize;
            }
        }

        Post[] memory filteredPosts = new Post[](filterSize);

        for (uint i = 0; i < posts.length; ++i) {
            if (compare(posts[i].subredditName, subredditName)) {
                filteredPosts[index] = posts[i];
                ++index;
            }
        }

        return filteredPosts;
    }

    /**
     * @dev Return posts with given ID
     * @return Values of all posts in a subreddit
     */
    function getPost(string memory id) public view returns (Post memory) {
        uint postIndex = getPostIndex(id);

        require(postIndex < posts.length, "Post does not exist.");

        return posts[postIndex];
    }

    /**
     * @dev Modify post with given ID
     */
    function modifyPost(string memory id, string memory newPostTitle, string memory newPostContent) public {
        for (uint i = 0; i < posts.length; ++i) {
            if (compare(posts[i].id, id)) {
                posts[i].title = newPostTitle;
                posts[i].content = newPostContent;
            }
        }
    }

    /**
     * @dev Changes the subreddit of post with given ID
     */
    function changeSubreddit(string memory id, string memory newSubredditName) public {
        require(verifySubreddit(newSubredditName), "Subreddit does not exist.");

        for (uint i = 0; i < posts.length; ++i) {
            if (compare(posts[i].id, id)) {
                posts[i].subredditName = newSubredditName;
            }
        }
    }
}