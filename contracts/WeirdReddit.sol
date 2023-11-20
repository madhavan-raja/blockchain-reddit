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
        Subreddit subreddit;
        string title;
        string content;
    }

    Subreddit[] subreddits;
    Post[] posts;

    /**
     * @dev Create a subreddit
     * @param subredditName value to store
     */
    function createSubreddit(string memory subredditName) public {
        Subreddit memory newSubreddit = Subreddit(subredditName);

        for (uint i = 0; i < subreddits.length; ++i) {
            if (compare(subreddits[i].subredditName, newSubreddit.subredditName)) {
                return; // Handle Error
            }
        }

        subreddits.push(newSubreddit);
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function getSubreddits() public view returns (Subreddit[] memory) {
        return subreddits;
    }
}